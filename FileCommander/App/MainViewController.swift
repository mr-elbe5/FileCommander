/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class MainViewController: ViewController {
    
    static var shared: MainViewController = .init()
    
    private let panels: Dictionary<PanelSide,DirectoryPanel>
    
    var activeSide: PanelSide = .left
    
    override init(){
        panels = [.left: DirectoryPanel(side: .left), .right: DirectoryPanel(side: .right)]
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView(){
        view = NSView()
        panel(.left).setup()
        view.addSubviewToRight(panel(.left), insets: .zero)
            .trailing(view.centerXAnchor, inset: 0)
        panel(.right).setup()
        view.addSubviewToLeft(panel(.right), insets: .zero)
            .leading(view.centerXAnchor, inset: 0)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        panel(.left).viewDidAppear()
        var dir = AppData.shared.context(.left).currentDirectory
        dir.scan()
        setDirectory(dir, side: .left)
        panel(.right).viewDidAppear()
        dir = AppData.shared.context(.right).currentDirectory
        dir.scan()
        setDirectory(dir, side: .right)
        setActiveSide(.left)
    }
    
    func panel(_ side: PanelSide) -> DirectoryPanel{
        switch side{
        case .left: return panels[.left]!
        case .right: return panels[.right]!
        }
    }
    
    func setActiveSide(_ side: PanelSide){
        self.activeSide = side
        if side == .left{
            panel(.left).activate(true)
            panel(.right).activate(false)
        }else{
            panel(.left).activate(false)
            panel(.right).activate(true)
        }
    }
    
    func setDirectory(_ dir: DirectoryData, side: PanelSide){
        panel(side).setDirectory(dir)
    }
    
    func openDirectory(side: PanelSide){
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = URL(string: "/")
        if openPanel.runModal() == .OK, let url = openPanel.urls.first{
            if let directory = AppData.shared.setCurrentDirectory(url: url, side: side){
                Log.info("setting current directory to \(directory.fileName)")
                panel(side).setDirectory(directory)
            }
        }
    }
    
}




