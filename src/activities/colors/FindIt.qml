/* GCompris - Colors.qml
 *
 * Original activity in the Gtk+ version of GCompris by
 * Pascal Georges (pascal.georges1@free.fr)
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtGraphicalEffects 1.0
import GCompris 1.0

import "../../core"
import "findit.js" as Activity

ActivityBase {
    id: activity
    focus: true

    property var dataset
    property string backgroundImg
    property int itemWidth
    property int itemHeight
    
    property string mode: ""

    pageComponent: Image {
        id: background
        focus: true
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        source: backgroundImg

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }
        QtObject {
            id: items
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias containerModel: containerModel
            property alias questionItem: questionItem
            // On startup we want to queue the first sound but not after
            property bool firstQuestion: true
            property bool audioOk: false
        }
        onStart: Activity.start(items, dataset, mode)
        onStop: Activity.stop()

        ListModel {
              id: containerModel
        }

        GridView {
            id: container
            model: containerModel
            x: background.width * 0.2
            y: background.height * 0.2
            width: background.width * 0.7
            height: background.height * 0.6
            interactive: false
            cellWidth: itemHeight + 10
            cellHeight: itemWidth + 10
            delegate: ColorItem {
                audioVoices: activity.audioVoices
                source: model.image
                audioSrc: model.audio ? model.audio : ""
                question: model.text
                sourceSize.height: itemHeight
                sourceSize.width: itemWidth
            }
        }

        GCText {
            id: questionItem
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            font.pointSize: 24
            font.weight: Font.DemiBold
            style: Text.Outline
            styleColor: "black"
            color: "white"

            function initQuestion() {
                text = Activity.getCurrentTextQuestion()
                if(Activity.getCurrentAudioQuestion()) {
                    if(items.firstQuestion)
                        items.audioOk = activity.audioVoices.append(Activity.getCurrentAudioQuestion())
                    else
                        items.audioOk = activity.audioVoices.play(Activity.getCurrentAudioQuestion())
                    items.firstQuestion = false
                }
                opacity = 1.0
            }

            onOpacityChanged: opacity == 0 ? initQuestion() : ""
            Behavior on opacity { PropertyAnimation { duration: 500 } }
        }

        DropShadow {
            anchors.fill: questionItem
            cached: true
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8.0
            samples: 16
            color: "#80000000"
            source: questionItem
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svgz";
            sourceSize.width: 80 * ApplicationInfo.ratio
            z: bar.z + 1
            visible: items.audioOk
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: 10 * ApplicationInfo.ratio
            }
            onClicked: if (ApplicationSettings.isAudioVoicesEnabled)
                           questionItem.initQuestion()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

    }

}
