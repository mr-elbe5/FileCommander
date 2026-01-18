/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class ActionViewController: PanelMenuViewController {
    
    var contentView: ActionView{
        view as! ActionView
    }
    
    override func loadView() {
        view = ActionView(controller: self)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 150, height: 0))
        contentView.setupView()
    }
    
}

protocol ActionViewDelegate{
    func copySelected()
    func moveSelected()
    func deleteSelected()
}

class ActionView: PanelMenuView{
    
    var delegate: ActionViewDelegate? = nil
    
    func setupView() {
        super.setupView(title: "actions".localize())
        
        let copyButton = NSButton(title: "\("copy".localize()) [F5]", target: self, action: #selector(copySelected))
        contentView.addSubviewBelow(copyButton)
        let moveButton = NSButton(title: "\("move".localize()) [F6]", target: self, action: #selector(moveSelected))
        contentView.addSubviewBelow(moveButton, upperView: copyButton)
        let deleteButton = NSButton(title: "\("delete".localize()) [F8]", target: self, action: #selector(deleteSelected))
        contentView.addSubviewBelow(deleteButton, upperView: moveButton)
        
            .connectToBottom(of: contentView)
    }
    
    @objc func copySelected(){
        delegate?.copySelected()
        self.close()
    }
    
    @objc func moveSelected(){
        delegate?.moveSelected()
        self.close()
    }
    
    @objc func deleteSelected(){
        delegate?.deleteSelected()
        self.close()
    }
    
}
