/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

extension NSTextField{
    
    @discardableResult
    func asHeadline() -> NSTextField{
        isBezeled = false
        drawsBackground = false
        isEditable = false
        isSelectable = false
        font = NSFont.preferredFont(forTextStyle: .headline)
        maximumNumberOfLines = 0
        return self
    }
    
    @discardableResult
    func asLabel(text: String) -> NSTextField{
        isBezeled = false
        drawsBackground = false
        isEditable = false
        isSelectable = false
        return self
    }
    
    func asEditableField(text: String) -> NSTextField{
        isBezeled = false
        drawsBackground = false
        isEditable = true
        isSelectable = false
        return self
    }
    
    func compressable() -> NSTextField{
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return self
    }
    
    func smallCompressable() -> NSTextField{
        font = .systemFont(ofSize: NSFont.smallSystemFontSize)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return self
    }

}
