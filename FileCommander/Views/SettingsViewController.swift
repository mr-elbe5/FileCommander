/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class SettingsViewController: PanelMenuViewController {
    
    var contentView: SettingsView{
        view as! SettingsView
    }
    
    override func loadView() {
        view = SettingsView(controller: self)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 0))
        contentView.setupView()
    }
    
}

protocol SettingsViewDelegate{
    func showHiddenChanged()
    func showExifDataChanged()
}

class SettingsView: PanelMenuView{
    
    var showHiddenButton: NSButton!
    var showExifDataButton: NSButton!
    var confirmDeleteButton: NSButton!
    
    var delegate: SettingsViewDelegate? = nil
    
    func setupView() {
        super.setupView(title: "settings".localize())
        
        showHiddenButton = NSButton(checkboxWithTitle: "showHidden".localize(), target: self, action: #selector(toggleHidden))
        showHiddenButton.state = AppData.shared.context(side).showHidden ? .on : .off
        contentView.addSubviewBelow(showHiddenButton)
        
        showExifDataButton = NSButton(checkboxWithTitle: "showExifData".localize(), target: self, action: #selector(toggleExifData))
        showExifDataButton.state = AppData.shared.context(side).showExifData ? .on : .off
        contentView.addSubviewBelow(showExifDataButton, upperView: showHiddenButton)
        
        confirmDeleteButton = NSButton(checkboxWithTitle: "confirmDelete".localize(), target: self, action: #selector(toggleConfirmDelete))
        confirmDeleteButton.state = AppData.shared.context(side).confirmDelete ? .on : .off
        contentView.addSubviewBelow(confirmDeleteButton, upperView: showExifDataButton)
        
            .connectToBottom(of: contentView)
    }
    
    @objc func toggleHidden(){
        AppData.shared.context(side).showHidden = showHiddenButton.state == .on
        AppData.shared.save()
        delegate?.showHiddenChanged()
    }
    
    @objc func toggleExifData(){
        AppData.shared.context(side).showExifData = showExifDataButton.state == .on
        AppData.shared.save()
        delegate?.showExifDataChanged()
    }
    
    @objc func toggleConfirmDelete(){
        AppData.shared.context(side).confirmDelete = confirmDeleteButton.state == .on
        AppData.shared.save()
    }
    
}
