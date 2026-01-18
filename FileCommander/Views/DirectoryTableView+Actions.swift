/*
 File Commander
 Copyright (C) 2025 Michael Roennau
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import AppKit

extension DirectoryTableView {
    
    @objc func doubleClicked() {
        let col = clickedColumn
        let row = clickedRow
        if col < 0 || row < 0{
            return
        }
        //Log.info("double clicked \(col):\(row)")
        if col <= 1, let file = fileForRow(row){
            if file.isDirectory{
                //Log.info("change to \(file.fileName)")
                if let directory = AppData.shared.setCurrentDirectory(url: file.url, side: side){
                    self.directory = directory
                    reloadData()
                    actionDelegate?.directoryChanged()
                }
            }
            else{
                openFile(file)
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.isARepeat {return}
        if let key = event.specialKey{
            switch key{
            case .f2:
                selectAll(nil)
                return
            case .f3:
                deselectAll(nil)
                return
            case .f4:
                toggleSelected()
                return
            case .f5:
                copySelectedToOtherSide()
                return
            case .f6:
                moveSelectedToOtherSide()
                return
            case .f7:
                openCreateDirectory()
                return
            case .f8:
                deleteSelected()
                return
            default:
                break
            }
        }
        super.keyDown(with: event)
    }
    
    override func rightMouseDown(with: NSEvent) {
        actionDelegate?.activated()
        let pnt = convert(with.locationInWindow, from: nil)
        let row = row(at: pnt)
        let column = column(at: pnt)
        if row > 0{
            let set = IndexSet(integer: row)
            selectRowIndexes(set, byExtendingSelection: false)
            directory?.selectSet(set)
            switch column{
            case 0, 1:
                if let cell = view(atColumn: column, row: row, makeIfNecessary: false), let file = fileForRow(row){
                    let menu = FileMenu(file: file)
                    menu.addItem(NSMenuItem(title: "open".localize(), action: #selector(openFileAtMenu), keyEquivalent: "o"))
                    menu.addItem(NSMenuItem(title: "copy".localize(), action: #selector(copySelectedToOtherSide), keyEquivalent: "c"))
                    menu.addItem(NSMenuItem(title: "move".localize(), action: #selector(moveSelectedToOtherSide), keyEquivalent: "m"))
                    menu.addItem(NSMenuItem(title: "rename".localize(), action: #selector(openRename), keyEquivalent: "r"))
                    menu.addItem(NSMenuItem(title: "delete".localize(), action: #selector(deleteSelected), keyEquivalent: "d"))
                    NSMenu.popUpContextMenu(menu, with: with, for: cell)
                }
            case 2:
                if let cell = view(atColumn: column, row: row, makeIfNecessary: false), let file = fileForRow(row), file.hasExifData{
                    let controller = ExifDataViewController(file)
                    controller.file = file
                    controller.popover.show(relativeTo: cell.bounds, of: cell, preferredEdge: .maxY)
                }
            case 4:
                if let cell = view(atColumn: column, row: row, makeIfNecessary: false), let file = fileForRow(row){
                    let menu = FileMenu(file: file)
                    menu.addItem(NSMenuItem(title: "editCreationDate".localize(), action: #selector(editCreationDate), keyEquivalent: "d"))
                    if file.hasExifData{
                        menu.addItem(NSMenuItem(title: "setToExifDate".localize(), action: #selector(setToExifDate), keyEquivalent: "e"))
                    }
                    NSMenu.popUpContextMenu(menu, with: with, for: cell)
                }
            default:
                break
            }
        }
    }
    
    @objc func openFileAtMenu(_ sender: Any){
        if let menuItem = sender as? NSMenuItem, let menu = menuItem.menu as? FileMenu{
            openFile(menu.file)
        }
    }
    
    @objc func editCreationDate(_ sender: Any){
        if let menuItem = sender as? NSMenuItem, let menu = menuItem.menu as? FileMenu{
            Log.info("editCreationDate: \(menu.file.fileName)")
        }
    }
    
    @objc func setToExifDate(_ sender: Any){
        if let menuItem = sender as? NSMenuItem, let menu = menuItem.menu as? FileMenu{
            Log.info("setToExifDate: \(menu.file.fileName)")
        }
    }
    
    @objc func openCreateDirectory(){
        if let directory = directory{
            let controller = EditFileNameViewController()
            controller.fileName = ""
            if ModalWindow.run(title: "createFolder".localize(), viewController: controller, outerWindow: MainWindowController.instance.window!, minSize: CGSize(width: 300, height: 100)) == .OK{
                let fileName = controller.fileName
                if !fileName.isEmpty{
                    Log.info("new directory is \(fileName)")
                    let url = directory.url.appendingPathComponent(fileName)
                    do{
                        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
                    }
                    catch{
                        NSAlert.showError(message: "createFolderError".localize())
                    }
                    directory.scan()
                    directoryFilesChanged()
                }
            }
        }
    }
    
    @objc func openRename(){
        if let directory = directory, let file = directory.selectedFiles.first{
            let controller = EditFileNameViewController()
            controller.fileName = file.fileName
            if ModalWindow.run(title: "rename".localize(), viewController: controller, outerWindow: MainWindowController.instance.window!, minSize: CGSize(width: 300, height: 100)) == .OK{
                let fileName = controller.fileName
                if !fileName.isEmpty{
                    Log.info("new name is \(fileName)")
                    if let url = FileManager.default.renameFile(url: file.url, newName: fileName){
                        file.url = url
                        Log.info("renamed")
                        directory.scan()
                        directoryFilesChanged()
                    }
                }
            }
        }
    }
    
    @objc func toggleSelected(){
        directory?.toggleSelected()
        directoryFilesChanged()
    }
    
    @objc func copySelectedToOtherSide(){
        if isOtherDirectoryTheSame{
            return
        }
        //Log.info("copyToOtherSide")
        if let files = directory?.selectedFiles, !files.isEmpty, let otherDirectory = otherDirectory{
            for file in files{
                if FileManager.default.copyFile(name: file.fileName,fromDir: directory!.url, toDir: otherDirectory.url, replace: true){
                    //Log.info("copied")
                }
            }
            otherDirectory.scan()
            otherDirectory.files.sort()
            self.otherTableView?.directoryFilesChanged()
        }
    }
    
    @objc func moveSelectedToOtherSide(){
        if isOtherDirectoryTheSame{
            return
        }
        //Log.info("moveToOtherSide")
        if let directory = directory, let otherDirectory = otherDirectory{
            let files = directory.selectedFiles
            if files.isEmpty{
                return
            }
            for file in files{
                if FileManager.default.moveFile(name: file.fileName,fromDir: directory.url, toDir: otherDirectory.url, replace: true){
                    //Log.info("moved")
                }
            }
            otherDirectory.scan()
            otherDirectory.files.sort()
            self.otherTableView?.directoryFilesChanged()
            directory.scan()
            directory.files.sort()
            self.directoryFilesChanged()
        }
    }
    
    @objc func deleteSelected(){
        //Log.info("delete")
        if let directory = directory{
            let files = directory.selectedFiles
            if files.isEmpty{
                return
            }
            if context.confirmDelete{
                if NSAlert.acceptWarning(message: "confirmDelete".localize()){
                    deleteSelectedFiles(files: files)
                }
            }
            else{
                deleteSelectedFiles(files: files)
            }
            
        }
    }
    
    private func deleteSelectedFiles(files: [FileData]){
        if let directory = directory{
            for file in files{
                if FileManager.default.deleteFile(url: file.url){
                    //Log.info("deleted")
                }
            }
            directory.scan()
            directory.files.sort()
            self.directoryFilesChanged()
        }
    }
    
    func selectMatchingItems() {
        if isOtherDirectoryTheSame{
            return
        }
        if let directory = directory, let otherDirectory = otherDirectory{
            directory.deselectAll()
            for i in 0..<directory.files.count{
                let file = directory.files[i]
                if context.compareFilesOnly{
                    if file.isDirectory{
                        file.isSelected = false
                        continue
                    }
                }
                for j in 0..<otherDirectory.files.count{
                    if filesMatch(file1: file, file2: otherDirectory.files[j]){
                        directory.files[i].isSelected = true
                    }
                }
            }
            directoryFilesChanged()
        }
    }
    
    func selectNotMatchingItems() {
        if isOtherDirectoryTheSame{
            return
        }
        if let directory = directory, let otherDirectory = otherDirectory{
            directory.selectAll()
            otherDirectory.deselectAll()
            for i in 0..<directory.files.count{
                let file = directory.files[i]
                if context.compareFilesOnly{
                    if file.isDirectory{
                        file.isSelected = false
                        continue
                    }
                }
                for j in 0..<otherDirectory.files.count{
                    if filesMatch(file1: file, file2: otherDirectory.files[j]){
                        directory.files[i].isSelected = false
                    }
                }
            }
            directoryFilesChanged()
        }
    }
    
    private func filesMatch(file1: FileData, file2: FileData) -> Bool{
        if file1.fileName != file2.fileName || file1.fileType != file2.fileType{
            return false
        }
        if context.compareBySize{
            if file1.size != file2.size{
                return false
            }
        }
        if context.compareByCreation{
            if file1.fileCreationDate != file2.fileCreationDate{
                return false
            }
        }
        return true
    }
    
    func evaluateFiles() {
        if let directory = directory{
            for file in directory.files {
                file.evaluateData()
            }
            reloadData()
        }
    }
    
    func calculateFolderSizes() {
        if let directory = directory{
            for file in directory.files {
                if let directory = file as? DirectoryData{
                    directory.calculateSize()
                }
            }
            reloadData()
        }
    }
    
    func openFile(_ file:FileData){
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.promptsUserIfNeeded = true
        NSWorkspace.shared.open(file.url, configuration: configuration){ app, error in
            if let error = error {
                Log.error(error: error)
            }
        }
    }
    
}

class FileMenu: NSMenu{
    
    var file: FileData
    
    init(file: FileData) {
        self.file = file
        super.init(title: "")
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

