/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class PopoverViewController: ViewController {
    
    static var backgroundColor: NSColor = NSColor(red: 48.0/255.0, green: 50.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    static var bezelColor: NSColor = NSColor(red: 100.0/255.0, green: 101.0/255.0, blue: 104.0/255.0, alpha: 1.0)
    
    var popover = NSPopover()
    
    override init(){
        super.init()
        popover.contentViewController = self
        popover.behavior = .semitransient
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = PopoverView(controller: self)
    }
    
    func close(){
        popover.performClose(nil)
    }
    
}

class PopoverView: NSView{
    
    var controller: PopoverViewController
    
    let contentView = NSView()
    
    init(controller: PopoverViewController){
        self.controller = controller
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close(){
        controller.close()
    }
    
    func setupScrollView(title: String, height: CGFloat) {
        let headerView = NSView()
        headerView.backgroundColor = .secondarySystemFill
        addSubviewBelow(headerView, insets: .zero)
        let titleView = NSTextField(labelWithString: title)
        titleView.alignment = .center
        headerView.addSubviewFilling(titleView, insets: .defaultInsets)
        let closeButton = NSButton(image: NSImage(iconName: "xmark")!, target: self, action: #selector(close))
        closeButton.bezelStyle = .circular
        headerView.addSubviewWithAnchors(closeButton, trailing: headerView.trailingAnchor, insets: .defaultInsets)
            .centerY(headerView.centerYAnchor)
        let scrollView = NSScrollView()
        scrollView.asVerticalScrollView(contentView: contentView)
        addSubviewBelow(scrollView, upperView: headerView, insets: .zero)
            .connectToBottom(of: self, inset: .zero)
            .height(height)
    }
    
    func setupView(title: String) {
        let headerView = NSView()
        headerView.backgroundColor = .secondarySystemFill
        addSubviewBelow(headerView, insets: .zero)
        let titleView = NSTextField(labelWithString: title)
        titleView.alignment = .center
        headerView.addSubviewFilling(titleView, insets: .defaultInsets)
        let closeButton = NSButton(image: NSImage(iconName: "xmark")!, target: self, action: #selector(close))
        closeButton.bezelStyle = .circular
        headerView.addSubviewWithAnchors(closeButton, trailing: headerView.trailingAnchor, insets: .defaultInsets)
            .centerY(headerView.centerYAnchor)
        addSubviewBelow(contentView, upperView: headerView, insets: .zero)
            .connectToBottom(of: self, inset: .zero)
    }
    
}


