/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

class ExifDataViewController: PopoverViewController {
    
    var file: ImageData
    
    var contentView: ExifDataView{
        view as! ExifDataView
    }
    
    init(_ file: ImageData){
        self.file = file
        super.init()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ExifDataView(controller: self)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 0))
        contentView.setupView(file)
    }
    
}

class ExifDataView: PopoverView{
    
    var file: ImageData!
    
    func setupView(_ file: ImageData) {
        self.file = file
        super.setupView(title: file.fileName)
        if let exifData = file.exifData{
            var label = NSTextField(labelWithString: "\("size".localize()): \(exifData.exifWidth)x\(exifData.exifHeight)")
            contentView.addSubviewBelow(label)
            var lastView = label
            label = NSTextField(labelWithString: "\("camera".localize()): \(exifData.exifLensModel)")
            contentView.addSubviewBelow(label, upperView: lastView)
            lastView = label
            if let date = exifData.exifCreationDate{
                label = NSTextField(labelWithString: "\("creationDate".localize()): \(date.dateTimeString())")
                contentView.addSubviewBelow(label, upperView: lastView)
                lastView = label
            }
            if exifData.exifLatitude != 0 || exifData.exifLongitude != 0{
                label = NSTextField(labelWithString: "\("latitude".localize()): \(exifData.exifLatitude)")
                contentView.addSubviewBelow(label, upperView: lastView)
                lastView = label
                label = NSTextField(labelWithString: "\("longitude".localize()): \(exifData.exifLongitude)")
                contentView.addSubviewBelow(label, upperView: lastView)
                lastView = label
            }
            if exifData.exifAltitude != 0{
                label = NSTextField(labelWithString: "\("altitude".localize()): \(exifData.exifAltitude)")
                contentView.addSubviewBelow(label, upperView: lastView)
                lastView = label
            }
            lastView.connectToBottom(of: contentView)
        }
    }
    
}
