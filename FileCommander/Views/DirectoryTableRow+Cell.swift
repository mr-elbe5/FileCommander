/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class TableRow: NSTableRowView{
    
    override func drawSelection(in dirtyRect: NSRect) {
        if self.selectionHighlightStyle != .none {
            let selectionRect = NSInsetRect(self.bounds, 1, 1)
            NSColor(calibratedWhite: 0.5, alpha: 1).setFill()
            selectionRect.fill()
        }
    }
    
}

class TextCellView: NSTableCellView{
    
    let txtField = NSTextField(labelWithString: "")
    
    var alignment: NSTextAlignment{
        get{
            txtField.alignment
        }
        set{
            txtField.alignment = newValue
        }
    }
    
    var text: String{
        get{
            txtField.stringValue
        }
        set{
            txtField.stringValue = newValue
        }
    }
    
    init(identifier: NSUserInterfaceItemIdentifier){
        super.init(frame: .zero)
        self.identifier = identifier
        backgroundColor = .clear
        txtField.drawsBackground = false
        addSubviewWithAnchors(txtField, leading: leadingAnchor, trailing: trailingAnchor, insets: .zero)
            .centerY(centerYAnchor)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageCellView: NSTableCellView{
    
    let imgView = NSImageView()
    
    var image: NSImage?{
        get{
            imgView.image
        }set{
            imgView.image = newValue
        }
    }
    
    init(identifier: NSUserInterfaceItemIdentifier){
        super.init(frame: .zero)
        self.identifier = identifier
        backgroundColor = .clear
        imgView.backgroundColor = .clear
        //imageView = imgView
        addSubviewFilling(imgView, insets: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

