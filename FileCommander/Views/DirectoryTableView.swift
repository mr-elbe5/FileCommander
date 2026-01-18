/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

protocol PanelActionDelegate{
    func directoryChanged()
    func activated()
}

class DirectoryTableView: NSTableView {
    
    let columnNames = ["type", "name", "data", "size", "created", "modified"]
    
    var directory: DirectoryData? = nil
    
    var side: PanelSide
    
    var columnIdentifiers = Array<NSUserInterfaceItemIdentifier>()
    
    var actionDelegate: PanelActionDelegate? = nil
    
    var context: PanelContext{
        AppData.shared.context(side)
    }
    
    var otherDirectory: DirectoryData?{
        AppData.shared.context(side.other).currentDirectory
    }
    
    var isOtherDirectoryTheSame: Bool{
        directory != nil && directory!.url == otherDirectory?.url
    }
    
    var otherTableView: DirectoryTableView?{
        MainViewController.shared.panel(side.other).tableView
    }
    
    init(side: PanelSide){
        self.side = side
        super.init(frame: .zero)
        delegate = self
        dataSource = self
        for cn in columnNames {
            let cid = NSUserInterfaceItemIdentifier(cn)
            columnIdentifiers.append(cid)
            let col = NSTableColumn(identifier: cid)
            col.title = "col_\(cn)".localize()
            var ascending: Bool = true
            switch cn{
            case "type":
                col.minWidth = 15
                col.maxWidth = 30
            case "data":
                col.minWidth = 10
                col.maxWidth = 10
            case "size":
                col.minWidth = 30
                col.maxWidth = 50
            case "created", "modified":
                ascending = false
                col.minWidth = 110
                col.maxWidth = 110
            default:
                break
            }
            let sortDescriptor = NSSortDescriptor(key: "\(cn)", ascending: ascending)
            col.sortDescriptorPrototype = sortDescriptor
            sortDescriptors.append(sortDescriptor)
            addTableColumn(col)
        }
        allowsMultipleSelection = true
        allowsColumnResizing = true
        allowsColumnReordering = false
        gridStyleMask = [.solidHorizontalGridLineMask, .solidVerticalGridLineMask]
        selectionHighlightStyle = .regular
        style = .fullWidth
        columnAutoresizingStyle = .reverseSequentialColumnAutoresizingStyle
        self.doubleAction = #selector(doubleClicked)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDirectory(_ dir: DirectoryData){
        directory = dir
        actionDelegate?.directoryChanged()
        reloadData()
    }
    
    func directoryFilesChanged(){
        reloadData()
        guard let directory = directory else {return}
        selectRowIndexes(directory.selectedIndexes, byExtendingSelection: false)
    }
    
    func fileForRow(_ row: Int) -> FileData?{
        if let parentDirectory = directory?.parentDirectory{
            if row == 0{
                return parentDirectory
            }
            return directory?.files[row - 1]
        }
        return directory?.files[row]
    }
    
    override func becomeFirstResponder() -> Bool {
        actionDelegate?.activated()
        return super.becomeFirstResponder()
    }
    
}

extension DirectoryTableView: NSTableViewDelegate{
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow: Int) -> NSTableRowView?{
        TableRow()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let col = tableColumn, let file = fileForRow(row){
            if col.identifier.rawValue == "type" || col.identifier.rawValue == "data"{
                return getIconCell(tableView: tableView, file: file, row: row, col: col)
            }
            else{
                return getTextCell(tableView: tableView, file: file, row: row, col: col)
            }
        }
        return nil
    }
    
    private func getIconCell(tableView: NSTableView, file: FileData, row: Int, col: NSTableColumn) -> NSTableCellView?{
        var icon: NSImage? = nil
        if file.isDirectory, let directory = file as? DirectoryData{
            if col.identifier.rawValue == "type"{
                if directory.isParentDirectory{
                    return nil
                }
                icon = NSImage(systemSymbolName: "folder", accessibilityDescription: "Folder")
            }
        }
        else{
            switch col.identifier.rawValue {
            case "type":
                icon = file.fileType?.image
            case "data":
                switch file.dataString{
                case "EXIF":
                    icon = NSImage(systemSymbolName: "camera.badge.ellipsis", accessibilityDescription: "EXIF")
                case "GPS":
                    icon = NSImage(systemSymbolName: "mappin.and.ellipse", accessibilityDescription: "GPS")
                case "TXT":
                    icon = NSImage(systemSymbolName: "text.document", accessibilityDescription: "TXT")
                default:
                    return nil
                }
            default:
                return nil
            }
        }
        if let icon = icon{
            if let cell = tableView.makeView(withIdentifier: col.identifier, owner: nil) as? ImageCellView {
                cell.image = icon
                return cell
            }
            else{
                let cell = ImageCellView(identifier: col.identifier)
                cell.image = icon
                return cell
            }
        }
        else{
            return nil
        }
    }
    
    private func getTextCell(tableView: NSTableView, file: FileData, row: Int, col: NSTableColumn) -> NSTableCellView?{
        var cellText = ""
        var alignment: NSTextAlignment = .left
        if row == 0, let directory = file as? DirectoryData, directory.isParentDirectory{
            switch col.identifier.rawValue {
            case "name":
                cellText = file.fileName
            default:
                cellText = ""
            }
        }
        else{
            switch col.identifier.rawValue {
            case "name":
                cellText = "\(file.fileName)"
            case "size":
                cellText = file.sizeString
                alignment = .right
            case "created":
                cellText = file.creationDateString
                alignment = .right
            case "modified":
                cellText = file.mofificationDateString
                alignment = .right
            default:
                cellText = "unknown"
            }
        }
        if let cell = tableView.makeView(withIdentifier: col.identifier, owner: nil) as? TextCellView {
            cell.text = cellText
            cell.alignment = alignment
            return cell
        }
        else{
            let cell = TextCellView(identifier: col.identifier)
            cell.text = cellText
            cell.alignment = alignment
            return cell
        }
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
        if row == 0, let file = fileForRow(row), let directory = file as? DirectoryData, directory.isParentDirectory{
            return false
        }
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let set = selectedRowIndexes
        directory?.selectSet(set)
    }
    
    func tableView(_ tableView: NSTableView, userCanChangeVisibilityOf column: NSTableColumn) -> Bool{
        switch column.identifier.rawValue {
        case "type", "name":
            return false
        default:
            return true
        }
    }
    
}

extension DirectoryTableView: NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int{
        directory?.fileCount ?? 0
    }
    
    func tableView(_: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]){
        if let sortDescriptor = sortDescriptors.first, let key = sortDescriptor.key{
            //Log.info("sorting changed to: \(key), \(sortDescriptor.ascending)")
            if let directory = directory{
                var sortType: SortType = .initial
                switch key {
                case "type":
                    sortType = .byType
                case "name":
                    sortType = .byName
                case "size":
                    sortType = .bySize
                case "created":
                    sortType = .byFileCreation
                case "modified":
                    sortType = .byFileModification
                default:
                    return
                }
                directory.sort(sortType, ascending: sortDescriptor.ascending)
                directoryFilesChanged()
            }
        }
    }
    
}
