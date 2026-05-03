.pragma library

const CONFIG = {
    DEBOUNCE_INTERVAL: 300,
    MAX_INPUT_LENGTH: 100000,
    MAX_OUTPUT_LENGTH: 50000
};

const TIMESTAMP = {
    MIN_SECONDS_LENGTH: 9,
    MAX_SECONDS_LENGTH: 11,
    MIN_MS_LENGTH: 12,
    MAX_MS_LENGTH: 14
};

function tr(key) {
    if (typeof I18n !== 'undefined' && I18n.tr) {
        return I18n.tr(key, "DeveloperUtilities");
    }
    return key;
}

function truncateOutput(text, maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + "\n\n... [" + tr("Output truncated") + "]";
}

function isValidBase64(str) {
    if (!/^[A-Za-z0-9+/]+=*$/.test(str)) return false;
    if (str.length % 4 !== 0) return false;
    if (str.length < 8) return false;
    var hasDigitOrSpecial = /[0-9+/]/.test(str);
    var hasMixedCase = /[a-z]/.test(str) && /[A-Z]/.test(str);
    return hasDigitOrSpecial || (hasMixedCase && str.length >= 16);
}

function isValidBase64Url(str) {
    if (!/^[A-Za-z0-9\-_]+=*$/.test(str)) return false;
    return str.length >= 8;
}

function hexToRgb(hex) {
    hex = hex.replace(/^#/, "");
    if (hex.length === 3) {
        hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }
    if (hex.length === 8) {
        return {
            r: parseInt(hex.substring(0, 2), 16),
            g: parseInt(hex.substring(2, 4), 16),
            b: parseInt(hex.substring(4, 6), 16),
            a: parseInt(hex.substring(6, 8), 16) / 255
        };
    }
    return {
        r: parseInt(hex.substring(0, 2), 16),
        g: parseInt(hex.substring(2, 4), 16),
        b: parseInt(hex.substring(4, 6), 16),
        a: 1
    };
}

function rgbToHex(r, g, b, a) {
    var hex = "#" +
        ("0" + Math.round(r).toString(16)).slice(-2) +
        ("0" + Math.round(g).toString(16)).slice(-2) +
        ("0" + Math.round(b).toString(16)).slice(-2);
    if (a !== undefined && a < 1) {
        hex += ("0" + Math.round(a * 255).toString(16)).slice(-2);
    }
    return hex.toUpperCase();
}

function rgbToHsl(r, g, b) {
    r /= 255;
    g /= 255;
    b /= 255;
    var max = Math.max(r, g, b);
    var min = Math.min(r, g, b);
    var h, s, l = (max + min) / 2;

    if (max === min) {
        h = s = 0;
    } else {
        var d = max - min;
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
        switch (max) {
            case r: h = ((g - b) / d + (g < b ? 6 : 0)) / 6; break;
            case g: h = ((b - r) / d + 2) / 6; break;
            case b: h = ((r - g) / d + 4) / 6; break;
        }
    }
    return {
        h: Math.round(h * 360),
        s: Math.round(s * 100),
        l: Math.round(l * 100)
    };
}

function hslToRgb(h, s, l) {
    h /= 360;
    s /= 100;
    l /= 100;
    var r, g, b;

    if (s === 0) {
        r = g = b = l;
    } else {
        function hue2rgb(p, q, t) {
            if (t < 0) t += 1;
            if (t > 1) t -= 1;
            if (t < 1/6) return p + (q - p) * 6 * t;
            if (t < 1/2) return q;
            if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
            return p;
        }
        var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
        var p = 2 * l - q;
        r = hue2rgb(p, q, h + 1/3);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1/3);
    }
    return {
        r: Math.round(r * 255),
        g: Math.round(g * 255),
        b: Math.round(b * 255)
    };
}

function isHexString(str) {
    return /^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$/.test(str.trim());
}

function isRgbString(str) {
    var match = str.trim().match(/^rgba?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})(?:\s*,\s*([\d.]+))?\s*\)$/i);
    if (!match) return false;
    var r = parseInt(match[1]), g = parseInt(match[2]), b = parseInt(match[3]);
    return r <= 255 && g <= 255 && b <= 255;
}

function isHslString(str) {
    var match = str.trim().match(/^hsla?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})%?\s*,\s*(\d{1,3})%?(?:\s*,\s*([\d.]+))?\s*\)$/i);
    if (!match) return false;
    var h = parseInt(match[1]), s = parseInt(match[2]), l = parseInt(match[3]);
    return h <= 360 && s <= 100 && l <= 100;
}

function parseRgb(str) {
    var match = str.trim().match(/^rgba?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})(?:\s*,\s*([\d.]+))?\s*\)$/i);
    return {
        r: parseInt(match[1]),
        g: parseInt(match[2]),
        b: parseInt(match[3]),
        a: match[4] !== undefined ? parseFloat(match[4]) : 1
    };
}

function parseHsl(str) {
    var match = str.trim().match(/^hsla?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})%?\s*,\s*(\d{1,3})%?(?:\s*,\s*([\d.]+))?\s*\)$/i);
    return {
        h: parseInt(match[1]),
        s: parseInt(match[2]),
        l: parseInt(match[3]),
        a: match[4] !== undefined ? parseFloat(match[4]) : 1
    };
}

function processColor(input, results) {
    var trimmed = input.trim();
    
    if (isHexString(trimmed)) {
        var rgb = hexToRgb(trimmed);
        var hsl = rgbToHsl(rgb.r, rgb.g, rgb.b);
        
        results.push({
            type: "Color",
            label: tr("HEX to RGB"),
            content: "rgb(" + rgb.r + ", " + rgb.g + ", " + rgb.b + ")" +
                     (rgb.a < 1 ? "\nrgba(" + rgb.r + ", " + rgb.g + ", " + rgb.b + ", " + rgb.a.toFixed(2) + ")" : "")
        });
        
        results.push({
            type: "Color",
            label: tr("HEX to HSL"),
            content: "hsl(" + hsl.h + ", " + hsl.s + "%, " + hsl.l + "%)" +
                     (rgb.a < 1 ? "\nhsla(" + hsl.h + ", " + hsl.s + "%, " + hsl.l + "%, " + rgb.a.toFixed(2) + ")" : "")
        });
        return true;
    }
    
    if (isRgbString(trimmed)) {
        var rgbVal = parseRgb(trimmed);
        var hexVal = rgbToHex(rgbVal.r, rgbVal.g, rgbVal.b, rgbVal.a);
        var hslVal = rgbToHsl(rgbVal.r, rgbVal.g, rgbVal.b);
        
        results.push({
            type: "Color",
            label: tr("RGB to HEX"),
            content: hexVal
        });
        
        results.push({
            type: "Color",
            label: tr("RGB to HSL"),
            content: "hsl(" + hslVal.h + ", " + hslVal.s + "%, " + hslVal.l + "%)" +
                     (rgbVal.a < 1 ? "\nhsla(" + hslVal.h + ", " + hslVal.s + "%, " + hslVal.l + "%, " + rgbVal.a.toFixed(2) + ")" : "")
        });
        return true;
    }
    
    if (isHslString(trimmed)) {
        var hslVal2 = parseHsl(trimmed);
        var rgbVal2 = hslToRgb(hslVal2.h, hslVal2.s, hslVal2.l);
        var hexVal2 = rgbToHex(rgbVal2.r, rgbVal2.g, rgbVal2.b, hslVal2.a);
        
        results.push({
            type: "Color",
            label: tr("HSL to HEX"),
            content: hexVal2
        });
        
        results.push({
            type: "Color",
            label: tr("HSL to RGB"),
            content: "rgb(" + rgbVal2.r + ", " + rgbVal2.g + ", " + rgbVal2.b + ")" +
                     (hslVal2.a < 1 ? "\nrgba(" + rgbVal2.r + ", " + rgbVal2.g + ", " + rgbVal2.b + ", " + hslVal2.a.toFixed(2) + ")" : "")
        });
        return true;
    }
    
    return false;
}

function process(input, settings) {
    if (!input || input.trim() === "") {
        return { results: [], error: null, truncated: false };
    }

    var trimmedInput = input.trim();
    var results = [];
    var errors = [];

    var enabledFeatures = settings || {
        enableColor: true,
        enableJson: true,
        enableJwt: true,
        enableTimestamp: true,
        enableUrl: true,
        enableBase64: true,
        enableNumber: true
    };

    if (input.length > CONFIG.MAX_INPUT_LENGTH) {
        return {
            results: [],
            error: tr("Input too long") + " (" + input.length + " " + tr("chars") + "). " + tr("Max") + ": " + CONFIG.MAX_INPUT_LENGTH,
            truncated: true
        };
    }

    if (enabledFeatures.enableColor) {
        processColor(trimmedInput, results);
    }

    if (enabledFeatures.enableJson && (trimmedInput.startsWith("{") || trimmedInput.startsWith("["))) {
        try {
            var parsed = JSON.parse(trimmedInput);
            var formatted = JSON.stringify(parsed, null, 4);
            if (formatted !== trimmedInput) {
                results.push({
                    type: "JSON",
                    label: tr("JSON Format"),
                    content: formatted,
                    needHighlight: true
                });
            }
            var compressed = JSON.stringify(parsed);
            if (compressed !== trimmedInput && compressed !== formatted) {
                results.push({
                    type: "JSON",
                    label: tr("JSON Minify"),
                    content: compressed
                });
            }
        } catch (e) {
            errors.push({ type: "JSON", message: tr("JSON parse failed") + ": " + e.message });
        }
    }

    if (enabledFeatures.enableJwt) {
        var jwtParts = trimmedInput.split('.');
        if (jwtParts.length === 3 && jwtParts.every(function(p) { return p.length > 0; })) {
            try {
                var headerB64 = jwtParts[0].replace(/-/g, '+').replace(/_/g, '/');
                while (headerB64.length % 4) headerB64 += '=';
                var decodedHeader = Qt.atob(headerB64);
                var jsonHeader = JSON.parse(decodedHeader);

                var payloadB64 = jwtParts[1].replace(/-/g, '+').replace(/_/g, '/');
                while (payloadB64.length % 4) payloadB64 += '=';
                var decodedPayload = Qt.atob(payloadB64);
                var jsonPayload = JSON.parse(decodedPayload);

                var headerFormatted = JSON.stringify(jsonHeader, null, 4);
                var payloadFormatted = JSON.stringify(jsonPayload, null, 4);
                var jwtContent = "=== " + tr("Header") + " ===\n" + headerFormatted +
                               "\n\n=== " + tr("Payload") + " ===\n" + payloadFormatted;
                results.push({
                    type: "JWT",
                    label: tr("JWT Decode"),
                    content: jwtContent,
                    needHighlight: true
                });
            } catch (e) {
                errors.push({ type: "JWT", message: tr("JWT parse failed") });
            }
        }
    }

    if (enabledFeatures.enableTimestamp && /^\d+$/.test(trimmedInput)) {
        var num = Number(trimmedInput);
        var len = trimmedInput.length;

        if (len >= TIMESTAMP.MIN_SECONDS_LENGTH && len <= TIMESTAMP.MAX_SECONDS_LENGTH) {
            var dateSec = new Date(num * 1000);
            if (!isNaN(dateSec.getTime())) {
                results.push({
                    type: "Timestamp",
                    label: tr("Timestamp (sec) to Date"),
                    content: dateSec.toLocaleString(Qt.locale(), "yyyy-MM-dd HH:mm:ss")
                });
            }
        }
        else if (len >= TIMESTAMP.MIN_MS_LENGTH && len <= TIMESTAMP.MAX_MS_LENGTH) {
            var dateMs = new Date(num);
            if (!isNaN(dateMs.getTime())) {
                results.push({
                    type: "Timestamp",
                    label: tr("Timestamp (ms) to Date"),
                    content: dateMs.toLocaleString(Qt.locale(), "yyyy-MM-dd HH:mm:ss")
                });
            }
        }
    }

    if (enabledFeatures.enableTimestamp && (/[-\/:\sT]/.test(trimmedInput) && !/^\d+$/.test(trimmedInput))) {
        var dateParsed = Date.parse(trimmedInput);
        if (!isNaN(dateParsed)) {
            results.push({
                type: "Timestamp",
                label: tr("Date to Timestamp (sec)"),
                content: Math.floor(dateParsed / 1000).toString()
            });
            results.push({
                type: "Timestamp",
                label: tr("Date to Timestamp (ms)"),
                content: dateParsed.toString()
            });
        }
    }

    if (enabledFeatures.enableUrl && trimmedInput.includes('%')) {
        try {
            var decodedUrl = decodeURIComponent(trimmedInput);
            if (decodedUrl !== trimmedInput) {
                results.push({
                    type: "URL",
                    label: tr("URL Decode"),
                    content: decodedUrl
                });
            }
        } catch (e) {
            errors.push({ type: "URL", message: tr("URL decode failed") });
        }
    }

    var wasBase64Decoded = false;
    if (enabledFeatures.enableBase64 && isValidBase64(trimmedInput)) {
        try {
            var padded = trimmedInput;
            while (padded.length % 4) padded += '=';
            var decodedB64 = Qt.atob(padded);

            if (/^[\x20-\x7E\u4e00-\u9fa5\u0800-\uFFFF\s]*$/.test(decodedB64) && decodedB64.length > 0) {
                results.push({
                    type: "Base64",
                    label: tr("Base64 Decode"),
                    content: decodedB64
                });
                wasBase64Decoded = true;
            }
        } catch (e) {
            errors.push({ type: "Base64", message: tr("Base64 decode failed") });
        }
    }

    if (enabledFeatures.enableBase64 && !wasBase64Decoded) {
        var b64Encoded = Qt.btoa(input);
        if (b64Encoded !== input) {
            results.push({
                type: "Base64",
                label: tr("Base64 Encode"),
                content: b64Encoded
            });
        }
    }

    if (enabledFeatures.enableUrl) {
        var needsUrlEncode = /[^\w\-.~]/.test(input);
        if (needsUrlEncode) {
            var urlEncoded = encodeURIComponent(input);
            if (urlEncoded !== input) {
                results.push({
                    type: "URL",
                    label: tr("URL Encode"),
                    content: urlEncoded
                });
            }
        }
    }

    if (enabledFeatures.enableNumber) {
        if (/^-?(0x[0-9A-Fa-f]+|0b[01]+|0o[0-7]+|\d+)$/i.test(trimmedInput)) {
            var numVal = null;
            var base = 10;
            var isNegative = trimmedInput.startsWith('-');
            var absInput = isNegative ? trimmedInput.substring(1) : trimmedInput;
            
            if (/^0x[0-9A-Fa-f]+$/i.test(absInput)) {
                numVal = parseInt(absInput, 16);
                base = 16;
            } else if (/^0b[01]+$/i.test(absInput)) {
                numVal = parseInt(absInput.substring(2), 2);
                base = 2;
            } else if (/^0o[0-7]+$/i.test(absInput)) {
                numVal = parseInt(absInput.substring(2), 8);
                base = 8;
            } else if (/^\d+$/.test(absInput)) {
                numVal = parseInt(absInput, 10);
                base = 10;
            }
            
            if (numVal !== null && !isNaN(numVal)) {
                if (numVal > Number.MAX_SAFE_INTEGER) {
                    errors.push({ type: "Number", message: tr("Value exceeds safe integer range") });
                } else {
                    if (isNegative) numVal = -numVal;
                    
                    if (base !== 2) {
                        results.push({
                            type: "Number",
                            label: tr("Binary"),
                            content: "0b" + Math.abs(numVal).toString(2)
                        });
                    }
                    if (base !== 8) {
                        results.push({
                            type: "Number",
                            label: tr("Octal"),
                            content: "0o" + Math.abs(numVal).toString(8)
                        });
                    }
                    if (base !== 10) {
                        results.push({
                            type: "Number",
                            label: tr("Decimal"),
                            content: numVal.toString(10)
                        });
                    }
                    if (base !== 16) {
                        results.push({
                            type: "Number",
                            label: tr("Hexadecimal"),
                            content: (numVal < 0 ? "-0x" : "0x") + Math.abs(numVal).toString(16).toUpperCase()
                        });
                    }
                }
            }
        }
    }

    return {
        results: results,
        errors: errors,
        truncated: false,
        config: CONFIG
    };
}

function formatOutput(processedResult) {
    if (processedResult.error) {
        return "❌ " + tr("Error") + "\n" + processedResult.error;
    }

    if (processedResult.results.length === 0) {
        return tr("No results");
    }

    var output = [];
    for (var i = 0; i < processedResult.results.length; i++) {
        var r = processedResult.results[i];
        output.push("【" + r.label + "】\n" + r.content);
    }

    var result = output.join("\n\n" + "─".repeat(40) + "\n\n");

    if (processedResult.errors.length > 0) {
        result += "\n\n" + "─".repeat(40) + "\n\n";
        result += "⚠ " + tr("Some conversions failed") + ":\n";
        for (var j = 0; j < processedResult.errors.length; j++) {
            var err = processedResult.errors[j];
            result += "• " + err.type + ": " + err.message + "\n";
        }
    }

    return truncateOutput(result, CONFIG.MAX_OUTPUT_LENGTH);
}

function getConfig() {
    return CONFIG;
}
