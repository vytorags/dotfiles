import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

QtObject {
    id: root

    property var pluginService: null
    property string pluginId: "dankTranslate"
    property string trigger: ">"
    property string defaultLang: "en"
    property string _lastQuery: ""
    property string _lastResult: ""
    property bool _translating: false
    property bool _error: false

    signal itemsChanged

    Component.onCompleted: {
        if (!pluginService)
            return;
        trigger = pluginService.loadPluginData(pluginId, "trigger", ">");
        defaultLang = pluginService.loadPluginData(pluginId, "defaultLang", "en");
    }

    property Timer debounceTimer: Timer {
        interval: 300
        onTriggered: {
            if (root._pendingQuery)
                root.startTranslation(root._pendingQuery, root._pendingLang);
        }
    }

    property string _pendingQuery: ""
    property string _pendingLang: ""

    function parseQuery(raw) {
        var trimmed = raw.trim();
        if (trimmed.length === 0)
            return { lang: defaultLang, text: "" };

        var words = trimmed.split(/\s+/);
        // If first word is a 2-3 char language code, use it as target
        if (words.length > 1 && words[0].length >= 2 && words[0].length <= 3 && /^[a-z]+$/i.test(words[0])) {
            return {
                lang: words[0].toLowerCase(),
                text: words.slice(1).join(" ")
            };
        }

        return { lang: defaultLang, text: trimmed };
    }

    function startTranslation(text, lang) {
        if (transProcess.running)
            transProcess.running = false;
        _translating = true;
        _error = false;
        transProcess.command = ["trans", "-brief", "-t", lang, text];
        transProcess.running = true;
    }

    property Process transProcess: Process {
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                root._translating = false;
                root._lastResult = text.trim();
                if (root.pluginService)
                    root.pluginService.requestLauncherUpdate(root.pluginId);
            }
        }

        onExited: exitCode => {
            if (exitCode !== 0) {
                root._translating = false;
                root._lastResult = "";
                root._error = true;
                if (root.pluginService)
                    root.pluginService.requestLauncherUpdate(root.pluginId);
            }
        }
    }

    function getItems(query) {
        if (!query || query.trim().length === 0) {
            return [{
                name: "Type text to translate",
                icon: "material:translate",
                comment: "Default target: " + defaultLang + " | Prefix a language code to override (e.g. pt hello)",
                action: "none:",
                categories: ["Translate"],
                _preScored: 1000
            }];
        }

        var parsed = parseQuery(query);

        if (parsed.text.length === 0) {
            return [{
                name: "Type text after language code",
                icon: "material:translate",
                comment: "Translating to: " + parsed.lang,
                action: "none:",
                categories: ["Translate"],
                _preScored: 1000
            }];
        }

        var queryKey = parsed.lang + ":" + parsed.text;
        if (queryKey !== _lastQuery) {
            _lastQuery = queryKey;
            _lastResult = "";
            _error = false;
            _pendingQuery = parsed.text;
            _pendingLang = parsed.lang;
            debounceTimer.restart();
        }

        if (_error) {
            return [{
                name: "Translation failed",
                icon: "material:error_outline",
                comment: parsed.text + " -> " + parsed.lang,
                action: "none:",
                categories: ["Translate"],
                _preScored: 1000
            }];
        }

        if (_translating || !_lastResult) {
            return [{
                name: "Translating...",
                icon: "material:hourglass_empty",
                comment: parsed.text + " -> " + parsed.lang,
                action: "none:",
                categories: ["Translate"],
                _preScored: 1000
            }];
        }

        // Split multi-line results into separate items
        var lines = _lastResult.split("\n").filter(function(l) { return l.trim().length > 0; });
        return lines.map(function(line) {
            return {
                name: line,
                icon: "material:translate",
                comment: parsed.text + " -> " + parsed.lang,
                action: "copy:" + line,
                categories: ["Translate"],
                _preScored: 1000
            };
        });
    }

    function executeItem(item) {
        if (!item?.action)
            return;
        var colonIdx = item.action.indexOf(":");
        if (colonIdx === -1)
            return;
        var actionType = item.action.substring(0, colonIdx);
        var actionData = item.action.substring(colonIdx + 1);

        if (actionType === "copy" && actionData) {
            Quickshell.execDetached(["sh", "-c", "printf '%s' \"$1\" | wl-copy", "sh", actionData]);
            if (typeof ToastService !== "undefined")
                ToastService.showInfo("Translate", "Copied to clipboard");
        }
    }

    onTriggerChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData(pluginId, "trigger", trigger);
    }

    onDefaultLangChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData(pluginId, "defaultLang", defaultLang);
    }
}
