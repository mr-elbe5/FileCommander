/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

final class FlippedClipView: NSClipView {
    
    override var isFlipped: Bool {
        return true
    }
    
}

extension NSScrollView{
    
    func asVerticalScrollView(contentView: NSView, insets : NSEdgeInsets = .defaultInsets){
        self.hasVerticalScroller = true
        self.hasHorizontalScroller = false
        let clipView = FlippedClipView()
        self.contentView = clipView
        clipView.fillSuperview()
        self.documentView = contentView
        contentView.setAnchors(top:clipView.topAnchor, leading: clipView.leadingAnchor, trailing: clipView.trailingAnchor)
    }
    
    func asScrollView(contentView: NSView, insets : NSEdgeInsets = .defaultInsets){
        self.hasVerticalScroller = true
        self.hasHorizontalScroller = true
        let clipView = FlippedClipView()
        self.contentView = clipView
        clipView.fillSuperview()
        self.documentView = contentView
        contentView.setAnchors(top:clipView.topAnchor, leading: clipView.leadingAnchor, trailing: clipView.trailingAnchor)
    }
    
}
