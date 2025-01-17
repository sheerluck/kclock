/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.11 as Kirigami

Rectangle {
    anchors.fill: parent
    
    property int timerDuration
    property int timerElapsed
    property bool timerRunning
    
    color: "transparent"
    
    function getTimeLeft() {
        return timerDuration - timerElapsed;
    }
    function getHours() {
        return ("0" + parseInt(getTimeLeft() / 60 / 60).toFixed(0)).slice(-2);
    }
    function getMinutes() {
        return ("0" + parseInt(getTimeLeft() / 60 - 60 * getHours())).slice(-2);
    }
    function getSeconds() {
        return ("0" + parseInt(getTimeLeft() - 60 * getMinutes())).slice(-2);
    }
    
    // spinner circle animation
    property int secondsStartAngle
    NumberAnimation on secondsStartAngle {
        id: secondsAngleAnimation
        duration: 1000
    }
    Timer {
        interval: 1000
        running: timerRunning
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            secondsAngleAnimation.from %= 360;
            secondsAngleAnimation.to = secondsAngleAnimation.from + 360;
            secondsAngleAnimation.restart();
        }
    }
    
    // elapsed sweep angle animation (progress circle)
    property int elapsedSweepAngle
    NumberAnimation on elapsedSweepAngle {
        id: elapsedSweepAnimation
        easing.type: Easing.InOutQuad
        duration: 500
    }
    onTimerElapsedChanged: {
        elapsedSweepAnimation.to = 360 * timerElapsed / timerDuration
        elapsedSweepAnimation.start();
    }
    
    // set initial values
    Component.onCompleted: {
        secondsStartAngle = (-90 + 360 * new Date().getMilliseconds() / 1000) % 360;
        elapsedSweepAngle = 360 * timerElapsed / timerDuration;
    }
    
    // timer circle
    Shape {
        anchors.centerIn: parent
        
        id: timerCircle
        implicitWidth: parent.width
        implicitHeight: timerCircleArc.radiusX*2+5
        anchors.horizontalCenter: parent.horizontalCenter
        layer.enabled: true
        layer.samples: 40
        
        Kirigami.Theme.colorSet: Kirigami.Theme.Button
        
        // base circle
        ShapePath {
            id: timerCirclePath
            strokeColor: "lightgrey"
            fillColor: "transparent"
            strokeWidth: 4
            capStyle: ShapePath.FlatCap
            PathAngleArc {
                id: timerCircleArc
                centerX: timerCircle.width / 2; centerY: timerCircle.height / 2;
                radiusX: Math.max(timerpage.width * 0.25, 1); radiusY: radiusX
                startAngle: -180
                sweepAngle: 360
            }
        }
        
        // progress circle
        ShapePath {
            strokeColor: Kirigami.Theme.highlightColor
            fillColor: "transparent"
            strokeWidth: 4
            capStyle: ShapePath.FlatCap
            PathAngleArc {
                centerX: timerCircleArc.centerX; centerY: timerCircleArc.centerY
                radiusX: timerCircleArc.radiusX; radiusY: timerCircleArc.radiusY
                startAngle: -90
                sweepAngle: elapsedSweepAngle
            }
        }
        
        // lapping circle
        ShapePath {
            strokeColor: timerRunning ? "white" : "transparent"
            fillColor: "transparent"
            strokeWidth: 4
            capStyle: ShapePath.FlatCap
            PathAngleArc {
                centerX: timerCircleArc.centerX; centerY: timerCircleArc.centerY
                radiusX: timerCircleArc.radiusX; radiusY: timerCircleArc.radiusY
                startAngle: secondsStartAngle % 360
                sweepAngle: 16
            }
        }
    }
    
    // clock display
    RowLayout {
        id: timeLabels
        anchors.centerIn: timerCircle

        Label {
            id: hoursText
            text: getHours()
            font.pointSize: Kirigami.Theme.defaultFont.pointSize*3
            font.family: clockFont.name
            font.weight: Font.Light
            color: timerRunning ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            visible: text != "00"
        }
        Label {
            text: ":"
            font.pointSize: Kirigami.Theme.defaultFont.pointSize*3
            font.family: clockFont.name
            font.weight: Font.Light
            color: timerRunning ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            visible: getHours() != "00"
        }
        Label {
            id: minutesText
            text: getMinutes()
            font.pointSize: Kirigami.Theme.defaultFont.pointSize*3
            font.family: clockFont.name
            font.weight: Font.Light
            color: timerRunning ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
        }
        Label {
            text: ":"
            font.pointSize: Kirigami.Theme.defaultFont.pointSize*3
            font.family: clockFont.name
            font.weight: Font.Light
            color: timerRunning ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
        }
        Label {
            text: getSeconds()
            font.pointSize: Kirigami.Theme.defaultFont.pointSize*3
            font.family: clockFont.name
            font.weight: Font.Light
            color: timerRunning ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
        }
    }
}
