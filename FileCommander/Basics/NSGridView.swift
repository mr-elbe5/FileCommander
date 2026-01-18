/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

extension NSGridView{
    
    @discardableResult
    func addLabeledRow(label: String, views: [NSView]) -> NSGridRow{
        var arr = [NSView]()
        arr.append(NSTextField(labelWithString: label))
        arr.append(contentsOf: views)
        return addRow(with: arr)
    }
    
    @discardableResult
    func addLabeledRow(label: String, view: NSView) -> NSGridRow{
        var arr = [NSView]()
        let labelView = NSTextField(labelWithString: label)
        arr.append(labelView)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        arr.append(view)
        return addRow(with: arr)
    }
    
    @discardableResult
    func addSmallLabeledRow(label: String, view: NSView) -> NSGridRow{
        var arr = [NSView]()
        let labelView = NSTextField(labelWithString: label).smallCompressable()
        arr.append(labelView)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        arr.append(view)
        return addRow(with: arr)
    }
    
}

