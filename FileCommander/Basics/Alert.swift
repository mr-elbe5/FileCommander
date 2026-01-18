/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

extension NSAlert{

    // returns true if ok was pressed
    static func acceptWarning(message: String) -> Bool{
        let alert = NSAlert()
        alert.icon = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
        alert.alertStyle = .warning
        alert.messageText = message
        alert.addButton(withTitle: "ok".localize())
        alert.addButton(withTitle: "cancel".localize())
        let result = alert.runModal()
        return result == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    
    static func acceptInfo(message: String){
        let alert = NSAlert()
        alert.icon = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
        alert.alertStyle = .informational
        alert.messageText = message
        alert.addButton(withTitle: "ok".localize())
        alert.runModal()
    }
    
    static func showError(message: String){
        let alert = NSAlert()
        alert.icon = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
        alert.alertStyle = .critical
        alert.messageText = message
        alert.addButton(withTitle: "ok".localize())
        alert.runModal()
    }

}
