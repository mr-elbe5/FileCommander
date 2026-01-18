/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

extension NSEdgeInsets{

    static var smallInset : CGFloat = 5
    
    static var defaultInset : CGFloat = 10
    
    static var zero : NSEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)

    static var smallInsets : NSEdgeInsets = .init(top: smallInset, left: smallInset, bottom: smallInset, right: smallInset)
    
    static var defaultInsets : NSEdgeInsets = .init(top: defaultInset, left: defaultInset, bottom: defaultInset, right: defaultInset)

    static var flatInsets : NSEdgeInsets = .init(top: 0, left: defaultInset, bottom: 0, right: defaultInset)

    static var narrowInsets : NSEdgeInsets = .init(top: defaultInset, left: 0, bottom: defaultInset, right: 0)

    static var reverseInsets : NSEdgeInsets = .init(top: -defaultInset, left: -defaultInset, bottom: -defaultInset, right: -defaultInset)

    static var doubleInsets : NSEdgeInsets = .init(top: 2 * defaultInset, left: 2 * defaultInset, bottom: 2 * defaultInset, right: 2 * defaultInset)
    
}
