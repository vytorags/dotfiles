import QtQuick
import QtQuick.Layouts
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "developerUtilities"

    StyledText {
        width: parent.width
        text: I18n.tr("Developer Utilities", "DeveloperUtilities")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: I18n.tr("Encoders, decoders, formatters and converters for developers.", "DeveloperUtilities")
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledRect {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    ToggleSetting {
        settingKey: "autoPaste"
        label: I18n.tr("Auto Paste", "DeveloperUtilities")
        description: I18n.tr("Automatically paste clipboard content when opening", "DeveloperUtilities")
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "autoCloseOnCopy"
        label: I18n.tr("Auto Close on Copy", "DeveloperUtilities")
        description: I18n.tr("Automatically close popup after copying result", "DeveloperUtilities")
        defaultValue: false
    }

    StyledRect {
        width: parent.width
        height: featuresColumn.implicitHeight + Theme.spacingL * 2
        radius: Theme.cornerRadius
        color: Theme.surfaceContainerHigh

        Column {
            id: featuresColumn
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingM

            StyledText {
                text: I18n.tr("Enabled Features", "DeveloperUtilities")
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            ToggleSetting {
                settingKey: "enableColor"
                label: I18n.tr("Color Conversion", "DeveloperUtilities")
                description: I18n.tr("HEX, RGB, HSL color format conversion", "DeveloperUtilities")
                defaultValue: true
            }

            ToggleSetting {
                settingKey: "enableJson"
                label: I18n.tr("JSON Format", "DeveloperUtilities")
                description: I18n.tr("Auto-detect and beautify JSON", "DeveloperUtilities")
                defaultValue: true
            }

            ToggleSetting {
                settingKey: "enableJwt"
                label: I18n.tr("JWT Decode", "DeveloperUtilities")
                description: I18n.tr("Parse JWT Header and Payload", "DeveloperUtilities")
                defaultValue: true
            }

            ToggleSetting {
                settingKey: "enableTimestamp"
                label: I18n.tr("Timestamp", "DeveloperUtilities")
                description: I18n.tr("Unix timestamp to date and vice versa", "DeveloperUtilities")
                defaultValue: true
            }

            ToggleSetting {
                settingKey: "enableUrl"
                label: I18n.tr("URL Encode/Decode", "DeveloperUtilities")
                description: I18n.tr("Handle URL encoded strings", "DeveloperUtilities")
                defaultValue: true
            }

            ToggleSetting {
                settingKey: "enableBase64"
                label: I18n.tr("Base64 Encode/Decode", "DeveloperUtilities")
                description: I18n.tr("Auto-detect and convert Base64", "DeveloperUtilities")
                defaultValue: true
            }

            ToggleSetting {
                settingKey: "enableNumber"
                label: I18n.tr("Number Base Conversion", "DeveloperUtilities")
                description: I18n.tr("Binary, Octal, Decimal, Hexadecimal", "DeveloperUtilities")
                defaultValue: true
            }
        }
    }

    StyledRect {
        width: parent.width
        height: shortcutsColumn.implicitHeight + Theme.spacingL * 2
        radius: Theme.cornerRadius
        color: Theme.surfaceContainerHigh

        Column {
            id: shortcutsColumn
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingM

            StyledText {
                text: I18n.tr("Keyboard Shortcuts", "DeveloperUtilities")
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            StyledText {
                text: I18n.tr("• Ctrl+1~9 - Copy result by index\n• Ctrl+C - Copy first result when no text selected\n• Shortcut hints shown on result card headers", "DeveloperUtilities")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
    }
}
