/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit
import UniformTypeIdentifiers

class FileData: NSObject{
    
    static func == (lhs: FileData, rhs: FileData) -> Bool {
        lhs.url == rhs.url
    }
    
    var url: URL
    var side: PanelSide
    var fileName: String
    var size = 0
    var isHidden = false
    var fileCreationDate: Date? = nil
    var fileModificationDate: Date? = nil
    var fileType: FileType? = nil
    var isDirectory: Bool = false
    var exifData: ImageExifData? = nil
    
    var isSelected = false
    
    var context: PanelContext{
        AppData.shared.context(side)
    }
    
    var path: String{
        url.path
    }
    
    var pathExtension: String{
        url.pathExtension.lowercased()
    }
    
    var parentURL: URL?{
        url.parentURL
    }
    
    var hasExifData: Bool{
        exifData != nil
    }
    
    var dataString: String{
        switch fileType{
        case .image:
            if let exifData = exifData{
                if exifData.hasGPSData{
                    return "EXIF+GPS"
                }
                return "EXIF"
            }
        default:
            return ""
        }
        return ""
    }
    
    var sizeString: String{
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
    
    var creationDateString: String{
        fileCreationDate?.dateOrTimeString() ?? ""
    }
    
    var mofificationDateString: String{
        fileModificationDate?.dateOrTimeString() ?? ""
    }
    
    init(url: URL, side: PanelSide){
        self.url = url
        self.side = side
        self.fileName = url.lastPathComponent
        super.init()
    }
    
    func evaluateData(){
        switch fileType {
        case .image:
            if self.exifData == nil, let exifData = ImageExifData.getExifData(from: url){
                self.exifData = exifData
            }
        default:
            break
        }
    }
    
}

extension FileData: Comparable{
    
    static func < (lhs: FileData, rhs: FileData) -> Bool {
        var result: Bool = false
        switch lhs.context.sortType{
        case .initial:
            if lhs.isDirectory, !rhs.isDirectory{
                result = true
            }
            else if !lhs.isDirectory, rhs.isDirectory{
                result = false
            }
            else if lhs.pathExtension == rhs.pathExtension{
                result = lhs.fileName.lowercased() < rhs.fileName.lowercased()
            }
            else{
                result = lhs.pathExtension < rhs.pathExtension
            }
        case .byType:
            if lhs.isDirectory, !rhs.isDirectory{
                result = true
            }
            else if !lhs.isDirectory, rhs.isDirectory{
                result = false
            }
            else{
                result = lhs.pathExtension < rhs.pathExtension
            }
        case .byName:
            result = lhs.fileName.lowercased() < rhs.fileName.lowercased()
        case .bySize:
            result = lhs.size < rhs.size
        case .byFileCreation:
            if let dateLeft = lhs.fileCreationDate{
                if let dateRight = rhs.fileCreationDate{
                    result = dateLeft < dateRight
                }
                else{
                    result = false
                }
            }
            else{
                result = true
            }
        case .byFileModification:
            if let dateLeft = lhs.fileModificationDate{
                if let dateRight = rhs.fileModificationDate{
                    result = dateLeft < dateRight
                }
                else{
                    result = false
                }
            }
            else{
                result = true
            }
        }
        return lhs.context.ascending ? result : !result
    }
    
}

