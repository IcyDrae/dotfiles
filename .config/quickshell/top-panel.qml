import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

PanelWindow {
    id: root

    aboveWindows: false

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 10
        left: 4
        right: 4
        bottom: 10
    }

    implicitHeight: 44

    // The PanelWindow itself must be transparent
    color: "transparent"

    // ─────────────────────────────────────────
    // VIRTUAL DESKTOP DATA
    // ─────────────────────────────────────────

    property int desktopCount: 0
    property string currentDesktopId: ""

    property var desktopIds: []

    // ─────────────────────────────────────────
    // MEDIA DATA
    // ─────────────────────────────────────────

    property string mediaText: "♫  Nothing playing"

    // ─────────────────────────────────────────
    // CLOCK DATA
    // ─────────────────────────────────────────

    property string dateTimeText: ""

    // ─────────────────────────────────────────
    // GET DESKTOP COUNT
    // ─────────────────────────────────────────

    Process {
        id: desktopCountProcess

        command: [
            "qdbus-qt6",
            "org.kde.KWin",
            "/VirtualDesktopManager",
            "org.kde.KWin.VirtualDesktopManager.count"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var value = parseInt(this.text.trim())

                if (!isNaN(value)) {
                    root.desktopCount = value
                }
            }
        }
    }

    // ─────────────────────────────────────────
    // GET CURRENT DESKTOP
    // ─────────────────────────────────────────

    Process {
        id: currentDesktopProcess

        command: [
            "qdbus-qt6",
            "org.kde.KWin",
            "/VirtualDesktopManager",
            "org.kde.KWin.VirtualDesktopManager.current"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var value = this.text.trim()

                if (value !== "") {
                    root.currentDesktopId = value
                }
            }
        }
    }

    // ─────────────────────────────────────────
    // GET DESKTOP IDS
    // ─────────────────────────────────────────

    Process {
        id: desktopListProcess

        command: [
            "sh",
            "-c",
            "qdbus-qt6 --literal org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.desktops"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var output = this.text

                var matches = output.match(
                    /\(uss\)\s+\d+,\s*"([^"]+)"/g
                )

                var ids = []

                if (matches) {
                    for (var i = 0; i < matches.length; i++) {
                        var match = matches[i].match(
                            /\(uss\)\s+\d+,\s*"([^"]+)"/
                        )

                        if (match) {
                            ids.push(match[1])
                        }
                    }
                }

                if (ids.length > 0) {
                    root.desktopIds = ids
                }
            }
        }
    }

    // ─────────────────────────────────────────
    // SWITCH DESKTOP
    // ─────────────────────────────────────────

    Process {
        id: switchDesktopProcess

        property string targetDesktop: ""

        command: [
            "qdbus-qt6",
            "org.kde.KWin",
            "/VirtualDesktopManager",
            "org.freedesktop.DBus.Properties.Set",
            "org.kde.KWin.VirtualDesktopManager",
            "current",
            targetDesktop
        ]

        running: false
    }

    // ─────────────────────────────────────────
    // REFRESH KDE DESKTOP DATA
    // ─────────────────────────────────────────

    Timer {
        interval: 500
        running: true
        repeat: true

        onTriggered: {
            if (!desktopCountProcess.running)
                desktopCountProcess.running = true

            if (!currentDesktopProcess.running)
                currentDesktopProcess.running = true

            if (!desktopListProcess.running)
                desktopListProcess.running = true
        }
    }

    // ─────────────────────────────────────────
    // MPRIS
    // ─────────────────────────────────────────

    function updateMedia() {
        var players = Mpris.players.values

        var playingPlayer = null

        for (var i = 0; i < players.length; i++) {
            var player = players[i]

            if (player && player.isPlaying) {
                playingPlayer = player
                break
            }
        }

        if (!playingPlayer) {
            root.mediaText = "♫  Nothing playing"
            return
        }

        var artist = playingPlayer.trackArtist
        var title = playingPlayer.trackTitle

        if (!artist || artist === "")
            artist = "Unknown Artist"

        if (!title || title === "")
            title = "Unknown Title"

        root.mediaText =
            "♫  " +
            artist +
            " — " +
            title
    }

    Connections {
        target: Mpris.players

        function onObjectInsertedPost() {
            root.updateMedia()
        }

        function onObjectRemovedPost() {
            root.updateMedia()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.updateMedia()
        }
    }

    Component.onCompleted: {
        root.updateMedia()
        root.updateDateTime()
    }

    // ─────────────────────────────────────────
    // DATE / TIME
    // ─────────────────────────────────────────

    function updateDateTime() {
        var now = new Date()

        root.dateTimeText =
            Qt.formatDateTime(
                now,
                "dddd, dd MMMM yyyy, HH:mm"
            )
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            root.updateDateTime()
        }
    }

    // ─────────────────────────────────────────
    // ROUNDED PANEL
    // ─────────────────────────────────────────

    Rectangle {
        id: panel

        anchors.fill: parent

        radius: 10

        color: "#0d1711"

        border.width: 1
        border.color: "#315b3d"

        // ─────────────────────────────────────
        // VIRTUAL DESKTOPS — LEFT
        // ─────────────────────────────────────

        Row {
            anchors {
                left: parent.left
                leftMargin: 16
                verticalCenter: parent.verticalCenter
            }

            spacing: 10

            Repeater {
                model: root.desktopCount

                delegate: Rectangle {
                    required property int index

                    width: 32
                    height: 32

                    radius: 10

                    color:
                        index < root.desktopIds.length &&
                        root.currentDesktopId ===
                        root.desktopIds[index]
                        ? "#a5ffbd"
                        : "#315b3d"

                    border.width: 1

                    border.color:
                        index < root.desktopIds.length &&
                        root.currentDesktopId ===
                        root.desktopIds[index]
                        ? "#a5ffbd"
                        : "#4d9f63"

                    Text {
                        anchors.centerIn: parent

                        text: index + 1

                        color:
                            index < root.desktopIds.length &&
                            root.currentDesktopId ===
                            root.desktopIds[index]
                            ? "#0d1711"
                            : "#a5ffbd"

                        font.family: "IoskeleyMono Nerd Font"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            if (
                                index >= 0 &&
                                index < root.desktopIds.length
                            ) {
                                var target =
                                    root.desktopIds[index]

                                if (
                                    target !==
                                    root.currentDesktopId
                                ) {
                                    switchDesktopProcess.targetDesktop =
                                        target

                                    switchDesktopProcess.running =
                                        true
                                }
                            }
                        }
                    }
                }
            }
        }

        // ─────────────────────────────────────
        // CURRENTLY PLAYING — CENTER
        // ─────────────────────────────────────

        Text {
            id: mediaText

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            width: parent.width - 500

            horizontalAlignment: Text.AlignHCenter

            color: "#a5ffbd"

            font.family: "IoskeleyMono Nerd Font"
            font.pixelSize: 18

            elide: Text.ElideRight

            text: root.mediaText
        }

        // ─────────────────────────────────────
        // DATE / TIME — RIGHT
        // ─────────────────────────────────────

        Text {
            id: dateTimeText

            anchors {
                right: parent.right
                rightMargin: 16
                verticalCenter: parent.verticalCenter
            }

            color: "#a5ffbd"

            font.family: "IoskeleyMono Nerd Font"
            font.pixelSize: 18

            text: root.dateTimeText
        }
    }
}

