/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

extension NSImage {
    
    convenience init?(iconName: String){
        self.init(systemSymbolName: iconName, accessibilityDescription: nil)
    }
    
    func withTintColor(_ col: NSColor) -> NSImage{
        let config = NSImage.SymbolConfiguration(paletteColors: [col])
        return self.withSymbolConfiguration(config)!
    }
    
    var pixelSize: NSSize {
        guard representations.count > 0 else { return NSSize(width: 0, height: 0) }
        
        let rep = self.representations[0]
        return NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
    }
    
}
