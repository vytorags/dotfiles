import Quickshell
import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "mediaPlayer"

    SliderSetting {
        settingKey: "backgroundOpacity"
        label: I18n.tr("Background Opacity")
        defaultValue: 80
        minimum: 0
        maximum: 100
        unit: "%"
    }

    SliderSetting {
        settingKey: "borderOpacity"
        label: I18n.tr("Border Opacity")
        defaultValue: 100
        minimum: 0
        maximum: 100
        unit: "%"
    }

    ToggleSetting {
        settingKey: "rotateThumbnail"
        label: I18n.tr("Rotate Thumbnail")
        description: I18n.tr("Rotate album artwork when media is playing")
        defaultValue: true
    }
}