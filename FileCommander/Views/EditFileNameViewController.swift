/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class EditFileNameViewController: ViewController, ModalResponder{
    
    var responseCode: NSApplication.ModalResponse{
        get{
            contentView.responseCode
        }
        set{
            contentView.responseCode = newValue
        }
    }
    
    var fileName: String{
        get{
            contentView.textField.stringValue
        }
        set{
            contentView.textField.stringValue = newValue
        }
    }
    
    var contentView = EditFileNameView()
    
    override func loadView() {
        super.loadView()
        view.addSubviewFilling(contentView)
        contentView.setup()
    }
    
}

class EditFileNameView: NSView{
    
    var textField = NSTextField(string: "")
    var responseCode: NSApplication.ModalResponse = .cancel
    
    func setup() {
        addSubviewBelow(textField)
        
        let okButton = NSButton(title: "ok".localize(), target: self, action: #selector(save))
        addSubviewWithAnchors(okButton, top: textField.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor)
        
        let cancelButton = NSButton(title: "cancel".localize(), target: self, action: #selector(cancel))
        addSubviewWithAnchors(cancelButton, top: textField.bottomAnchor, trailing: trailingAnchor)
            .centerY(okButton.centerYAnchor)
    }
    
    @objc func save(){
        responseCode = .OK
        self.window?.close()
    }
    
    @objc func cancel(){
        responseCode = .cancel
        self.window?.close()
    }
    
}


