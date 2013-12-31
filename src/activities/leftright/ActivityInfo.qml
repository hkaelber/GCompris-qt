import QtQuick 2.0
import GCompris 1.0

ActivityInfo {
    name: "leftright"
    dir: "src/activities/leftright"
    section: "/discovery/miscelaneous"
    difficulty: 1
    icon: "leftright/leftright.svg"
    author: "Pascal Georges (pascal.georges1@free.fr)"
    boarddir: "leftright"
    demo: true
    title: qsTr("Find your left and right hands")
    description: qsTr("Determine if a hand is a right or a left hand")
    goal: qsTr("Distinguish right and left hands from different points of view. Spatial representation")
    prerequisite: ""
    manual: qsTr("You can see a hand: is it a left hand or a right hand? Click on the left button, or the right button depending on the displayed hand.")
    credit: ""
}
