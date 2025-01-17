/*
 * Copyright 2021 Devin Lin <espidev@gmail.com>
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

import QtQuick 2.15
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.15 as Kirigami
import kclock 1.0
        
Loader {
    id: loader
    sourceComponent: Kirigami.Settings.isMobile ? mobileTimerForm : desktopTimerForm
    
    function createTimer(duration, label) {
        timerModel.addNew(duration, label);
    }
    
    Component {
        id: mobileTimerForm
        Kirigami.OverlayDrawer {
            height: contents.implicitHeight + Kirigami.Units.largeSpacing
            width: timerPage.width
            edge: Qt.BottomEdge
            parent: applicationWindow().overlay
            
            ColumnLayout {
                id: contents
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 0
                
                Kirigami.Icon {
                    Layout.margins: Kirigami.Units.smallSpacing
                    source: "arrow-down"
                    implicitWidth: Kirigami.Units.gridUnit
                    implicitHeight: Kirigami.Units.gridUnit
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Kirigami.Heading {
                    level: 3
                    text: i18n("<b>Create New Timer</b>")
                    Layout.alignment: Qt.AlignHCenter
                }
                
                TimerForm {
                    id: timerForm
                    Layout.leftMargin: Kirigami.Units.largeSpacing
                    Layout.rightMargin: Kirigami.Units.largeSpacing
                    Layout.bottomMargin: Kirigami.Units.largeSpacing
                    Layout.fillWidth: true
                    wideMode: false
                }
                
                RowLayout {
                    Layout.margins: Kirigami.Units.largeSpacing
                    Item { Layout.fillWidth: true }
                    Button {
                        icon.name: "dialog-cancel"
                        text: i18n("Cancel")
                        onClicked: close()
                    }
                    Button {
                        icon.name: "dialog-ok"
                        text: i18n("Done")
                        onClicked: {
                            loader.createTimer(timerForm.getDuration(), timerForm.name);
                            close();
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: desktopTimerForm
        Kirigami.OverlaySheet {
            parent: applicationWindow().overlay
            
            header: Kirigami.Heading {
                level: 2
                text: i18n("Create timer")
            }
            footer: RowLayout {
                Item { Layout.fillWidth: true }
                Button {
                    icon.name: "dialog-cancel"
                    text: i18n("Cancel")
                    onClicked: close()
                }
                Button {
                    icon.name: "dialog-ok"
                    text: i18n("Done")
                    onClicked: {
                        loader.createTimer(timerForm.getDuration(), timerForm.name);
                        close();
                    }
                }
            }
            
            contentItem: ColumnLayout {
                TimerForm {
                    id: timerForm
                    Layout.fillWidth: true
                }
            }
        }
    }
} 
