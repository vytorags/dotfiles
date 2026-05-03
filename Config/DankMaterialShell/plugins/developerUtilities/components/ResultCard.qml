import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Common
import qs.Widgets

Rectangle {
    id: root

    property string resultType: ""
    property string resultLabel: ""
    property string resultContent: ""
    property bool needHighlight: false
    property bool expanded: true
    property bool isFullyExpanded: false
    property int shortcutIndex: -1
    property int maxExpandHeight: 500

    signal copyRequested()
    signal copyCompleted()
    signal expandRequested()

    property bool _flash: false
    property var previewColor: null

    readonly property bool _isDark: Theme.surfaceContainer.r + Theme.surfaceContainer.g + Theme.surfaceContainer.b < 1.5

    readonly property var _syntaxColors: _isDark ? {
        key: "#9CDCFE",
        string: "#CE9178",
        number: "#B5CEA8",
        boolean: "#569CD6",
        null: "#569CD6",
        section: "#569CD6"
    } : {
        key: "#0066CC",
        string: "#D14",
        number: "#099",
        boolean: "#905",
        null: "#905",
        section: "#0066CC"
    }

    function escapeHtml(str) {
        if (!str || typeof str !== "string") return ""
        return str.replace(/&/g, "&amp;")
                  .replace(/</g, "&lt;")
                  .replace(/>/g, "&gt;")
                  .replace(/ /g, "&nbsp;")
    }

    function escapeHtmlForDisplay(str) {
        if (!str || typeof str !== "string") return ""
        return str.replace(/&/g, "&amp;")
                  .replace(/</g, "&lt;")
                  .replace(/>/g, "&gt;")
                  .replace(/"/g, "&quot;")
                  .replace(/'/g, "&#039;")
                  .replace(/ /g, "&nbsp;")
    }

    function syntaxHighlightJson(json) {
        if (!json || typeof json !== "string") return ""
        try {
            var escaped = escapeHtml(json)
            var highlighted = escaped.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function(match) {
                var cls = "number"
                if (/^"/.test(match)) {
                    cls = /:$/.test(match) ? "key" : "string"
                } else if (/true|false/.test(match)) {
                    cls = "boolean"
                } else if (/null/.test(match)) {
                    cls = "null"
                }
                return "<span style=\"color:" + _syntaxColors[cls] + "\">" + match + "</span>"
            })
            return highlighted.replace(/\n/g, "<br>")
        } catch (e) {
            return escapeHtml(json)
        }
    }

    function getHighlightedContent() {
        if (!needHighlight || !resultContent) return ""
        if (resultType === "JWT") {
            var parts = resultContent.split(/=== (Header|Payload) ===/)
            var result = ""
            for (var i = 1; i < parts.length; i += 2) {
                var sectionName = parts[i]
                var sectionContent = parts[i + 1].trim()
                if (result.length > 0) result += "<br><br>"
                result += "<span style=\"color:" + _syntaxColors.section + "\">=== " + sectionName + " ===</span><br>"
                result += syntaxHighlightJson(sectionContent)
            }
            return result
        }
        return syntaxHighlightJson(resultContent)
    }

    function parseColor(content) {
        var lines = content.split('\n')
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.startsWith('#')) {
                return line
            }
            var rgbMatch = line.match(/^rgba?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})(?:\s*,\s*([\d.]+))?\s*\)$/i)
            if (rgbMatch) {
                var rVal = parseInt(rgbMatch[1])
                var gVal = parseInt(rgbMatch[2])
                var bVal = parseInt(rgbMatch[3])
                var alphaVal = rgbMatch[4] !== undefined ? parseFloat(rgbMatch[4]) : 1
                return Qt.rgba(rVal / 255, gVal / 255, bVal / 255, alphaVal)
            }
            var hslMatch = line.match(/^hsla?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})%?\s*,\s*(\d{1,3})%?(?:\s*,\s*([\d.]+))?\s*\)$/i)
            if (hslMatch) {
                var hVal = parseInt(hslMatch[1]) / 360
                var sVal = parseInt(hslMatch[2]) / 100
                var lVal = parseInt(hslMatch[3]) / 100
                var alphaVal2 = hslMatch[4] !== undefined ? parseFloat(hslMatch[4]) : 1
                return Qt.hsla(hVal, sVal, lVal, alphaVal2)
            }
        }
        return null
    }

    onResultContentChanged: {
        if (resultType === "Color") {
            previewColor = parseColor(resultContent)
        } else {
            previewColor = null
        }
    }

    onCopyCompleted: {
        _flash = true
        flashTimer.start()
    }

    Timer {
        id: flashTimer
        interval: 200
        onTriggered: root._flash = false
    }

    property color accentColor: {
        switch (resultType) {
            case "JSON": return "#4CAF50"
            case "JWT": return "#9C27B0"
            case "Base64": return "#2196F3"
            case "URL": return "#FF9800"
            case "Timestamp": return "#00BCD4"
            case "Color": return "#E91E63"
            case "Number": return "#673AB7"
            default: return Theme.primary
        }
    }

    property color cardColor: {
        switch (resultType) {
            case "JSON": return Qt.rgba(0.30, 0.69, 0.31, 0.12)
            case "JWT": return Qt.rgba(0.61, 0.15, 0.69, 0.12)
            case "Base64": return Qt.rgba(0.13, 0.59, 0.95, 0.12)
            case "URL": return Qt.rgba(1.0, 0.60, 0.0, 0.12)
            case "Timestamp": return Qt.rgba(0.0, 0.74, 0.83, 0.12)
            case "Color": return Qt.rgba(0.91, 0.12, 0.39, 0.12)
            case "Number": return Qt.rgba(0.40, 0.23, 0.72, 0.12)
            default: return Theme.surfaceContainerHigh
        }
    }

    readonly property bool isCompact: resultLabel.includes("Minify") || resultLabel.includes("Encode")
    readonly property int defaultContentHeight: isCompact ? 125 : 250
    property int contentImplicitHeight: 0

    Connections {
        target: contentColumn
        function onImplicitHeightChanged() {
            root.contentImplicitHeight = contentColumn.implicitHeight
        }
    }

    readonly property bool needsExpand: contentImplicitHeight > 0

    property int headerHeight: headerRow.height + Theme.spacingM * 2
    property int expandedContentHeight: maxExpandHeight - headerHeight - separator.height - Theme.spacingS
    property int actualContentHeight: isFullyExpanded ? Math.min(contentImplicitHeight, expandedContentHeight) : Math.min(contentImplicitHeight, defaultContentHeight)

    implicitHeight: {
        if (!expanded) {
            return headerRow.height + Theme.spacingM * 2
        }
        return headerHeight + separator.height + actualContentHeight + Theme.spacingS
    }
    color: cardColor
    radius: Theme.cornerRadius
    border.width: 1
    border.color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.3)

    Rectangle {
        anchors.fill: parent
        radius: Theme.cornerRadius
        color: Theme.primary
        opacity: root._flash ? 0.4 : 0
        visible: root._flash

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    Column {
        id: mainColumn
        anchors.fill: parent
        anchors.margins: Theme.spacingM
        spacing: Theme.spacingS

        Item {
            id: headerArea
            width: parent.width
            height: headerRow.height

            RowLayout {
                id: headerRow
                width: parent.width
                spacing: Theme.spacingS

                DankIcon {
                    name: root.expanded ? "expand_more" : "chevron_right"
                    size: 18
                    color: root.accentColor
                }

                DankIcon {
                    name: {
                        switch (root.resultType) {
                            case "JSON": return "data_object"
                            case "JWT": return "key"
                            case "Base64": return "code"
                            case "URL": return "link"
                            case "Timestamp": return "schedule"
                            case "Color": return "palette"
                            case "Number": return "tag"
                            default: return "transform"
                        }
                    }
                    size: 18
                    color: root.accentColor
                }

                StyledText {
                    text: root.resultLabel
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: root.accentColor
                    Layout.fillWidth: true
                }

                Rectangle {
                    visible: root.shortcutIndex >= 0 && root.shortcutIndex < 9
                    width: shortcutText.implicitWidth + Theme.spacingS
                    height: 20
                    radius: 4
                    color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.12)
                    border.width: 1
                    border.color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.3)

                    StyledText {
                        id: shortcutText
                        anchors.centerIn: parent
                        text: "Ctrl+" + (root.shortcutIndex + 1)
                        font.pixelSize: Theme.fontSizeSmall - 2
                        font.weight: Font.Medium
                        color: root.accentColor
                    }
                }

                DankActionButton {
                    id: expandButton
                    visible: root.needsExpand
                    iconName: root.isFullyExpanded ? "compress" : "open_in_full"
                    iconColor: hoverHandler.hovered ? root.accentColor : Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.5)
                    buttonSize: 28
                    iconSize: 16
                    tooltipSide: "left"
                    onClicked: {
                        root.expandRequested()
                    }
                    z: 1
                }

                DankActionButton {
                    id: copyButton
                    iconName: "content_copy"
                    iconColor: hoverHandler.hovered ? root.accentColor : Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.5)
                    buttonSize: 28
                    iconSize: 16
                    tooltipSide: "left"
                    onClicked: root.copyRequested()
                    z: 1
                }
            }

            MouseArea {
                anchors.fill: parent
                anchors.rightMargin: copyButton.width + (expandButton.visible ? expandButton.width + Theme.spacingXS : 0) + Theme.spacingS
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.isFullyExpanded) {
                        root.expandRequested()
                    } else {
                        root.expanded = !root.expanded
                    }
                }
            }
        }

        Rectangle {
            id: separator
            width: parent.width
            height: 1
            color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.2)
            visible: root.expanded
        }

        Flickable {
            id: contentFlickable
            width: parent.width
            height: root.expanded ? root.actualContentHeight : 0
            clip: true
            contentWidth: width
            contentHeight: root.contentImplicitHeight
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            visible: root.expanded

            ScrollBar.vertical: ScrollBar {
                policy: root.contentImplicitHeight > contentFlickable.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
            }

            Column {
                id: contentColumn
                width: contentFlickable.width
                spacing: Theme.spacingXS

                Row {
                    spacing: Theme.spacingS
                    visible: root.previewColor !== null

                    Rectangle {
                        width: Theme.fontSizeMedium + 4
                        height: Theme.fontSizeMedium + 4
                        radius: 4
                        color: root.previewColor
                        border.width: 1
                        border.color: Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.2)
                    }
                }

                TextEdit {
                    id: contentText
                    width: contentFlickable.width
                    text: root.needHighlight ? root.getHighlightedContent() : root.resultContent
                    textFormat: root.needHighlight ? TextEdit.RichText : TextEdit.PlainText
                    readOnly: true
                    selectByMouse: true
                    wrapMode: TextEdit.WrapAnywhere
                    font.family: "Monospace"
                    font.pixelSize: (root.resultType === "Color" || root.resultType === "Timestamp") ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    color: Theme.surfaceText
                    selectedTextColor: Theme.onPrimary
                    selectionColor: Theme.primary
                }
            }
        }
    }
}
