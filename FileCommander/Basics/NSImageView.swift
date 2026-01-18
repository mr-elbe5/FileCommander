/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

extension NSImageView{
    
    convenience init(icon: String){
        self.init(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
    }
    
    convenience init(icon: String, color: NSColor){
        self.init(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!.withTintColor(color))
    }
    
}
