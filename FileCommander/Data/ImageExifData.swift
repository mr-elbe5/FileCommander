/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

class ImageExifData{
    
    static var exifDateFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .none
            dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
            return dateFormatter
        }
    }
    
    static func getExifData(from url: URL) -> ImageExifData?{
        let exifData = ImageExifData()
        if exifData.load(url: url){
            return exifData
        }
        return nil
    }
    
    var exifLensModel = ""
    var exifWidth : Int = 0
    var exifHeight : Int = 0
    var exifLatitude: Double = 0.0
    var exifLongitude: Double = 0.0
    var exifAltitude: Double = 0.0
    var exifCreationDate : Date? = nil
    
    var hasGPSData: Bool{
        return exifLatitude != 0.0 || exifLongitude != 0.0
    }
    
    func load(url: URL) -> Bool{
        if let data = FileManager.default.readFile(url: url){
            if let dict = data.getExifData(){
                if let exif = dict["{Exif}"] as? NSDictionary{
                    exifLensModel = exif["LensModel"] as? String ?? ""
                    exifWidth = exif["PixelXDimension"] as? Int ?? 0
                    exifHeight = exif["PixelYDimension"] as? Int ?? 0
                    if let dateString = exif["DateTimeOriginal"] as? String{
                        exifCreationDate = ImageExifData.exifDateFormatter.date(from: dateString)
                    }
                }
                if let gps = dict["{GPS}"] as? NSDictionary{
                    exifLongitude = gps["Longitude"] as? Double ?? 0.0
                    exifLatitude = gps["Latitude"] as? Double ?? 0.0
                    exifAltitude = floor(gps["Altitude"] as? Double ?? 0.0)
                }
                return true
            }
        }
        return false
    }
    
}


