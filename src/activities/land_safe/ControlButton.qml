/* GCompris - ControlButton.qml
 *
 * Copyright (C) 2016 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import GCompris 1.0

Image {
    id: root
    state: "notclicked"
    sourceSize.width: 75 * ApplicationInfo.ratio

    signal clicked
    signal pressed
    signal released

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
        onPressed: root.pressed()
        onReleased: root.released()
    }

    states: [
        State {
            name: "notclicked"
            PropertyChanges {
                target: root
                scale: 1.0
            }
        },
        State {
            name: "clicked"
            when: mouseArea.pressed
            PropertyChanges {
                target: root
                scale: 0.9
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: root
                scale: 1.1
            }
        }
    ]

    Behavior on scale { NumberAnimation { duration: 70 } }
//    Behavior on opacity { PropertyAnimation { duration: 200 } }

}
