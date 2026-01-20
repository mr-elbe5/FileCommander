/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class ScanViewController: PanelMenuViewController {
    
    var contentView: ScanView{
        view as! ScanView
    }
    
    override func loadView() {
        view = ScanView(controller: self)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 0))
        contentView.setupView()
    }
    
}

protocol ScanViewDelegate{
    func refresh()
    func calculateFolderSizes()
}

class ScanView: PanelMenuView{
    
    var showHiddenButton: NSButton!
    var confirmDeleteButton: NSButton!
    
    var delegate: ScanViewDelegate? = nil
    
    func setupView() {
        super.setupView(title: "scan".localize())
        
        let refreshButton = NSButton(title: "rescan".localize(), target: self, action: #selector(refresh))
        contentView.addSubviewBelow(refreshButton, insets: .defaultInsets)
        
        let calculateFolderSizesButton = NSButton(title: "calculateFolderSizes".localize(), target: self, action: #selector(calculateFolderSizes))
        contentView.addSubviewBelow(calculateFolderSizesButton, upperView: refreshButton, insets: .defaultInsets)
        
            .connectToBottom(of: contentView)
    }
    
    @objc func refresh() {
        delegate?.refresh()
        close()
    }
    
    @objc func calculateFolderSizes(){
        delegate?.calculateFolderSizes()
        close()
    }
    
}
