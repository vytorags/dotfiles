import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Widgets

pragma ComponentBehavior: Bound

StyledRect {
  id: root
  color: Theme.surfaceContainerHigh
  radius: Theme.cornerRadius

  border.color: textArea.activeFocus ? Theme.primary : Theme.outlineMedium
  border.width: textArea.activeFocus ? 2 : 1

  property alias text: textArea.text
  property alias blockEdit: textArea.readOnly

  // To be set from outside
  function onEditFinished() { }
  function onTextEdited() { }

  DankFlickable {
    anchors.fill: parent
    clip: true

    TextArea.flickable: TextArea {
      id: textArea
      placeholderText: ""
      placeholderTextColor: Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.5)

      onEditingFinished: {
        root.onEditFinished();
      }

      onTextEdited: {
        root.onTextEdited();
      }

      topPadding: Theme.spacingS
      bottomPadding: Theme.spacingS
      rightPadding: Theme.spacingM
      leftPadding: Theme.spacingM

      focus: true
      activeFocusOnTab: true
      textFormat: TextEdit.PlainText
      inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase

      cursorDelegate: Rectangle {
        width: 1.5
        radius: 1
        color: Theme.surfaceText
        x: textArea.cursorRectangle.x
        y: textArea.cursorRectangle.y
        height: textArea.cursorRectangle.height
        opacity: 0.0

        SequentialAnimation on opacity {
          running: textArea.activeFocus
          loops: Animation.Infinite
          PropertyAnimation { from: 1.0; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
          PropertyAnimation { from: 1.0; to: 0.0; duration: 1; easing.type: Easing.InOutQuad }
          PropertyAnimation { from: 0.0; to: 0.0; duration: 500; easing.type: Easing.InOutQuad }
          PropertyAnimation { from: 0.0; to: 1.0; duration: 1; easing.type: Easing.InOutQuad }
        }

        visible: textArea.activeFocus
      }

      background: Rectangle {
        color: "transparent"
      }

      wrapMode: TextInput.WrapAnywhere
      font.pixelSize: Theme.fontSizeLarge
      color: Theme.surfaceText
      selectedTextColor: Theme.background
      selectionColor: Theme.primary
    }
  }
}
