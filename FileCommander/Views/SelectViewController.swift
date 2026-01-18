/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class SelectViewController: PanelMenuViewController {
    
    var contentView: SelectView{
        view as! SelectView
    }
    
    override func loadView() {
        view = SelectView(controller: self)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 0))
        contentView.setupView()
    }
    
}

protocol SelectViewDelegate{
    func selectAllFiles()
    func deselectAllFiles()
    func selectMatchingItems()
    func selectNotMatchingItems()
}

class SelectView: PanelMenuView{
    
    var compareBySizeButton: NSButton!
    var compareByCreationButton: NSButton!
    var compareFilesOnlyButton: NSButton!
    
    var delegate: SelectViewDelegate? = nil
    
    func setupView() {
        super.setupView(title: "selection".localize())
        
        let selectAllButton = NSButton(title: "\("selectAll".localize()) [F2]".localize(), target: self, action: #selector(selectAllFiles))
        contentView.addSubviewBelow(selectAllButton)
        
        let deselectAllButton = NSButton(title: "\("deselectAll".localize()) [F3]", target: self, action: #selector(deselectAllFiles))
        contentView.addSubviewBelow(deselectAllButton, upperView: selectAllButton)
        
        let toggleSelectedButton = NSButton(title: "\("toggleSelected".localize()) [F4]", target: self, action: #selector(deselectAllFiles))
        contentView.addSubviewBelow(toggleSelectedButton, upperView: deselectAllButton)
        
        compareBySizeButton = NSButton(checkboxWithTitle: "compareBySize".localize(), target: self, action: #selector(toggleCompareBySize))
        compareBySizeButton.state = AppData.shared.context(side).compareBySize ? .on : .off
        contentView.addSubviewBelow(compareBySizeButton, upperView: toggleSelectedButton)
        
        compareByCreationButton = NSButton(checkboxWithTitle: "compareByCreation".localize(), target: self, action: #selector(toggleCompareByCreation))
        compareByCreationButton.state = AppData.shared.context(side).compareByCreation ? .on : .off
        contentView.addSubviewBelow(compareByCreationButton, upperView: compareBySizeButton)
        
        compareFilesOnlyButton = NSButton(checkboxWithTitle: "compareFilesOnly".localize(), target: self, action: #selector(toggleCompareFilesOnly))
        compareFilesOnlyButton.state = AppData.shared.context(side).compareFilesOnly ? .on : .off
        contentView.addSubviewBelow(compareFilesOnlyButton, upperView: compareByCreationButton)
        
        let selectMatchingButton = NSButton(title: "selectMatchingItems".localize(), target: self, action: #selector(selectMatching))
        contentView.addSubviewBelow(selectMatchingButton, upperView: compareFilesOnlyButton)
        
        let selectNotMatchingButton = NSButton(title: "\("selectNotMatchingItems".localize())", target: self, action: #selector(selectNotMatching))
        contentView.addSubviewBelow(selectNotMatchingButton, upperView: selectMatchingButton)
        
            .connectToBottom(of: contentView)
    }
    
    @objc func selectAllFiles(){
        delegate?.selectAllFiles()
        close()
    }
    
    @objc func deselectAllFiles(){
        delegate?.deselectAllFiles()
        close()
    }
    
    @objc func toggleCompareFilesOnly(){
        AppData.shared.context(side).compareFilesOnly = compareFilesOnlyButton.state == .on
        AppData.shared.save()
    }
    
    @objc func toggleCompareBySize(){
        AppData.shared.context(side).compareBySize = compareBySizeButton.state == .on
        AppData.shared.save()
    }
    
    @objc func toggleCompareByCreation(){
        AppData.shared.context(side).compareByCreation = compareByCreationButton.state == .on
        AppData.shared.save()
    }
    
    @objc func selectMatching(){
        delegate?.selectMatchingItems()
        close()
    }
    
    @objc func selectNotMatching(){
        delegate?.selectNotMatchingItems()
        close()
    }
    
}
