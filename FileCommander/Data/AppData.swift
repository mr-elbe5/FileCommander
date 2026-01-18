/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

class AppData: Codable{
    
    static var shared = AppData()
    
    static func load(){
        if let storedString = FileManager.default.readTextFile(url: FileManager.appDataURL) {
            if let data : AppData = AppData.fromJSON(encoded: storedString){
                AppData.shared = data
            }
        }
        else{
            print("no saved data available for directories")
            AppData.shared = AppData()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case contexts
    }
    
    private let contexts: Dictionary<PanelSide,PanelContext>
    
    init(){
        contexts = [.left: PanelContext(side: .left), .right: PanelContext(side: .right)]
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contexts = try values.decodeIfPresent(Dictionary<PanelSide,PanelContext>.self, forKey: .contexts) ?? [.left: PanelContext(side: .left), .right: PanelContext(side: .right)]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(contexts, forKey: .contexts)
    }
    
    func context(_ side: PanelSide) -> PanelContext{
        switch side {
        case .left:
            return contexts[.left]!
        case .right:
            return contexts[.right]!
        }
    }
    
    func setCurrentDirectory(url: URL, side: PanelSide) -> DirectoryData?{
        let directory = context(side).setCurrentDirectory(url: url)
        save()
        return directory
    }
    
    func save(){
        let storeString = toJSON()
        FileManager.default.saveFile(text: storeString, url: FileManager.appDataURL)
        print("app data saved")
    }
    
}



