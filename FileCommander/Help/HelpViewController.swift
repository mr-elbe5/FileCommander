/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class HelpViewController: PopoverViewController {
    
    var contentView: HelpView{
        view as! HelpView
    }
    
    override func loadView() {
        view = HelpView(controller: self)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 400, height: 0))
        contentView.setupView(height: 300)
    }
    
}

class HelpView: PopoverView{
    
    func setupView(height: CGFloat) {
        super.setupScrollView(title: "help".localize(), height: height)
        var header = NSTextField(labelWithString: "helpOpenFolder".localize()).asHeadline()
        contentView.addSubviewBelow(header)
        var text = NSTextField(wrappingLabelWithString: "helpOpenFolderText".localize())
        contentView.addSubviewBelow(text, upperView: header)
        header = NSTextField(labelWithString: "helpSelection".localize()).asHeadline()
        contentView.addSubviewBelow(header, upperView: text)
        text = NSTextField(wrappingLabelWithString: "helpSelectionText".localize())
        contentView.addSubviewBelow(text, upperView: header)
            .connectToBottom(of: contentView)
    }
    
}
