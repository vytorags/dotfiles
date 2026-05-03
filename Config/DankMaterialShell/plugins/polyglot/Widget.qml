import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins
import "deepl-api.js" as DeeplAPI

pragma ComponentBehavior: Bound

PluginComponent {
  id: root

  layerNamespacePlugin: "polyglot"
  horizontalBarPill: Component {
    Row {
      spacing: Theme.spacingS

      DankIcon {
        name: "translate"
        size: root.iconSize
        color: Theme.primary
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }

  verticalBarPill: Component {
    Column {
      spacing: Theme.spacingXS

      DankIcon {
        name: "translate"
        size: root.iconSize
        color: Theme.primary
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
  }

  popoutWidth: 500
  popoutHeight: 500

  popoutContent: Component {
    PopoutComponent {
      id: popoutColumn

      headerText: "Polyglot"
      // detailsText: "Quickly translate some text"
      showCloseButton: true

      Item {
        id: theItem
        width: parent.width
        implicitHeight: root.popoutHeight - popoutColumn.headerHeight - popoutColumn.detailsHeight - Theme.spacingXL

        // Allows to avoid sending a translation query if the input text has not changed
        property var previousSourceText: ""

        property var autodetectedLanguage: ""

        Component.onCompleted: {
          previousSourceText = sourceText.text;
        }

        function savePluginData() {
          if (pluginService && pluginId) {
            pluginService.savePluginData(pluginId, "sourceLanguage", sourceLanguage.currentValue);
            pluginService.savePluginData(pluginId, "targetLanguage", targetLanguage.currentValue);
            pluginService.savePluginData(pluginId, "sourceText", sourceText.text);
            pluginService.savePluginData(pluginId, "targetText", targetText.text);
          }
        }

        Process {
          id: translationAPICall

          function translate() {
            translationAPICall.exec(DeeplAPI.translateCommand(
              sourceText.text,
              sourceLanguage.currentValue,
              targetLanguage.currentValue,
              pluginData.deeplApiKey
            ));
          }

          stdout: StdioCollector {
            onStreamFinished: {
              const response = JSON.parse(this.text);
              if (
                response.translations !== undefined &&
                response.translations.length > 0 &&
                response.translations[0].text !== undefined
              ) {
                targetText.text = response.translations[0].text;
                theItem.previousSourceText = sourceText.text;
                theItem.savePluginData();

                const detectedLang = response.translations[0].detected_source_language;
                if (detectedLang !== undefined && sourceLanguage.currentValue.startsWith("Auto")) {
                  sourceLanguage.currentValue = `Auto (${DeeplAPI.acronym2language.sources[detectedLang]})`;
                  theItem.autodetectedLanguage = detectedLang;
                }
              } else if (
                response.message !== undefined &&
                response.message.startsWith("Authentication failed, provided API key is invalid.") ||
                response.message.startsWith("Forbidden")
              ) {
                ToastService.showError("Translation failed", `Invalid DeepL API key '${pluginData.deeplApiKey}'`);
                // TODO: check other types of error messages
              } else {
                ToastService.showError("Translation failed", `Unknown error: '${response}'`);
              }
            }
          }
        }

        Timer {
          id: translateTimeout
          interval: 500
          running: false
          repeat: false
          onTriggered: {
            translationAPICall.running = false;
            translationAPICall.translate();
          }
        }

        Column {
          anchors.fill: parent
          spacing: Theme.spacingM

          Row {
            id: languageChoice
            width: parent.width
            spacing: Theme.spacingM

            DankDropdown {
              id: sourceLanguage
              width: (parent.width - 2 * parent.spacing - swapLanguages.width) / 2
              currentValue: pluginData.sourceLanguage || "English"
              onValueChanged: {
                theItem.savePluginData();
                translateTimeout.restart();
              }
              options: DeeplAPI.sourceLanguages
              enableFuzzySearch: true
            }

            DankActionButton {
              id: swapLanguages

              onClicked: {
                let sourceLang = sourceLanguage.currentValue;
                let newTargetCode = "";
                if (sourceLang.startsWith("Auto") && sourceLang !== "Auto") {
                  newTargetCode = theItem.autodetectedLanguage;
                } else {
                  newTargetCode = DeeplAPI.language2acronym.sources[sourceLang];
                }
                if (DeeplAPI.source2target[newTargetCode] !== undefined) {
                  newTargetCode = DeeplAPI.source2target[newTargetCode];
                }

                let newSourceCode = DeeplAPI.language2acronym.targets[targetLanguage.currentValue];
                if (DeeplAPI.target2source[newSourceCode] !== undefined) {
                  newSourceCode = DeeplAPI.target2source[newSourceCode];
                }

                const newTargetLang = DeeplAPI.acronym2language.targets[newTargetCode];
                const newSourceLang = DeeplAPI.acronym2language.sources[newSourceCode];
                const newTargetText = sourceText.text;
                const newSourceText = targetText.text;
                sourceLanguage.currentValue = newSourceLang;
                targetLanguage.currentValue = newTargetLang;

                theItem.previousSourceText = newSourceText;
                sourceText.text = newSourceText;
                targetText.text = newTargetText;

                theItem.savePluginData();
                translateTimeout.restart();
              }

              iconName: "swap_horiz"
              iconSize: root.iconSize
              anchors.top: parent.top
              anchors.bottom: parent.bottom
              // Empirical choice for the margins :(
              anchors.topMargin: Theme.spacingS / 2
              anchors.bottomMargin: Theme.spacingS / 2
            }

            DankDropdown {
              id: targetLanguage
              width: (parent.width - 2 * parent.spacing - swapLanguages.width) / 2
              currentValue: pluginData.targetLanguage || "French"
              onValueChanged: {
                theItem.savePluginData();
                translateTimeout.restart();
              }
              options: DeeplAPI.targetLanguages
              enableFuzzySearch: true
            }
          }

          TextBlock {
            id: sourceText
            text: pluginData.sourceText || ""
            function onTextEdited() {
              if (pluginService && pluginId) {
                pluginService.savePluginData(pluginId, "sourceText", this.text);
              }
              if (this.text !== "" && this.text !== theItem.previousSourceText) {
                translateTimeout.restart();
              }
            }
            width: parent.width
            height: (parent.height - 2 * parent.spacing - languageChoice.height) / 2
          }
          TextBlock {
            id: targetText
            text: pluginData.targetText || ""
            blockEdit: true
            width: parent.width
            height: (parent.height - 2 * parent.spacing - languageChoice.height) / 2
          }
        }
      }
    }
  }
}
