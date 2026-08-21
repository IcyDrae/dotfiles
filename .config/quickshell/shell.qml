import QtQuick
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root

    aboveWindows: false

    anchors {
        top: true
        right: true
    }

    margins {
        top: 100
        right: 20
    }

    implicitWidth: 440
    implicitHeight: 420

    color: "transparent"

    // ─────────────────────────────────────────
    // DATA
    // ─────────────────────────────────────────

    property string cpuUsage: "..."
    property string memoryUsage: "..."
    property string uptime: "..."
    property string packages: "..."

    // CPU
    Process {
        id: cpuProcess

        command: [
            "sh",
            "-c",
            "read -r _ u1 n1 s1 i1 w1 irq1 sirq1 st1 rest < /proc/stat; t1=$((u1+n1+s1+i1+w1+irq1+sirq1+st1)); idle1=$((i1+w1)); sleep 0.5; read -r _ u2 n2 s2 i2 w2 irq2 sirq2 st2 rest < /proc/stat; t2=$((u2+n2+s2+i2+w2+irq2+sirq2+st2)); idle2=$((i2+w2)); awk -v dt=$((t2-t1)) -v di=$((idle2-idle1)) 'BEGIN { if (dt > 0) printf \"%.0f%%\", (1-di/dt)*100; else print \"0%\" }'"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.cpuUsage = this.text.trim()
            }
        }
    }

    // Restart CPU process after it finishes
    Connections {
        target: cpuProcess

        function onRunningChanged() {
            if (!cpuProcess.running) {
                cpuProcess.running = true
            }
        }
    }

    // Memory
    Process {
        id: memoryProcess

        command: [
            "sh",
            "-c",
            "free -b | awk '/^Mem:/ {printf \"%.1f / %.1f GB\", $3/1073741824, $2/1073741824}'"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.memoryUsage = this.text.trim()
            }
        }
    }

    // Uptime
    Process {
        id: uptimeProcess

        command: [
            "uptime",
            "-p"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.uptime = this.text.trim().replace("up ", "")
            }
        }
    }

    // Packages
    Process {
        id: packagesProcess

        command: [
            "sh",
            "-c",
            "rpm -qa | wc -l"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.packages = this.text.trim()
            }
        }
    }

    // ─────────────────────────────────────────
    // UPDATE TIMER
    // ─────────────────────────────────────────

    Timer {
        interval: 2000
        running: true
        repeat: true

        onTriggered: {
            memoryProcess.running = true
            uptimeProcess.running = true
            packagesProcess.running = true
        }
    }

    // ─────────────────────────────────────────
    // PANEL
    // ─────────────────────────────────────────

    Rectangle {
        anchors.fill: parent

        color: "#0d1711"
        radius: 10

        border.width: 1
        border.color: "#4d9f63"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1

            color: "transparent"
            radius: 21

            opacity: 0.35
        }

        Column {
            anchors {
                fill: parent
                margins: 24
            }

            spacing: 6

            // HEADER

            Text {
                text: "~/reard"
                color: "#a5ffbd"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 24
                font.bold: true
                font.letterSpacing: 3
            }

            Text {
                text: "SYSTEM MONITOR"
                color: "#6d9d7a"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 22
                font.letterSpacing: 2
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#315b3d"

                anchors.topMargin: 12
                anchors.bottomMargin: 12
            }

            // CPU

            Text {
                text: "CPU"
                color: "#71977b"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: root.cpuUsage
                color: "#d9f5df"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 22
            }

            Item {
                width: 1
                height: 8
            }

            // MEMORY

            Text {
                text: "MEMORY"
                color: "#71977b"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: root.memoryUsage
                color: "#d9f5df"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 22
            }

            Item {
                width: 1
                height: 8
            }

            // UPTIME

            Text {
                text: "UPTIME"
                color: "#71977b"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: root.uptime
                color: "#d9f5df"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 22
            }

            Item {
                width: 1
                height: 8
            }

            // PACKAGES

            Text {
                text: "PACKAGES"
                color: "#71977b"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: root.packages
                color: "#d9f5df"

                font.family: "IoskeleyMono Nerd Font"
                font.pixelSize: 22
            }
        }
    }
}

