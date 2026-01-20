/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

class DirectoryPanel: NSView {
    
    let side: PanelSide
    
    var openDirectoryButton: NSButton!
    var selectButton: NSButton!
    var actionButton: NSButton!
    var settingsButton: NSButton!
    var scanButton: NSButton!
    var nameButton: NSButton!
    
    let scrollView = NSScrollView()
    
    var tableView: DirectoryTableView
    
    var context: PanelContext{
        AppData.shared.context(side)
    }
    
    init(side: PanelSide) {
        self.side = side
        tableView = DirectoryTableView(side: side)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        backgroundColor = .windowBackgroundColor
        let menu = NSView()
        addSubviewBelow(menu, insets: .zero)
        
        nameButton = NSButton(title: "", target: self, action: #selector(setPanelActive))
        nameButton.isBordered = false
        nameButton.font = .systemFont(ofSize: 14, weight: .regular)
        nameButton.alignment = .right
        menu.addSubviewToLeft(nameButton, insets: .defaultInsets)
        
        let buttonView = NSView()
        buttonView.backgroundColor = .windowBackgroundColor
        menu.addSubviewToRight(buttonView, insets: .zero)
        openDirectoryButton = NSButton(image: NSImage(systemSymbolName: "folder", accessibilityDescription: nil)!, target: self, action: #selector(openDirectory))
        openDirectoryButton.toolTip = "open".localize()
        buttonView.addSubviewToRight(openDirectoryButton, insets: .defaultInsets)
        selectButton = NSButton(image: NSImage(systemSymbolName: "text.line.first.and.arrowtriangle.forward", accessibilityDescription: nil)!, target: self, action: #selector(openSelect))
        selectButton.toolTip = "selection".localize()
        buttonView.addSubviewToRight(selectButton, leftView: openDirectoryButton, insets: .defaultInsets)
        actionButton = NSButton(image: NSImage(systemSymbolName: "filemenu.and.selection", accessibilityDescription: nil)!, target: self, action: #selector(openAction))
        actionButton.toolTip = "action".localize()
        buttonView.addSubviewToRight(actionButton, leftView: selectButton, insets: .defaultInsets)
        scanButton = NSButton(image: NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil)!, target: self, action: #selector(openScan))
        scanButton.toolTip = "scan".localize()
        buttonView.addSubviewToRight(scanButton, leftView: actionButton, insets: .defaultInsets)
        settingsButton = NSButton(image: NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)!, target: self, action: #selector(openSettings))
        settingsButton.toolTip = "settings".localize()
        buttonView.addSubviewToRight(settingsButton, leftView: scanButton, insets: .defaultInsets)
            .connectToRight(of: buttonView, inset: -10)
        
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        scrollView.documentView = tableView
        addSubviewBelow(scrollView, upperView: menu, insets: .zero)
            .connectToBottom(of: self)
        tableView.actionDelegate = self
    }
    
    func viewDidAppear() {
        tableView.viewDidAppear()
    }
    
    func activate(_ active: Bool){
        nameButton.font = .systemFont(ofSize: 14, weight: active ? .bold : .regular)
    }
    
    func setDirectory(_ dir: DirectoryData){
        tableView.setDirectory(dir)
    }
    
    @discardableResult
    func updateDirectory() -> Bool{
        if let directory = tableView.directory{
            directory.scan()
            return true
        }
        return false
    }
    
    @objc func setPanelActive(){
        MainViewController.shared.setActiveSide(side)
    }
    
    @objc func openDirectory() {
        MainViewController.shared.openDirectory(side: side)
    }
    
    @objc func openSettings() {
        let controller = SettingsViewController(side: side)
        controller.contentView.delegate = self
        controller.popover.show(relativeTo: settingsButton.bounds, of: settingsButton, preferredEdge: .maxY)
    }
    
    @objc func openAction() {
        let controller = ActionViewController(side: side)
        controller.contentView.delegate = self
        controller.popover.show(relativeTo: actionButton.bounds, of: actionButton, preferredEdge: .maxY)
    }
        
    @objc func openSelect() {
        let controller = SelectViewController(side: side)
        controller.contentView.delegate = self
        controller.popover.show(relativeTo: selectButton.bounds, of: selectButton, preferredEdge: .maxY)
    }
    
    @objc func openScan() {
        let controller = ScanViewController(side: side)
        controller.contentView.delegate = self
        controller.popover.show(relativeTo: scanButton.bounds, of: scanButton, preferredEdge: .maxY)
    }
    
}

extension DirectoryPanel: SettingsViewDelegate{
    
    func showHiddenChanged() {
        if updateDirectory(){
            tableView.reloadData()
        }
    }
    
    func showExifDataChanged() {
        tableView.showColumn("gps", context.showExifData)
        tableView.showColumn("exifdate", context.showExifData)
        tableView.reloadData()
    }

}

extension DirectoryPanel: SelectViewDelegate{
    
    func selectAllFiles() {
        tableView.selectAll(nil)
    }
    
    func deselectAllFiles() {
        tableView.deselectAll(nil)
    }
    
    func selectMatchingItems() {
        tableView.selectMatchingItems()
    }
    
    func selectNotMatchingItems() {
        tableView.selectNotMatchingItems()
    }

}

extension DirectoryPanel: ActionViewDelegate{
    
    func copySelected() {
        tableView.copySelectedToOtherSide()
    }
    
    func moveSelected() {
        tableView.moveSelectedToOtherSide()
    }
    
    func deleteSelected() {
        tableView.deleteSelected()
    }
    
}

extension DirectoryPanel: ScanViewDelegate{
    
    @objc func refresh() {
        updateDirectory()
        tableView.reloadData()
    }
    
    func calculateFolderSizes() {
        tableView.calculateFolderSizes()
    }
    
    
}

extension DirectoryPanel: PanelActionDelegate{
    
    func directoryChanged() {
        nameButton.title = tableView.directory?.path ?? ""
    }
    
    func activated() {
        //print("active side is \(side.rawValue)")
        MainViewController.shared.setActiveSide(side)
    }
    
    
}
