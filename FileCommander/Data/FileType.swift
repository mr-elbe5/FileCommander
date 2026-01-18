/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit
import UniformTypeIdentifiers

enum FileType: String {
    case directory
    case file
    case text
    case spreadsheet
    case database
    case image
    case video
    case audio
    case rtf
    case archive
    
    static var typeIcons: Dictionary<FileType, NSImage> = [
        .directory: NSImage(systemSymbolName: "folder", accessibilityDescription: "Folder")!,
        .file: NSImage(systemSymbolName: "rectangle.portrait", accessibilityDescription: "File")!,
        .text: NSImage(systemSymbolName: "text.document", accessibilityDescription: "Text Document")!,
        .spreadsheet: NSImage(systemSymbolName: "tablecells", accessibilityDescription: "Spradsheet")!,
        .database: NSImage(systemSymbolName: "tray", accessibilityDescription: "Database")!,
        .image: NSImage(systemSymbolName: "photo", accessibilityDescription: "Image")!,
        .video: NSImage(systemSymbolName: "video", accessibilityDescription: "Video")!,
        .audio: NSImage(systemSymbolName: "microphone", accessibilityDescription: "Audio")!,
        .rtf: NSImage(systemSymbolName: "richtext.page", accessibilityDescription: "Richtext/PDF")!,
        .archive: NSImage(systemSymbolName: "zipper.page", accessibilityDescription: "Archive")!,
    ]
    
    static func fromPathExtension(_ ext: String) -> FileType?{
        Log.info(ext)
        switch ext.lowercased(){
        case "pdf", "rtf": return .rtf
        case "doc", "docx", "odt", "txt": return .text
        case "xls", "xlsx", "ods": return .spreadsheet
        case "sql", "odb": return .database
        case "jpg", "jpeg", "png", "gif", "dng": return .image
        case "mp4", "mov", "avi": return .video
        case "mp3", "wav", "aac": return .audio
        case "zip", "tar", "tgz": return .archive
        default: return .file
        }
    }
    
    var image: NSImage{
        FileType.typeIcons[self]!
    }
    
    
}
