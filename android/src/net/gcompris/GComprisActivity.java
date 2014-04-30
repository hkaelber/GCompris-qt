/* GCompris - GComprisActivity.java
 *
 * Copyright (C) 2014 Holger Kaelberer 
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

package net.gcompris;

import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.bindings.QtApplication;
import android.view.KeyEvent;

public class GComprisActivity extends QtActivity
{
        @Override
        public boolean onKeyDown(int keyCode, KeyEvent event)
        {
                if( (event.getKeyCode()==KeyEvent.KEYCODE_VOLUME_UP) || (event.getKeyCode()==KeyEvent.KEYCODE_VOLUME_DOWN) || (event.getKeyCode()==KeyEvent.KEYCODE_VOLUME_MUTE ) ){
                        return super.super_onKeyDown(keyCode,event);
                }
                else{
                        return super.onKeyDown(keyCode,event);
                }
        }
}
