import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins
import "./components" as Components
import "utils/converter.js" as Converter

PluginComponent {
    id: root

    property var config: Converter.getConfig()
    property var conversionResults: []
    property bool isProcessing: false
    property string statusMessage: ""
    property string inputText: ""
    property bool autoPaste: pluginData?.autoPaste ?? true
    property bool autoCloseOnCopy: pluginData?.autoCloseOnCopy ?? false
    property int flashIndex: -1
    property int expandedCardIndex: -1

    property var enabledFeatures: ({
        enableColor: pluginData?.enableColor ?? true,
        enableJson: pluginData?.enableJson ?? true,
        enableJwt: pluginData?.enableJwt ?? true,
        enableTimestamp: pluginData?.enableTimestamp ?? true,
        enableUrl: pluginData?.enableUrl ?? true,
        enableBase64: pluginData?.enableBase64 ?? true,
        enableNumber: pluginData?.enableNumber ?? true
    })

    signal copyCompletedForClose()

    popoutHeight: parentScreen ? Math.floor(parentScreen.height * 0.8) : 600

    function copyResult(index) {
        if (index >= 0 && index < root.conversionResults.length) {
            clipboardHelper.text = root.conversionResults[index].content
            clipboardHelper.selectAll()
            clipboardHelper.copy()
            ToastService.showInfo(I18n.tr("Copied", "DeveloperUtilities") + ": " + root.conversionResults[index].label)
            root.flashIndex = index
            if (root.autoCloseOnCopy) {
                root.copyCompletedForClose()
            }
        }
    }

    function toggleExpand(index) {
        if (root.expandedCardIndex === index) {
            root.expandedCardIndex = -1
        } else {
            root.expandedCardIndex = index
        }
    }

    horizontalBarPill: Component {
        DankIcon {
            name: "code"
            size: Theme.barIconSize(root.barThickness, -4)
            color: Theme.widgetIconColor
        }
    }

    verticalBarPill: Component {
        DankIcon {
            name: "code"
            size: Theme.barIconSize(root.barThickness)
            color: Theme.widgetIconColor
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popout

            property bool isPinned: false

            readonly property int maxHeight: (root.parentScreen ? Math.floor(root.parentScreen.height * 0.8) : 600) - Theme.spacingS * 2

            headerText: I18n.tr("Developer Utilities", "DeveloperUtilities")
            showCloseButton: true

            headerActions: Row {
                spacing: Theme.spacingXS

                StyledText {
                    text: inputArea.text.length + " " + I18n.tr("chars", "DeveloperUtilities")
                    font.pixelSize: Theme.fontSizeSmall
                    color: inputArea.text.length > 100000 ? Theme.error : Theme.surfaceVariantText
                    visible: inputArea.text.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                }

                DankActionButton {
                    iconName: "content_paste"
                    iconColor: Theme.surfaceVariantText
                    iconSize: Theme.iconSize - 4
                    onClicked: {
                        inputArea.text = ""
                        root.inputText = ""
                        root.conversionResults = []
                        inputArea.paste()
                    }
                }

                DankActionButton {
                    iconName: "delete"
                    iconColor: Theme.surfaceVariantText
                    iconSize: Theme.iconSize - 4
                    enabled: inputArea.text.length > 0
                    onClicked: {
                        inputArea.text = ""
                        root.inputText = ""
                        root.conversionResults = []
                    }
                }

                DankActionButton {
                    iconName: "push_pin"
                    iconColor: popout.isPinned ? Theme.primary : Theme.surfaceVariantText
                    iconSize: Theme.iconSize - 4
                    onClicked: popout.isPinned = !popout.isPinned
                }
            }

            onVisibleChanged: {
                if (visible) {
                    inputArea.forceActiveFocus()
                    if (root.autoPaste && inputArea.text.length === 0) {
                        autoPasteTimer.start()
                    }
                } else {
                    root.expandedCardIndex = -1
                }
            }

            Timer {
                id: autoPasteTimer
                interval: 100
                onTriggered: {
                    if (inputArea.text.length === 0) {
                        inputArea.paste()
                    }
                }
            }

            onIsPinnedChanged: {
                if (parentPopout && 'backgroundInteractive' in parentPopout) {
                    parentPopout.backgroundInteractive = !isPinned
                }
            }

            Connections {
                target: root
                function onCopyCompletedForClose() {
                    closeDelayTimer.start()
                }
            }

            Timer {
                id: closeDelayTimer
                interval: 150
                onTriggered: {
                    if (closePopout) {
                        closePopout()
                    }
                }
            }

            Column {
                id: mainColumn
                width: parent.width
                leftPadding: Theme.spacingS
                rightPadding: Theme.spacingS
                topPadding: Theme.spacingM
                bottomPadding: Theme.spacingL
                spacing: Theme.spacingM

                Rectangle {
                    width: parent.width - Theme.spacingS * 2
                    height: 120
                    color: Theme.surfaceContainerHighest
                    radius: Theme.cornerRadius
                    border.width: inputArea.activeFocus ? 2 : 1
                    border.color: inputArea.text.length > 100000 ? Theme.error : (inputArea.activeFocus ? Theme.primary : Theme.surfaceVariant)

                    DankFlickable {
                        id: inputFlickable
                        anchors.fill: parent
                        anchors.margins: 1
                        clip: true
                        contentWidth: width - 11

                        TextArea.flickable: TextArea {
                            id: inputArea
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            font.family: "Monospace"
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.surfaceText
                            selectedTextColor: Theme.background
                            selectionColor: Theme.primary
                            leftPadding: Theme.spacingM
                            rightPadding: Theme.spacingM
                            topPadding: Theme.spacingS
                            bottomPadding: Theme.spacingS
                            cursorDelegate: Rectangle {
                                width: 1.5
                                radius: 1
                                color: Theme.surfaceText
                                opacity: 1.0
                                SequentialAnimation on opacity {
                                    running: inputArea.activeFocus
                                    loops: Animation.Infinite
                                    PropertyAnimation { from: 1.0; to: 0.0; duration: 650; easing.type: Easing.InOutQuad }
                                    PropertyAnimation { from: 0.0; to: 1.0; duration: 650; easing.type: Easing.InOutQuad }
                                }
                            }
                            background: Rectangle { color: "transparent" }
                            Keys.onPressed: event => {
                                if (event.key >= Qt.Key_1 && event.key <= Qt.Key_9 && (event.modifiers & Qt.ControlModifier)) {
                                    let index = event.key - Qt.Key_1
                                    if (index < root.conversionResults.length) {
                                        root.copyResult(index)
                                        event.accepted = true
                                    }
                                } else if (event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier)) {
                                    if (inputArea.selectedText.length === 0 && root.conversionResults.length > 0) {
                                        root.copyResult(0)
                                        event.accepted = true
                                    }
                                }
                            }
                            onTextChanged: {
                                root.inputText = text
                                if (text.trim() === "") {
                                    root.conversionResults = []
                                    root.isProcessing = false
                                    root.statusMessage = ""
                                } else {
                                    root.isProcessing = true
                                    debounceTimer.restart()
                                }
                            }
                        }

                        StyledText {
                            text: I18n.tr("Paste text to convert...", "DeveloperUtilities")
                            color: Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.5)
                            font.family: inputArea.font.family
                            font.pixelSize: inputArea.font.pixelSize
                            visible: inputArea.text.length === 0
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: inputArea.leftPadding
                            anchors.topMargin: inputArea.topPadding
                            z: inputArea.z + 1
                        }
                    }
                }

                DankFlickable {
                    id: resultsFlickable
                    width: parent.width - Theme.spacingS * 2
                    height: Math.min(resultsColumn.implicitHeight, root.popoutHeight - 200)
                    clip: true
                    contentWidth: width
                    contentHeight: resultsColumn.implicitHeight

                    Column {
                        id: resultsColumn
                        width: resultsFlickable.width
                        spacing: Theme.spacingM

                        Repeater {
                            model: root.conversionResults

                            Loader {
                                id: cardLoader
                                required property var modelData
                                required property int index
                                width: resultsColumn.width
                                visible: root.expandedCardIndex === -1 || root.expandedCardIndex === index
                                sourceComponent: Components.ResultCard {
                                    id: resultCard
                                    resultType: cardLoader.modelData.type
                                    resultLabel: cardLoader.modelData.label
                                    resultContent: cardLoader.modelData.content
                                    needHighlight: cardLoader.modelData.needHighlight || false
                                    shortcutIndex: cardLoader.index
                                    maxExpandHeight: root.popoutHeight - 200

                                    Binding {
                                        target: resultCard
                                        property: "isFullyExpanded"
                                        value: root.expandedCardIndex === cardLoader.index
                                    }

                                    onCopyRequested: {
                                        clipboardHelper.text = resultContent
                                        clipboardHelper.selectAll()
                                        clipboardHelper.copy()
                                        ToastService.showInfo(I18n.tr("Copied", "DeveloperUtilities"))
                                        copyCompleted()
                                        if (root.autoCloseOnCopy) {
                                            root.copyCompletedForClose()
                                        }
                                    }
                                    onExpandRequested: {
                                        root.toggleExpand(cardLoader.index)
                                    }
                                    Connections {
                                        target: root
                                        function onFlashIndexChanged() {
                                            if (root.flashIndex === cardLoader.index) {
                                                copyCompleted()
                                                root.flashIndex = -1
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            width: resultsColumn.width
                            height: hintColumn.implicitHeight + Theme.spacingL
                            visible: root.conversionResults.length === 0 && !root.isProcessing

                            Column {
                                id: hintColumn
                                anchors.centerIn: parent
                                spacing: Theme.spacingM

                                DankIcon {
                                    name: "transform"
                                    size: 40
                                    color: Theme.surfaceVariant
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                StyledText {
                                    text: I18n.tr("Supported conversions", "DeveloperUtilities")
                                    font.pixelSize: Theme.fontSizeMedium
                                    font.weight: Font.Medium
                                    color: Theme.surfaceText
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Row {
                                    spacing: Theme.spacingM
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    DankIcon { visible: root.enabledFeatures.enableColor; name: "palette"; size: Theme.fontSizeMedium; color: Theme.surfaceVariantText }
                                    DankIcon { visible: root.enabledFeatures.enableJson; name: "data_object"; size: Theme.fontSizeMedium; color: Theme.surfaceVariantText }
                                    DankIcon { visible: root.enabledFeatures.enableJwt; name: "key"; size: Theme.fontSizeMedium; color: Theme.surfaceVariantText }
                                    DankIcon { visible: root.enabledFeatures.enableTimestamp; name: "schedule"; size: Theme.fontSizeMedium; color: Theme.surfaceVariantText }
                                    DankIcon { visible: root.enabledFeatures.enableUrl; name: "link"; size: Theme.fontSizeMedium; color: Theme.surfaceVariantText }
                                    DankIcon { visible: root.enabledFeatures.enableBase64; name: "code"; size: Theme.fontSizeMedium; color: Theme.surfaceVariantText }
                                    DankIcon { visible: root.enabledFeatures.enableNumber; name: "tag"; size: Theme.fontSizeMedium; color: Theme.surfaceVariantText }
                                }
                            }
                        }

                        Item {
                            width: resultsColumn.width
                            height: 80
                            visible: root.isProcessing

                            Row {
                                anchors.centerIn: parent
                                spacing: Theme.spacingS

                                Repeater {
                                    model: 3

                                    Rectangle {
                                        id: dot
                                        width: 10
                                        height: 10
                                        radius: 5
                                        color: Theme.primary
                                        scale: 0.6
                                        opacity: 0.4

                                        property int delay: index * 150

                                        SequentialAnimation on scale {
                                            running: root.isProcessing
                                            loops: Animation.Infinite
                                            PauseAnimation { duration: dot.delay }
                                            NumberAnimation {
                                                from: 0.6
                                                to: 1.0
                                                duration: 200
                                                easing.type: Easing.OutQuad
                                            }
                                            NumberAnimation {
                                                from: 1.0
                                                to: 0.6
                                                duration: 200
                                                easing.type: Easing.InQuad
                                            }
                                            PauseAnimation { duration: 450 - dot.delay }
                                        }
                                        SequentialAnimation on opacity {
                                            running: root.isProcessing
                                            loops: Animation.Infinite
                                            PauseAnimation { duration: dot.delay }
                                            NumberAnimation {
                                                from: 0.4
                                                to: 1.0
                                                duration: 200
                                                easing.type: Easing.OutQuad
                                            }
                                            NumberAnimation {
                                                from: 1.0
                                                to: 0.4
                                                duration: 200
                                                easing.type: Easing.InQuad
                                            }
                                            PauseAnimation { duration: 450 - dot.delay }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: debounceTimer
        interval: root.config.DEBOUNCE_INTERVAL
        onTriggered: {
            var result = Converter.process(root.inputText, root.enabledFeatures)
            root.conversionResults = result.results
            root.isProcessing = false
            root.statusMessage = result.results.length > 0 ? result.results.length + " conversions" : ""
        }
    }

    TextEdit {
        id: clipboardHelper
        visible: false
    }

    popoutWidth: 480
}
