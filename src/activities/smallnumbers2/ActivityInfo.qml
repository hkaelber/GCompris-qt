/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "smallnumbers2/Smallnumbers2.qml"
  difficulty: 2
  icon: "smallnumbers2/smallnumbers2.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  demo: false
  title: qsTr("Numbers with pairs of dice")
  description: qsTr("Count the number of dots on dice before they reach the ground")
//  intro: "Count the number of the points on the dice then type the result on your keyboard."
  goal: qsTr("In a limited time, count the number of dots")
  prerequisite: qsTr("Counting skills")
  manual: qsTr("With the keyboard, type the number of dots you see on the falling dice.")
  credit: ""
  section: "math numeration"
}
