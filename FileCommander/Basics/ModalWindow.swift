/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

import AppKit

class ModalWindow: NSWindow{
    
    static var defaultMinSize = CGSize(width: 300, height: 200)
    
    @discardableResult
    static func run(title: String, viewController: NSViewController, outerWindow: NSWindow, minSize: CGSize) -> NSApplication.ModalResponse{
        let controller = ModalWindowController(title: title, viewController: viewController, outerWindow: outerWindow, minSize: minSize)
        controller.window?.minSize = minSize
        return NSApp.runModal(for: controller.window!)
    }
    
    var outerWindow: NSWindow? = nil
    
    override func center(){
        if let outerFrame = outerWindow?.frame{
            let newOrigin = CGPoint(x: outerFrame.minX + (outerFrame.width - frame.width)/2, y: outerFrame.minY + outerFrame.height - frame.height - 100)
            self.setFrameOrigin(newOrigin)
        }
        else{
            super.center()
        }
    }
    
}
