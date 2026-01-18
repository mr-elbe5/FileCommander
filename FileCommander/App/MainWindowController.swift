/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

class MainWindowController: NSWindowController {
    
    static var windowId = "fileControllerMainWindow"
    
    static var instance = MainWindowController()
    
    static var defaultSize: NSSize = NSMakeSize(900, 600)
    static var defaultRect: NSRect{
        var x : CGFloat = 0
        var y : CGFloat = 0
        if let screen = NSScreen.main{
            x = screen.frame.width/2 - defaultSize.width/2
            y = screen.frame.height/2 - defaultSize.height/2
        }
        return NSMakeRect(x, y, defaultSize.width, defaultSize.height)
    }
    
    var toolbar: NSToolbar!
    let mainWindowToolbarIdentifier = NSToolbar.Identifier("MainWindowToolbar")
    var helpButton: NSButton!
    let toolbarItemHelp = NSToolbarItem.Identifier("ToolbarHelpItem")
    
    var mainViewController: MainViewController{
        contentViewController as! MainViewController
    }
    
    init(){
        let window = NSWindow(contentRect: MainWindowController.defaultRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
        window.title = "File Commander"
        window.minSize = CGSize(width: 800, height: 600)
        super.init(window: window)
        helpButton = ToolbarButton(title: "help".localize(), icon: "questionmark.circle",target: self,action: #selector(openHelp))
        toolbar = NSToolbar(identifier: mainWindowToolbarIdentifier).asCustomToolbar()
        toolbar.delegate = self
        window.delegate = self
        window.toolbar = toolbar
        window.toolbar?.validateVisibleItems()
        contentViewController = MainViewController.shared
        if !window.setFrameUsingName(Self.windowId){
            window.setFrame(Self.defaultRect, display: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
        
extension MainWindowController: NSWindowDelegate{
    
    func windowWillClose(_ notification: Notification) {
        window?.saveFrame(usingName: MainWindowController.windowId)
        NSApplication.shared.terminate(self)
    }
    
}

extension MainWindowController: NSToolbarDelegate {
    
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if  itemIdentifier == toolbarItemHelp {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.paletteLabel = helpButton.title
            toolbarItem.view = helpButton
            return toolbarItem
        }
    
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            toolbarItemHelp
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [toolbarItemHelp,
         NSToolbarItem.Identifier.space,
         NSToolbarItem.Identifier.flexibleSpace]
    }
    
    @objc func openHelp() {
        let controller = HelpViewController()
        controller.popover.show(relativeTo: helpButton.bounds, of: helpButton, preferredEdge: .maxY)
    }
    
}




