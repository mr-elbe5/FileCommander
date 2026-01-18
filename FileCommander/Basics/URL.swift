/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import UniformTypeIdentifiers

extension URL{
    
    enum ImageType: String{
        case compressed
        case psd
        case raw
        case affinityPhoto
        case affinityDesigner
    }
    
    var parentURL: URL? {
        if self == FileManager.rootURL{
            return nil
        }
        return self.deletingLastPathComponent()
    }
    
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    var isAlias: Bool {
        (try? resourceValues(forKeys: [.isAliasFileKey]))?.isAliasFile == true
    }
    
    var utType: UTType?{
        UTType(filenameExtension: self.pathExtension)
    }

    var imageType: ImageType?{
        if let utType = utType{
            if utType.isSubtype(of: .rawImage){
                return .raw
            }
            if utType.isSubtype(of: .image){
                if utType.identifier == "com.adobe.photoshop-image"{
                    return .psd
                }
                return .compressed
            }
            if utType.isSubtype(of: .data) && utType.identifier.starts(with: "com.seriflabs.affinity"){
                return .affinityPhoto
            }
            if utType.isSubtype(of: .data) && utType.identifier == "com.seriflabs.affinitydesigner.document"{
                return .affinityDesigner
            }
        }
        return nil
    }
    
}
