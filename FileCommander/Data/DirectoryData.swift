/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class DirectoryData: FileData {
    
    var parentDirectory: DirectoryData? = nil
    var files = [FileData]()
    
    var isParentDirectory: Bool{
        parentDirectory == nil
    }
    
    override var sizeString: String{
        if size == 0{
            return ""
        }
        return super.sizeString
    }
    
    var fileCount: Int{
        return files.count + parentCount
    }
    
    var parentCount: Int{
        return parentDirectory == nil ? 0 : 1
    }
    
    var selectedIndexes: IndexSet{
        let pc = parentCount
        var set = IndexSet()
        for i in 0..<files.count{
            if files[i].isSelected{
                set.insert(i + pc)
            }
        }
        return set
    }
    
    var selectedFiles: [FileData]{
        var arr = [FileData]()
        for file in files{
            if file.isSelected{
                arr.append(file)
            }
        }
        return arr
    }
    
    func scan(){
        parentDirectory = nil
        files.removeAll()
        if let parentURL = parentURL{
            parentDirectory = DirectoryData(url: parentURL, side: side)
            parentDirectory!.fileType = .directory
            parentDirectory!.fileName = ".."
        }
        var childURLs = Array<URL>()
        do{
            var options : FileManager.DirectoryEnumerationOptions = []
            if !context.showHidden{
                options = .skipsHiddenFiles
            }
            childURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey, .isAliasFileKey], options: options)
        }
        catch{
            return
        }
        for childURL in childURLs{
            if childURL.isAlias{
                //Log.info("skipping alias file \(subURL.lastPathComponent)")
                continue
            }
            else{
                do{
                    var file: FileData
                    let resourceValues = try childURL.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey, .fileSizeKey, .isHiddenKey, .isDirectoryKey])
                    if resourceValues.isDirectory ?? false{
                        file = DirectoryData(url: childURL, side: side)
                        file.fileType = .directory
                        //print("found directory \(file.url.lastPathComponent)")
                    }
                    else{
                        let fileType = FileType.fromPathExtension(childURL.pathExtension)
                        if fileType == .image{
                            file = ImageData(url: childURL, side: side)
                        }
                        else{
                            file = FileData(url: childURL, side: side)
                        }
                        file.fileType = fileType
                        //print("found file \(file.url.lastPathComponent)")
                    }
                    file.size = resourceValues.fileSize ?? 0
                    file.isHidden = resourceValues.isHidden ?? false
                    file.fileCreationDate = resourceValues.creationDate
                    file.fileModificationDate = resourceValues.contentModificationDate
                    files.append(file)
                }
                catch (let err){
                    Log.warn(err.localizedDescription)
                }
            }
        }
        context.sortType = .initial
        context.ascending = true
        files.sort()
        Log.info("directory \(self.fileName) has \(files.count) files and directories")
    }
    
    func calculateSize(){
        self.size = getSize(url)
    }
    
    func getSize(_ url: URL) -> Int{
        var size = 0
        var childURLs = Array<URL>()
        do{
            //Log.info("calculating size of \(url.path)")
            childURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [])
            for childURL in childURLs {
                if let resourceValues = try? childURL.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey,.fileSizeKey, .isDirectoryKey]){
                    size += resourceValues.fileSize ?? 0
                    if resourceValues.isDirectory ?? false{
                        size += getSize(childURL)
                    }
                }
            }
        }
        catch let(err){
            Log.error(error: err)
        }
        return size
    }
    
    func selectSet(_ set: IndexSet){
        let pc = parentCount
        for i in 0..<files.count{
            files[i].isSelected = set.contains(i + pc)
        }
    }
    
    func selectAll(){
        for file in files{
            file.isSelected = true
        }
    }
    
    func deselectAll(){
        for file in files{
            file.isSelected = false
        }
    }
    
    func toggleSelected(){
        for file in files{
            file.isSelected = !file.isSelected
        }
    }
    
    func sort(_ sortType: SortType, ascending: Bool){
        context.sortType = sortType
        context.ascending = ascending
        files.sort()
    }
    
}
