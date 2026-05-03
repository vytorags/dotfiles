import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

PluginSettings {
  id: root
  pluginId: "polyglot"

  StringSetting {
    settingKey: "deeplApiKey"
    label: "DeepL (free) API key"
    description: "To create a key, first make a DeepL account and head over to https://www.deepl.com/your-account/keys."
    placeholder: ""
    defaultValue: ""
  }
}
