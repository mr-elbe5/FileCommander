/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

import AppKit

protocol ModalResponder{
    var responseCode: NSApplication.ModalResponse{get set}
}

class ModalWindowController: NSWindowController, NSWindowDelegate{
    
    convenience init(title: String, viewController: NSViewController, outerWindow: NSWindow, minSize: CGSize){
        let window = ModalWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false)
        window.minSize = minSize
        window.title = title
        window.level = .modalPanel
        window.outerWindow = outerWindow
        self.init(window: window)
        window.delegate = self
        contentViewController = viewController
    }
    
    func windowWillClose(_ notification: Notification) {
        if let responder = contentViewController as? ModalResponder{
            NSApp.stopModal(withCode: responder.responseCode)
        }
        else{
            NSApp.stopModal()
        }
    }
    
}
