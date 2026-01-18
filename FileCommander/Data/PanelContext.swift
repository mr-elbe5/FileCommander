/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

enum PanelSide: Int, Codable {
    case left = 0
    case right = 1
    
    var other: PanelSide {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}

class PanelContext: Codable{
    
    enum CodingKeys: String, CodingKey {
        case side
        case currentURL
        case showHidden
        case confirmDelete
        case compareBySize
        case compareByCreation
        case compareFilesOnly
    }
    
    var side: PanelSide
    var currentDirectory: DirectoryData
    var showHidden: Bool = false
    var confirmDelete: Bool = true
    var sortType: SortType = .initial
    var ascending: Bool = true
    var compareBySize: Bool = false
    var compareByCreation: Bool = false
    var compareFilesOnly: Bool = true
    
    init(side: PanelSide){
        self.side = side
        currentDirectory = DirectoryData(url: FileManager.homeURL, side: side)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let i = try values.decodeIfPresent(Int.self, forKey: .side) ?? PanelSide.left.rawValue
        side = PanelSide(rawValue: i) ?? .left
        let url = try values.decodeIfPresent(URL.self, forKey: .currentURL) ?? FileManager.homeURL
        currentDirectory = DirectoryData(url: url, side: side)
        showHidden = try values.decodeIfPresent(Bool.self, forKey: .showHidden) ?? false
        confirmDelete = try values.decodeIfPresent(Bool.self, forKey: .confirmDelete) ?? true
        compareBySize = try values.decodeIfPresent(Bool.self, forKey: .compareBySize) ?? false
        compareByCreation = try values.decodeIfPresent(Bool.self, forKey: .compareByCreation) ?? false
        compareFilesOnly = try values.decodeIfPresent(Bool.self, forKey: .compareFilesOnly) ?? true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(side.rawValue, forKey: .side)
        try container.encode(currentDirectory.url, forKey: .currentURL)
        try container.encode(showHidden, forKey: .showHidden)
        try container.encode(confirmDelete, forKey: .confirmDelete)
        try container.encode(compareBySize, forKey: .compareBySize)
        try container.encode(compareByCreation, forKey: .compareByCreation)
        try container.encode(compareFilesOnly, forKey: .compareFilesOnly)
    }
    
    func setCurrentDirectory(url: URL) -> DirectoryData{
        currentDirectory = DirectoryData(url: url, side: side)
        currentDirectory.scan()
        return currentDirectory
    }
     
}



