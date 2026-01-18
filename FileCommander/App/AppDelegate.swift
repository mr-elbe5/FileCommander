/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, Sendable {
    
    var mainWindowController = MainWindowController.instance
    
    var mainViewController: MainViewController{
        mainWindowController.mainViewController
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        AppData.load()
        createMenu()
        mainWindowController.showWindow(nil)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        AppData.shared.save()
    }
    
    func createMenu(){
        let mainMenu = NSMenu()
        
        let appMenu = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        appMenu.submenu = NSMenu(title: "")
        appMenu.submenu?.addItem(withTitle: "about".localize(), action: #selector(openAbout), keyEquivalent: "n")
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(withTitle: "hideMe".localize(), action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        appMenu.submenu?.addItem({ () -> NSMenuItem in
            let m = NSMenuItem(title: "hideOthers".localize(), action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
            m.keyEquivalentModifierMask = [.command, .option]
            return m
        }())
        appMenu.submenu?.addItem(withTitle: "showAll".localize(), action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenu.submenu?.addItem(NSMenuItem.separator())
        let appServicesMenu     = NSMenu()
        NSApp.servicesMenu      = appServicesMenu
        appMenu.submenu?.addItem(withTitle: "services".localize(), action: nil, keyEquivalent: "").submenu = appServicesMenu
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(withTitle: "quit".localize(), action: #selector(quitApp), keyEquivalent: "q")
        
        let fileMenu = NSMenuItem(title: "file".localize(), action: nil, keyEquivalent: "")
        fileMenu.submenu = NSMenu(title: "file".localize())
        fileMenu.submenu?.addItem(withTitle: "openLeftDirectory".localize() + "...", action: #selector(openLeftDirectory), keyEquivalent: "l")
        fileMenu.submenu?.addItem(withTitle: "openRightDirectory".localize() + "...", action: #selector(openRightDirectory), keyEquivalent: "r")
        fileMenu.submenu?.addItem(NSMenuItem.separator())
        
        let appWindowMenu     = NSMenu(title: "window".localize())
        NSApp.windowsMenu     = appWindowMenu
        let windowMenu = NSMenuItem(title: "window".localize(), action: nil, keyEquivalent: "")
        windowMenu.submenu = appWindowMenu
        
        let helpMenu = NSMenuItem(title: "help".localize(), action: nil, keyEquivalent: "")
        helpMenu.submenu = NSMenu(title: "help".localize())
        helpMenu.submenu?.addItem(withTitle: "help".localize(), action: #selector(openHelp), keyEquivalent: "o")
        
        
        mainMenu.addItem(appMenu)
        mainMenu.addItem(fileMenu)
        mainMenu.addItem(windowMenu)
        mainMenu.addItem(helpMenu)
        
        NSApp.mainMenu = mainMenu
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func openAbout() {
        NSApplication.shared.orderFrontStandardAboutPanel(nil)
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc func openLeftDirectory() {
        mainViewController.openDirectory(side: .left)
    }
    
    @objc func openRightDirectory() {
        mainViewController.openDirectory(side: .right)
    }
    
    @objc func openHelp() {
        MainWindowController.instance.openHelp()
    }
    
}

