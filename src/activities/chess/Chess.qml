/* GCompris - chess.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
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
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0

import "../../core"
import "."
import "chess.js" as Activity

ActivityBase {
    id: activity

    property bool acceptClick: true
    property bool twoPlayers: false
    // difficultyByLevel means that at level 1 computer is bad better at last level
    property bool difficultyByLevel: true
    property variant fen: [
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"],
        ["initial state", "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 1 1"]
    ]

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + 'background-wood.svg'
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCAudio audioEffects: activity.audioEffects
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property bool isPortrait: (background.height > background.width)
            property int cellSize: items.isPortrait ?
                                       Math.min(background.width / (8 + 2),
                                                (background.height - controls.height) / (8 + barHeightAddon)) :
                                       Math.min(background.width / (8 + 2), background.height / (8 + barHeightAddon))
            property variant fen: activity.fen
            property bool twoPlayer: activity.twoPlayers
            property bool difficultyByLevel: activity.difficultyByLevel
            property var positions
            property var pieces: pieces
            property var squares: squares
            property var history
            property var redo_stack
            property alias redoTimer: redoTimer
            property int from
            property bool blackTurn
            property bool gameOver
            property string message
            property alias trigComputerMove: trigComputerMove

            Behavior on cellSize { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1000 } }
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Grid {
            anchors {
                top: parent.top
                topMargin: items.isPortrait ? 0 : items.cellSize / 2
                leftMargin: 10 * ApplicationInfo.ratio
                rightMargin: 10 * ApplicationInfo.ratio
            }
            columns: (items.isPortrait==true)?1:3
            rows: (items.isPortrait==true)?2:1
            width: (items.isPortrait==true)?undefined:background.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter

            Column {
                id: controls
                anchors {
                    leftMargin: 10
                    rightMargin: 10
                }
                width: items.isPortrait ?
                           parent.width :
                           Math.max(undo.width * 1.2,
                                    Math.min(
                                        (background.width * 0.9 - undo.width - chessboard.width),
                                        (background.width - chessboard.width) / 2))

                GCText {
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    fontSize: smallSize
                    text: items.message
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: TextEdit.WordWrap
                }

                Grid {
                    spacing: 10
                    columns: items.isPortrait ? 3 : 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalItemAlignment: Grid.AlignHCenter
                    verticalItemAlignment: Grid.AlignVCenter

                    Button {
                        id: undo
                        height: 30 * ApplicationInfo.ratio
                        text: qsTr("Undo");
                        style: GCButtonStyle {}
                        onClicked: Activity.undo()
                        enabled: items.history.length > 0 ? 1 : 0
                        opacity: enabled
                        Behavior on opacity {
                            PropertyAnimation {
                                easing.type: Easing.InQuad
                                duration: 200
                            }
                        }
                    }

                    Button {
                        id: redo
                        height: 30 * ApplicationInfo.ratio
                        text: qsTr("Redo");
                        style: GCButtonStyle {}
                        onClicked: {
                            if (!twoPlayers) {
                                acceptClick = false;
                                Activity.redo()
                            } else {
                                Activity.redo()
                            }
                        }
                        enabled: items.redo_stack.length > 0 && acceptClick ? 1 : 0
                        opacity: enabled
                        Behavior on opacity {
                            PropertyAnimation {
                                easing.type: Easing.InQuad
                                duration: 200
                            }
                        }
                    }

                    Button {
                        height: 30 * ApplicationInfo.ratio
                        text: qsTr("Swap");
                        style: GCButtonStyle {}
                        enabled: items.twoPlayer
                        opacity: enabled
                        onClicked: chessboard.swap()
                    }
                }
            }

            
            Rectangle {
                id:boardBg
                width: items.cellSize * 8.2
                height: items.cellSize * 8.2
                z: 09
                color: "#3A1F0A"
                
            
            
            // The chessboard
            GridView {
                id: chessboard
                cellWidth: items.cellSize
                cellHeight: items.cellSize
                width: items.cellSize * 8
                height: items.cellSize * 8
                interactive: false
                keyNavigationWraps: true
                model: 64
                layoutDirection: Qt.RightToLeft
                delegate: square
                rotation: 180
                z: 10
                anchors.centerIn: boardBg

                Component {
                    id: square
                    Image {
                        source: index % 2 + (Math.floor(index / 8) % 2) == 1 ?
                                   Activity.url + 'chess-white.svg' : Activity.url + 'chess-black.svg';
                        width: items.cellSize
                        height: items.cellSize
                    }
                }

                Behavior on rotation { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 1400 } }

                function swap() {
                    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/flip.wav')
                    if(chessboard.rotation == 180)
                        chessboard.rotation = 0
                    else
                        chessboard.rotation = 180
                }
            }
            }
            
        }

        Repeater {
            id: squares
            model: items.positions
            delegate: square
            parent: chessboard

            DropArea {
                id: square
                x: items.cellSize * (7 - pos % 8) + spacing / 2
                y: items.cellSize * Math.floor(pos / 8) + spacing / 2
                width: items.cellSize - spacing
                height: items.cellSize - spacing
                z: 1
                keys: acceptMove ? ['acceptMe'] : ['sorryNo']
                property bool acceptMove : false
                property int pos: modelData.pos
                property int spacing: 6 * ApplicationInfo.ratio
                Rectangle {
                    id: possibleMove
                    anchors.fill: parent
                    color: parent.containsDrag ? '#803ACAFF' : 'transparent'
                    border.width: parent.acceptMove ? 5 : 0
                    border.color: '#FF808080'
                    z: 1
                }
            }

            function getSquareAt(pos) {
                for(var i=0; i < squares.count; i++) {
                    if(squares.itemAt(i).pos === pos)
                        return squares.itemAt(i)
                }
                return(undefined)
            }
        }

        Repeater {
            id: pieces
            model: items.positions
            delegate: piece
            parent: chessboard

            Piece {
                id: piece
                sourceSize.width: items.cellSize
                width: items.cellSize - spacing
                height: items.cellSize - spacing
                source: img ? Activity.url + img + '.svg' : ''
                img: modelData.img
                x: items.cellSize * (7 - pos % 8) + spacing / 2
                y: items.cellSize * Math.floor(pos / 8) + spacing / 2
                z: 1
                pos: modelData.pos
                newPos: modelData.pos
                rotation: - chessboard.rotation

                property int spacing: 6 * ApplicationInfo.ratio

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    enabled: !items.gameOver
                    drag.target: parent
                    onPressed: {
                        piece.Drag.keys = ['acceptMe']
                        parent.z = 100
                        if(parent.isWhite == 1 && !items.blackTurn ||
                                parent.isWhite == 0 && items.blackTurn) {
                            items.from = parent.newPos
                            Activity.showPossibleMoves(items.from)
                        } else if(items.from != -1 && squares.getSquareAt(parent.newPos)['acceptMove']) {
                            Activity.moveTo(items.from, parent.newPos)
                        }
                    }
                    onReleased: {
                        // If no target or move not possible, we reset the position
                        if(!piece.Drag.target || (items.from != -1 && !Activity.moveTo(items.from, piece.Drag.target.pos))) {
                            var pos = parent.pos
                            // Force recalc of the old x,y position
                            parent.pos = -1
                            pieces.getPieceAt(pos).move(pos)
                        }
                    }
                }
            }

            function moveTo(from, to) {
                items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                var fromPiece = getPieceAt(from)
                var toPiece = getPieceAt(to)
                if(toPiece.img != '')
                    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/smudge.wav')
                else
                    items.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                toPiece.hide(from)
                fromPiece.move(to)
            }

            function promotion(to) {
                var toPiece = getPieceAt(to)
                toPiece.promotion()
            }

            function getPieceAt(pos) {
                for(var i=0; i < pieces.count; i++) {
                    if(pieces.itemAt(i).newPos == pos)
                        return pieces.itemAt(i)
                }
                return(undefined)
            }
        }

        Timer {
            id: trigComputerMove
            repeat: false
            interval: 400
            onTriggered: Activity.randomMove()
        }

        // Use to redo the computer move after the user move
        Timer {
            id: redoTimer
            repeat: false
            interval: 400
            onTriggered: {
                acceptClick = true;
                Activity.moveByEngine(move)
            }
            property var move

            function moveByEngine(engineMove) {
                move = engineMove
                redoTimer.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | (items.twoPlayer ? 0 : level) |
                                             (items.twoPlayer && !items.gameOver ? 0 : reload) }

            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
        }

        Bonus {
            id: bonus
        }
    }

}
