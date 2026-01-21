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

class ImageData: FileData{
    
    var exifData: ImageExifData? = nil
    
    var hasExifData: Bool{
        exifData != nil
    }
    
    var exifCreationDateString: String{
        exifData?.exifCreationDate?.dateOrTimeString() ?? ""
    }
    
    var hasGPSData: Bool{
        exifData?.hasGPSData ?? false
    }
    
    override init(url: URL, side: PanelSide){
        super.init(url: url, side: side)
    }
    
    func assertExifData() -> Bool{
        if !isImage{
            return false
        }
        if self.exifData == nil, let exifData = ImageExifData.getExifData(from: url){
            self.exifData = exifData
        }
        return exifData != nil
    }
    
    func setCreationDateToExifDate() -> Bool{
        if let creationDate = exifData?.exifCreationDate{
            fileCreationDate = creationDate
            url.creation = fileCreationDate
            return true
        }
        return false
    }
    
    func setExifToCreationDate() -> Bool{
        if assertExifData(), let exifData = exifData{
            exifData.exifCreationDate = fileCreationDate
            return saveModifiedFile()
        }
        return false
    }
    
    func saveModifiedFile() -> Bool{
        var success = false
        if let exifData = exifData, let oldData = FileManager.default.readFile(url: url){
            let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
            if let imageSource = CGImageSourceCreateWithData(oldData as CFData, options as CFDictionary) {
                let uti: CFString = CGImageSourceGetType(imageSource)!
                let newData: NSMutableData = NSMutableData(data: oldData)
                let destination: CGImageDestination = CGImageDestinationCreateWithData((newData as CFMutableData), uti, 1, nil)!
                if let oldMetaData: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary){
                    let newMetaData: NSMutableDictionary = oldMetaData.mutableCopy() as! NSMutableDictionary
                    exifData.modifyExif(dict: newMetaData)
                    CGImageDestinationAddImageFromSource(destination, imageSource, 0, (newMetaData as CFDictionary))
                    CGImageDestinationFinalize(destination)
                    success = FileManager.default.saveFile(data: newData as Data, url: url)
                }
            }
        }
        return success
    }
    
}

