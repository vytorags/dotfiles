import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

DesktopPluginComponent {
    id: root

    // settings data here
    property real backgroundOpacity: (pluginData.backgroundOpacity ?? 80) / 100
    property real borderOpacity: (pluginData.borderOpacity ?? 100) / 100
    property bool rotateThumbnail: (pluginData.rotateThumbnail ?? true)

    LayoutMirroring.enabled: I18n.isRtl
    LayoutMirroring.childrenInherit: true

    opacity: showNoPlayerNow ? 0 : 1
    Behavior on opacity { NumberAnimation { duration: 300 } }

    property MprisPlayer activePlayer: MprisController.activePlayer
    property var allPlayers: MprisController.availablePlayers

    property bool isSwitching: false
    property string _lastArtUrl: ""
    property string _bgArtSource: ""

    property string activeTrackArtFile: ""

    function loadArtwork(url) {
        if (!url)
            return;
        if (url.startsWith("http://") || url.startsWith("https://")) {
            const filename = "/tmp/.dankshell/trackart_" + Date.now() + ".jpg";
            activeTrackArtFile = filename;

            cleanupProcess.command = ["sh", "-c", "mkdir -p /tmp/.dankshell && find /tmp/.dankshell -name 'trackart_*' ! -name '" + filename.split('/').pop() + "' -delete"];
            cleanupProcess.running = true;

            imageDownloader.command = ["curl", "-L", "-s", "--user-agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36", "-o", filename, url];
            imageDownloader.targetFile = filename;
            imageDownloader.running = true;
            return;
        }
        _bgArtSource = url;
    }

    function maybeFinishSwitch() {
        if (activePlayer && activePlayer.trackTitle !== "") {
            isSwitching = false;
            _switchHold = false;
            _stalePositionDetected = false;
        }
    }
    
    function getDisplayPosition() {
        if (!activePlayer) return 0;
        
        const rawPos = Math.max(0, activePlayer.position || 0);
        const length = Math.max(1, activePlayer.length || 1);
        
        // If we detected stale position, show 0 until proper data arrives
        if (_stalePositionDetected) {
            return 0;
        }
        
        // Handle stale position data when switching videos
        if (isSwitching && rawPos >= length * 0.9) {
            return 0;
        }
        
        const pos = activePlayer.length ? rawPos % Math.max(1, activePlayer.length) : rawPos;
        return pos;
    }
    
    function formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return minutes + ":" + (secs < 10 ? "0" : "") + secs;
    }
    
    Component.onCompleted: {
        // Initialize with current player state if available
        if (activePlayer) {
            // Get actual position after MPRIS fully loads
            Qt.callLater(() => {
                try {
                    const actualPos = activePlayer.position || 0;
                    const length = activePlayer.length || 1;
                    root._positionSnapshot = actualPos;
                    if (progressSeekbar && actualPos > 0) {
                        progressSeekbar.value = Math.min(1, actualPos / length);
                    }
                } catch (e) {
                    // Handle MPRIS errors
                }
            });
        }
    }

    // Derived "no players" state: always correct, no timers.
    readonly property int _playerCount: allPlayers ? allPlayers.length : 0
    readonly property bool _noneAvailable: _playerCount === 0
    readonly property bool _trulyIdle: activePlayer && activePlayer.playbackState === MprisPlaybackState.Stopped && !activePlayer.trackTitle && !activePlayer.trackArtist
    readonly property bool showNoPlayerNow: (!_switchHold) && (_noneAvailable || _trulyIdle)

    property bool _switchHold: false
    Timer {
        id: _switchHoldTimer
        interval: 650
        repeat: false
        onTriggered: {
            _switchHold = false;
            if (isSwitching) {
                isSwitching = false;
            }
        }
    }

    onActivePlayerChanged: {
        root._positionSnapshot = 0;
        root._forceUpdate = !root._forceUpdate;
        if (!activePlayer) {
            isSwitching = false;
            _switchHold = false;
            return;
        }
        isSwitching = true;
        _switchHold = true;
        _switchHoldTimer.restart();
        if (activePlayer.trackArtUrl)
            loadArtwork(activePlayer.trackArtUrl);
        
        // Get actual current position after a short delay to allow MPRIS to sync
        Qt.callLater(() => {
            try {
                const actualPos = activePlayer.position || 0;
                root._positionSnapshot = actualPos;
                if (progressSeekbar && actualPos > 0) {
                    progressSeekbar.value = Math.min(1, actualPos / Math.max(1, activePlayer.length || 1));
                    isSwitching = false;
                }
            } catch (e) {
                // Handle errors gracefully
            }
        });
    }



    // Responsive sizing with min/max constraints
    property real userScale: 1.0
    readonly property real minWidth: 320
    readonly property real maxWidth: 800
    readonly property real minHeight: 160
    readonly property real maxHeight: 400
    readonly property real baseWidth: 380
    readonly property real baseHeight: 200

    implicitWidth: Math.max(minWidth, Math.min(maxWidth, baseWidth * userScale))
    implicitHeight: Math.max(minHeight, Math.min(maxHeight, baseHeight * userScale))

    Connections {
        target: activePlayer
        function onTrackTitleChanged() {
            root._positionSnapshot = 0;
            root._forceUpdate = !root._forceUpdate;
            // Force immediate position reset for new track
            if (activePlayer.position > 0 && activePlayer.length > 0) {
                const progressRatio = activePlayer.position / activePlayer.length;
                if (progressRatio > 0.9) {
                    // Likely stale data - force reset
                    root._stalePositionDetected = true;
                }
            }
            _switchHoldTimer.restart();
            maybeFinishSwitch();
            // Reset progress bar immediately on track change
            if (progressSeekbar) {
                progressSeekbar.value = 0;
            }
        }
        function onTrackArtUrlChanged() {
            if (activePlayer?.trackArtUrl) {
                _lastArtUrl = activePlayer.trackArtUrl;
                loadArtwork(activePlayer.trackArtUrl);
            }
        }
        function onPositionChanged() {
            try {
                if (root._stalePositionDetected && activePlayer.position < activePlayer.length * 0.5) {
                    // Position updated properly now
                    root._stalePositionDetected = false;
                    root._forceUpdate = !root._forceUpdate;
                }
            } catch (e) {
                // MPRIS service disappeared - reset state
                root._stalePositionDetected = false;
            }
        }
    }

    Connections {
        target: MprisController
        function onAvailablePlayersChanged() {
            const count = (MprisController.availablePlayers?.length || 0);
            if (count === 0) {
                isSwitching = false;
                _switchHold = false;
            } else {
                _switchHold = true;
                _switchHoldTimer.restart();
            }
        }
    }

    Process {
        id: imageDownloader
        running: false
        property string targetFile: ""

        onExited: exitCode => {
            if (exitCode === 0 && targetFile)
                _bgArtSource = "file://" + targetFile;
        }
    }

    Process {
        id: cleanupProcess
        running: false
    }



    property bool isSeeking: false
    property real _positionSnapshot: 0
    property bool _forceUpdate: false
    property real _animationTick: 0
    property bool _stalePositionDetected: false

    Timer {
        id: positionUpdateTimer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            // Update snapshot to trigger binding re-evaluation
            if (activePlayer) {
                try {
                    const newPosition = activePlayer.position || 0;
                    root._positionSnapshot = newPosition;
                    // Force progress bar refresh when switching
                    if (isSwitching || _stalePositionDetected) {
                        if (progressSeekbar) {
                            progressSeekbar.value = progressSeekbar.calculateProgress();
                        }
                    }
                } catch (e) {
                    // Handle MPRIS service errors gracefully
                    root._positionSnapshot = 0;
                }
            }
        }
    }

    // Use animation to drive constant updates for smooth progress bar
    NumberAnimation {
        id: progressUpdateAnimation
        target: root
        property: "_animationTick"
        from: 0
        to: 10000
        duration: 10000
        loops: Animation.Infinite
        running: activePlayer?.playbackState === MprisPlaybackState.Playing && !isSeeking
    }

    Item {
        id: bgContainer
        anchors.fill: parent
        visible: _bgArtSource !== ""

        Image {
            id: bgImage
            anchors.centerIn: parent
            width: Math.max(parent.width, parent.height) * 1.1
            height: width
            // source: _bgArtSource
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            visible: false
            onStatusChanged: {
                if (status === Image.Ready)
                    maybeFinishSwitch();
            }
        }

        Item {
            id: blurredBg
            anchors.fill: parent
            visible: false

            MultiEffect {
                anchors.centerIn: parent
                width: bgImage.width
                height: bgImage.height
                source: bgImage
                blurEnabled: true
                blurMax: 64
                blur: 2
                saturation: -0.2
                brightness: -0.25
            }
        }

        Rectangle {
            id: bgMask
            anchors.fill: parent
            radius: Theme.cornerRadius
            visible: false
            layer.enabled: true
        }

        MultiEffect {
            anchors.fill: parent
            source: blurredBg
            maskEnabled: true
            maskSource: bgMask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
            opacity: 0.7
        }

        Rectangle {
            anchors.fill: parent
            radius: Theme.cornerRadius
            color: Theme.withAlpha(Theme.surface, root.backgroundOpacity)
        }
    }

    // --- Ocean Wave Background ---
    Canvas {
        id: waveCanvas
        anchors.fill: parent
        z: 1 // Ensures it stays behind the main content
        opacity: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? 0.4 : 0.1
        
        property real phase: 0
        
        // This timer drives the animation "movement"
        Timer {
            interval: 16 // ~60 FPS
            running: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing
            repeat: true
            onTriggered: {
                waveCanvas.phase += 0.05;
                waveCanvas.requestPaint();
            }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            
            // Draw two overlapping waves for a "deep" ocean feel
            drawWave(ctx, "#40" + Theme.primary.toString().substring(1), 0.5, 15, phase);
            drawWave(ctx, "#60" + Theme.primary.toString().substring(1), 0.8, 10, phase * 0.7);
            drawWave(ctx, "#70" + Theme.primary.toString().substring(1), 0.8, 10, phase * 0.9);
        }

        function drawWave(ctx, color, speed, amplitude, currentPhase) {
            ctx.beginPath();
            ctx.fillStyle = color;
            
            var waveHeight = height * 0.7; // Position waves at the bottom 30%
            ctx.moveTo(0, height);
            
            for (var x = 0; x <= width; x += 5) {
                // Sine wave calculation: y = amplitude * sin(frequency * x + phase)
                var y = waveHeight + Math.sin(x * 0.02 + currentPhase) * amplitude;
                ctx.lineTo(x, y);
            }
            
            ctx.lineTo(width, height);
            ctx.closePath();
            ctx.fill();
        }
    }
    // --- End Ocean Wave Background ---

    Column {
        anchors.centerIn: parent
        spacing: Theme.spacingM
        visible: showNoPlayerNow

        DankIcon {
            name: "music_note"
            size: Theme.iconSize * 3
            color: Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.5)
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Main content container - Layout with thumbnail
    Item {
        anchors.fill: parent
        anchors.margins: Theme.spacingM * userScale
        visible: !_noneAvailable && (!showNoPlayerNow)

        Row {
            anchors.fill: parent
            spacing: Theme.spacingM * userScale

            // Album Thumbnail Section (Left)
            Rectangle {
                id: thumbnailContainer
                width: parent.height * 0.85
                height: parent.height * 0.85
                anchors.verticalCenter: parent.verticalCenter
                radius: 6 * userScale
                color: "transparent"
                clip: true

                property real albumRotation: 0

                NumberAnimation {
                    id: rotationAnimation
                    target: thumbnailContainer
                    property: "albumRotation"
                    from: 0
                    to: 360
                    duration: 20000
                    running: activePlayer?.playbackState === MprisPlaybackState.Playing && rotateThumbnail
                    loops: Animation.Infinite
                }

                DankAlbumArt {
                    id: albumArt
                    width: parent.width * 0.76
                    height: parent.height * 0.76
                    anchors.centerIn: parent
                    activePlayer: root.activePlayer
                    rotation: thumbnailContainer.albumRotation
                }

                // Subtle border
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, root.borderOpacity)
                    border.width: 1
                }
            }

            // Content Section (Right)
            Column {
                width: parent.width - thumbnailContainer.width - parent.spacing
                height: parent.height
                spacing: Theme.spacingS * userScale

                // Song Info Section (Top)
                Column {
                    id: songInfo
                    width: parent.width
                    spacing: 2 * userScale

                    StyledText {
                        text: activePlayer?.trackTitle || "The (Overdue) Collapse of Wind..."
                        font.pixelSize: Theme.fontSizeMedium * 1.1 * userScale
                        font.weight: Font.Bold
                        color: Theme.surfaceText
                        width: parent.width
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    StyledText {
                        text: activePlayer?.trackArtist || "Catalyst"
                        font.pixelSize: Theme.fontSizeSmall * userScale
                        color: Qt.rgba(Theme.surfaceText.r, Theme.surfaceText.g, Theme.surfaceText.b, 0.6)
                        width: parent.width
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }
                }

                // Spacer
                Item {
                    width: parent.width
                    height: Theme.spacingXS * userScale
                }

                // Controls Row (Middle)
                Row {
                    id: controlsRow
                    width: parent.width
                    spacing: Theme.spacingS * userScale

                    // Previous Button
                    Rectangle {
                        width: 32 * userScale
                        height: 32 * userScale
                        radius: 4 * userScale
                        color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter

                        DankIcon {
                            anchors.centerIn: parent
                            name: "skip_previous"
                            size: 28 * userScale
                            color: Theme.primary
                        }

                        MouseArea {
                            id: prevBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!activePlayer)
                                    return;
                                if (activePlayer.position > 8 && activePlayer.canSeek) {
                                    activePlayer.position = 0;
                                } else {
                                    activePlayer.previous();
                                }
                            }
                        }
                    }

                    // Play/Pause Button
                    Rectangle {
                        width: 32 * userScale
                        height: 32 * userScale
                        radius: 4 * userScale
                        color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter

                        DankIcon {
                            anchors.centerIn: parent
                            name: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing ? "pause" : "play_arrow"
                            size: 28 * userScale
                            color: Theme.primary
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: activePlayer && activePlayer.togglePlaying()
                        }
                    }

                    // Next Button
                    Rectangle {
                        width: 32 * userScale
                        height: 32 * userScale
                        radius: 4 * userScale
                        color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter

                        DankIcon {
                            anchors.centerIn: parent
                            name: "skip_next"
                            size: 28 * userScale
                            color: Theme.primary
                        }

                        MouseArea {
                            id: nextBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: activePlayer && activePlayer.next()
                        }
                    }

                    // Spacer to push buttons to right
                    Item {
                        width: parent.width - (32 * 3 * userScale) - (Theme.spacingS * 3 * userScale)
                        height: 1
                    }
                }

                // Seekbar Section (Bottom)
                Column {
                    id: seekbarSection
                    width: parent.width
                    spacing: 2 * userScale

                    // Integrated DankSeekbar
                    DankSeekbar {
                        id: progressSeekbar
                        width: parent.width
                        height: 16 * userScale // Consistent with previous design
                        activePlayer: root.activePlayer
                        
                        // Keep the Tab's seeking state in sync with the component
                        onIsSeekingChanged: root.isSeeking = isSeeking
                        
                        function calculateProgress() {
                            if (!root.activePlayer || root.activePlayer.length <= 0) return 0;
                            
                            const rawPos = Math.max(0, root.activePlayer.position || 0);
                            const length = Math.max(1, root.activePlayer.length || 1);
                            
                            // If we detected stale position, show 0 until proper data arrives
                            if (root._stalePositionDetected) {
                                // Check if position is now valid
                                if (rawPos < length * 0.8) {
                                    root._stalePositionDetected = false;
                                    root.isSwitching = false;
                                } else {
                                    return 0;
                                }
                            }
                            
                            // Reset if position seems stale (at end for new video)
                            if (root.isSwitching && rawPos >= length * 0.9) {
                                root._stalePositionDetected = true;
                                return 0;
                            }
                            
                            // Force position refresh when switching videos
                            if (root.isSwitching && rawPos > 0 && rawPos < length * 0.8) {
                                root.isSwitching = false;
                            }
                            
                            return Math.min(1, rawPos / length);
                        }

        // Connect position updates to seekbar value directly
                        Timer {
                            interval: 50
                            running: true
                            repeat: true
                            onTriggered: {
                                if (progressSeekbar && activePlayer) {
                                    try {
                                        progressSeekbar.value = progressSeekbar.calculateProgress();
                                    } catch (e) {
                                        // Handle MPRIS errors
                                    }
                                }
                            }
                        }
                    }

                    // Time labels
                    Item {
                        width: parent.width
                        height: 12 * userScale

                        StyledText {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: {
                                // Force dependency on position updates
                                root._positionSnapshot;
                                return formatTime(getDisplayPosition());
                            }
                            font.pixelSize: Theme.fontSizeSmall * 0.9 * userScale
                            color: Theme.surfaceVariantText
                        }

                        StyledText {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: {
                                if (!activePlayer || !activePlayer.length)
                                    return "0:00";
                                const dur = Math.max(0, activePlayer.length || 0);
                                const minutes = Math.floor(dur / 60);
                                const seconds = Math.floor(dur % 60);
                                return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                            }
                            font.pixelSize: Theme.fontSizeSmall * 0.9 * userScale
                            color: Theme.surfaceVariantText
                        }
                    }
                }
            }
        }
    }


}
