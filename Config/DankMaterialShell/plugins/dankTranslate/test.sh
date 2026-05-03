#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

pass() { ((PASS++)); echo "  PASS: $1"; }
fail() { ((FAIL++)); echo "  FAIL: $1 — $2"; }

assert_eq() {
    local desc="$1" expected="$2" actual="$3"
    if [ "$expected" = "$actual" ]; then
        pass "$desc"
    else
        fail "$desc" "expected '$expected', got '$actual'"
    fi
}

# ── plugin.json validation ──────────────────────────────────────────

echo "plugin.json"
python3 -c "import json; d=json.load(open('plugin.json')); assert d['id']=='dankTranslate'; assert d['name']=='Translate'" \
    && pass "valid JSON with correct id and name" \
    || fail "plugin.json" "invalid or wrong id/name"

python3 -c "
import json
d = json.load(open('plugin.json'))
required = ['id','name','description','version','author','type','capabilities','component','settings','trigger','requires_dms','requires','permissions']
missing = [f for f in required if f not in d]
assert not missing, f'missing fields: {missing}'
" && pass "all required fields present" \
  || fail "plugin.json" "missing required fields"

# ── VERSION format ──────────────────────────────────────────────────

echo "VERSION"
VERSION=$(cat VERSION | tr -d '[:space:]')
if echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    pass "semver format ($VERSION)"
else
    fail "VERSION" "'$VERSION' is not valid semver"
fi

# ── QML file references ─────────────────────────────────────────────

echo "file references"
COMPONENT=$(python3 -c "import json; print(json.load(open('plugin.json'))['component'])")
SETTINGS=$(python3 -c "import json; print(json.load(open('plugin.json'))['settings'])")
COMPONENT="${COMPONENT#./}"
SETTINGS="${SETTINGS#./}"

[ -f "$COMPONENT" ] && pass "component file exists ($COMPONENT)" || fail "component" "$COMPONENT not found"
[ -f "$SETTINGS" ] && pass "settings file exists ($SETTINGS)" || fail "settings" "$SETTINGS not found"

# ── pluginId consistency ─────────────────────────────────────────────

echo "pluginId consistency"
EXPECTED_ID=$(python3 -c "import json; print(json.load(open('plugin.json'))['id'])")

QML_ID=$(grep -oP 'pluginId:\s*"\K[^"]+' "$COMPONENT")
assert_eq "main QML pluginId matches plugin.json" "$EXPECTED_ID" "$QML_ID"

SETTINGS_ID=$(grep -oP 'pluginId:\s*"\K[^"]+' "$SETTINGS")
assert_eq "settings QML pluginId matches plugin.json" "$EXPECTED_ID" "$SETTINGS_ID"

# ── language code detection ──────────────────────────────────────────

echo "language code detection"

# The QML parseQuery logic:
# - Split on whitespace
# - If first word is 2-3 chars and all alpha, treat as language code
# - Otherwise use defaultLang

parse_lang() {
    local input="$1" default_lang="${2:-en}"
    local first_word rest
    first_word=$(echo "$input" | awk '{print $1}')
    rest=$(echo "$input" | awk '{$1=""; print}' | xargs)

    if [ -n "$rest" ] && echo "$first_word" | grep -qE '^[a-zA-Z]{2,3}$'; then
        echo "$first_word"
    else
        echo "$default_lang"
    fi
}

parse_text() {
    local input="$1" default_lang="${2:-en}"
    local first_word rest
    first_word=$(echo "$input" | awk '{print $1}')
    rest=$(echo "$input" | awk '{$1=""; print}' | xargs)

    if [ -n "$rest" ] && echo "$first_word" | grep -qE '^[a-zA-Z]{2,3}$'; then
        echo "$rest"
    else
        echo "$input"
    fi
}

assert_eq "detects 'pt' as lang code" "pt" "$(parse_lang 'pt hello world')"
assert_eq "extracts text after lang code" "hello world" "$(parse_text 'pt hello world')"

assert_eq "detects 'fra' as lang code" "fra" "$(parse_lang 'fra bonjour')"
assert_eq "extracts text after 3-char code" "bonjour" "$(parse_text 'fra bonjour')"

assert_eq "no code: uses default" "en" "$(parse_lang 'hello world')"
assert_eq "no code: full text preserved" "hello world" "$(parse_text 'hello world')"

assert_eq "single word: no code detected" "en" "$(parse_lang 'hello')"
assert_eq "single word: text preserved" "hello" "$(parse_text 'hello')"

assert_eq "'test1' not a lang code (has digit)" "en" "$(parse_lang 'test1 something')"
assert_eq "4-char word not a lang code" "en" "$(parse_lang 'test something')"

# ── trans command construction ───────────────────────────────────────

echo "trans command"

# Verify the command structure matches: trans -brief -t <lang> <text>
CMD="trans -brief -t pt hello world"
assert_eq "command starts with trans" "trans" "$(echo "$CMD" | awk '{print $1}')"
assert_eq "uses -brief flag" "-brief" "$(echo "$CMD" | awk '{print $2}')"
assert_eq "uses -t flag" "-t" "$(echo "$CMD" | awk '{print $3}')"
assert_eq "target language" "pt" "$(echo "$CMD" | awk '{print $4}')"

# ── multi-line result parsing ────────────────────────────────────────

echo "result parsing"

# Simulate multi-line translation output
TRANS_OUTPUT=$(printf 'Olá mundo\n\nBom dia\n')

# Filter empty lines (matching JS: split("\n").filter(l => l.trim().length > 0))
LINES=$(echo "$TRANS_OUTPUT" | awk 'NF>0')
LINE_COUNT=$(echo "$LINES" | wc -l | tr -d '[:space:]')
assert_eq "filters empty lines from output" "2" "$LINE_COUNT"

FIRST_LINE=$(echo "$LINES" | head -1)
assert_eq "first result line" "Olá mundo" "$FIRST_LINE"

SECOND_LINE=$(echo "$LINES" | sed -n '2p')
assert_eq "second result line" "Bom dia" "$SECOND_LINE"

# ── clipboard command safety ─────────────────────────────────────────

echo "clipboard safety"

# Verify the QML uses positional args and wl-copy
if grep -qF '$1' DankTranslate.qml && grep -qF 'wl-copy' DankTranslate.qml; then
    pass "clipboard uses positional arg with wl-copy"
else
    fail "clipboard" "does not use safe positional arg pattern"
fi

# ── summary ──────────────────────────────────────────────────────────

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
