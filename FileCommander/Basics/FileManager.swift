/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import AppKit

extension FileManager {
    
    private static let tempDir = NSTemporaryDirectory()
    
    static var privateURL : URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static var rootURL : URL = URL(fileURLWithPath: "/")
    static var homeURL : URL = FileManager.default.homeDirectoryForCurrentUser
    static var preferencesURL : URL = privateURL.appendingPathComponent("preferences.json")
    static var appDataURL : URL = privateURL.appendingPathComponent("appdata.json")
    
    func fileExists(url: URL?) -> Bool{
        if let url = url{
            return FileManager.default.fileExists(atPath: url.path)
        }
        return false
    }
    
    func isDirectory(url: URL) -> Bool{
        var isDir:ObjCBool = true
        return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) && isDir.boolValue
    }
    
    func isEmptyDirectory(url: URL) -> Bool{
        do{
            let contents = try FileManager.default.contentsOfDirectory(atPath: url.path)
            return contents.isEmpty
        }
        catch{
            return true
        }
    }
    
    func fileAttributes(url: URL) -> [FileAttributeKey : Any]{
        do{
            return try FileManager.default.attributesOfItem(atPath: url.path)
        }
        catch{
            return [FileAttributeKey : Any]()
        }
    }

    
    func readFile(url: URL) -> Data?{
        if let fileData = FileManager.default.contents(atPath: url.path){
            return fileData
        }
        return nil
    }
    
    func readTextFile(url: URL) -> String?{
        do{
            let string = try String(contentsOf: url, encoding: .utf8)
            return string
        }
        catch{
            return nil
        }
    }
    
    func assertDirectoryFor(url: URL){
        let dirUrl = url.deletingLastPathComponent()
        assertDirectory(url: dirUrl)
    }
    
    func assertDirectory(url: URL){
        var isDir:ObjCBool = true
        if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) {
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }
            catch let err{
                Log.error("FileController could not create directory", error: err)
                return
            }
        }
    }
    
    @discardableResult
    func removeDirectory(url: URL) -> Bool{
        do{
            try FileManager.default.removeItem(at: url)
            return true
        }
        catch {
            return false
        }
    }
    
    @discardableResult
    func saveFile(data: Data, url: URL) -> Bool{
        do{
            try data.write(to: url, options: .atomic)
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    func saveFile(text: String, url: URL) -> Bool{
        do{
            try text.write(to: url, atomically: true, encoding: .utf8)
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    func copyFile(name: String,fromDir: URL, toDir: URL, replace: Bool = false) -> Bool{
        do{
            if replace && fileExists(url: toDir.appendingPathComponent(name)){
                _ = deleteFile(url: toDir.appendingPathComponent(name))
            }
            try FileManager.default.copyItem(at: fromDir.appendingPathComponent(name), to: toDir.appendingPathComponent(name))
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    func moveFile(name: String,fromDir: URL, toDir: URL, replace: Bool = false) -> Bool{
        do{
            if replace && fileExists(url: toDir.appendingPathComponent(name)){
                _ = deleteFile(url: toDir.appendingPathComponent(name))
            }
            try FileManager.default.moveItem(at: fromDir.appendingPathComponent(name), to: toDir.appendingPathComponent(name))
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    func renameFile(url: URL, newName: String) -> URL?{
        do{
            let destinationPath = url.deletingLastPathComponent().appendingPathComponent(newName)
            return try FileManager.default.replaceItemAt(destinationPath, withItemAt: url)
        } catch let err{
            Log.error("FileController", error: err)
            return nil
        }
    }
    
    @discardableResult
    func copyFile(fromURL: URL, toURL: URL, replace: Bool = false) -> Bool{
        do{
            if replace && fileExists(url: toURL){
                _ = deleteFile(url: toURL)
            }
            try FileManager.default.copyItem(at: fromURL, to: toURL)
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    func deleteFile(dirURL: URL, fileName: String) -> Bool{
        do{
            try FileManager.default.removeItem(at: dirURL.appendingPathComponent(fileName))
            return true
        }
        catch {
            return false
        }
    }
    
    @discardableResult
    func deleteFile(url: URL) -> Bool{
        do{
            try FileManager.default.removeItem(at: url)
            print("deleted file \(url.lastPathComponent)")
            return true
        }
        catch {
            return false
        }
    }
    
    func listAllFiles(dirPath: String) -> Array<String>{
        do{
            return try FileManager.default.contentsOfDirectory(atPath: dirPath)
        }
        catch{
            return Array<String>()
        }
    }
    
    func listAllURLs(dirURL: URL) -> Array<URL>{
        let names = listAllFiles(dirPath: dirURL.path)
        var urls = Array<URL>()
        for name in names{
            urls.append(dirURL.appendingPathComponent(name))
        }
        return urls
    }
    
    func deleteAllFiles(dirURL: URL){
        let names = listAllFiles(dirPath: dirURL.path)
        var count = 0
        for name in names{
            if deleteFile(dirURL: dirURL, fileName: name){
                count += 1
            }
        }
        if count > 0{
            Log.info("\(count) files deleted")
        }
    }
    
}
