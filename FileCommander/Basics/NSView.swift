/*
 File Commander
 Copyright (C) 2025 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import AppKit

extension NSView{
    
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    var highPriority : Float{
        get{
            900
        }
    }

    var midPriority : Float{
        get{
            500
        }
    }

    var lowPriority : Float{
        get{
            300
        }
    }

    static var defaultPriority : Float{
        get{
            900
        }
    }

    func setRoundedBorders(){
        if let layer = layer{
            layer.borderWidth = 0.5
            layer.cornerRadius = 5
        }
    }

    func setGrayRoundedBorders(){
        if let layer = layer{
            layer.borderColor = NSColor.lightGray.cgColor
            layer.borderWidth = 0.5
            layer.cornerRadius = 10
        }
    }

    func resetConstraints(){
        for constraint in constraints{
            constraint.isActive = false
        }
    }

    func fillSuperview(insets: NSEdgeInsets = NSEdgeInsets()){
        if let sv = superview{
            fillView(view: sv, insets: insets)
        }
    }

    func fillView(view: NSView, insets: NSEdgeInsets = NSEdgeInsets()){
        enableAnchors()
            .leading(view.leadingAnchor,inset: insets.left)
            .top(view.topAnchor,inset: insets.top)
            .trailing(view.trailingAnchor,inset: insets.right)
            .bottom(view.bottomAnchor,inset: insets.bottom)
    }

    @discardableResult
    func setAnchors(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, insets: NSEdgeInsets = NSEdgeInsets()) -> NSView{
        return enableAnchors()
            .top(top, inset: insets.top)
            .leading(leading, inset: insets.left)
            .trailing(trailing, inset: insets.right)
            .bottom(bottom, inset: insets.bottom)
    }

    @discardableResult
    func setAnchors(centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) -> NSView{
        enableAnchors()
            .centerX(centerX)
            .centerY(centerY)
    }
    
    @discardableResult
    func enableAnchors() -> NSView{
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func leading(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = leadingAnchor.constraint(equalTo: anchor, constant: inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func trailing(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = trailingAnchor.constraint(equalTo: anchor, constant: -inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func top(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = topAnchor.constraint(equalTo: anchor, constant: inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func bottom(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        if let anchor = anchor{
            let constraint = bottomAnchor.constraint(equalTo: anchor, constant: -inset)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerX(_ anchor: NSLayoutXAxisAnchor?,priority: Float = defaultPriority) -> NSView{
        if anchor != nil{
            let constraint = centerXAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerY(_ anchor: NSLayoutYAxisAnchor?,priority: Float = defaultPriority) -> NSView{
        if anchor != nil{
            let constraint = centerYAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = NSLayoutConstraint.Priority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        widthAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat,priority: Float = defaultPriority) -> NSView{
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> NSView{
        heightAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func setSquareByWidth(priority: Float = defaultPriority) -> NSView{
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: 1, constant: 0)
        c.priority = NSLayoutConstraint.Priority(priority)
        addConstraint(c)
        return self
    }
    
    @discardableResult
    func setSquareByHeight(priority: Float = defaultPriority) -> NSView{
        let c = NSLayoutConstraint(item: self, attribute: .height,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .width,
                                   multiplier: 1, constant: 0)
        c.priority = NSLayoutConstraint.Priority(priority)
        addConstraint(c)
        return self
    }
    
    @discardableResult
    func removeAllConstraints() -> NSView{
        for constraint in constraints{
            removeConstraint(constraint)
        }
        return self
    }
    
    @discardableResult
    func addSubviewFilling(_ subview: NSView, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewFillingSafeArea(_ subview: NSView, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewWithAnchors(_ subview: NSView, top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: top, leading: leading, trailing: trailing, bottom: bottom, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewCentered(_ subview: NSView, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) -> NSView{
        addSubview(subview)
        subview.setAnchors(centerX: centerX,centerY: centerY)
        return subview
    }
    
    @discardableResult
    func addSubviewBelow(_ subview: NSView, upperView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: upperView?.bottomAnchor ?? topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewCenteredBelow(_ subview: NSView, upperView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: upperView?.bottomAnchor ?? topAnchor, insets: insets)
            .centerX(centerXAnchor)
        return subview
    }
    
    @discardableResult
    func addSubviewToRight(_ subview: NSView, leftView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: topAnchor, leading: leftView?.trailingAnchor ?? leadingAnchor, bottom: bottomAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func addSubviewToLeft(_ subview: NSView, rightView: NSView? = nil, insets: NSEdgeInsets = .defaultInsets) -> NSView{
        addSubview(subview)
        subview.setAnchors(top: topAnchor, trailing: rightView?.leadingAnchor ?? trailingAnchor, bottom: bottomAnchor, insets: insets)
        return subview
    }
    
    @discardableResult
    func connectToBottom(of parentView: NSView, inset: Double = NSEdgeInsets.defaultInset) -> NSView{
        self.bottom(parentView.bottomAnchor, inset: inset)
        return self
    }
    
    @discardableResult
    func connectToRight(of parentView: NSView, inset: Double = NSEdgeInsets.defaultInset) -> NSView{
        trailing(parentView.trailingAnchor, inset: inset)
        return self
    }
    
    @discardableResult
    func connectToLeft(of parentView: NSView, inset: Double = NSEdgeInsets.defaultInset) -> NSView{
        leading(parentView.leadingAnchor, inset: inset)
        return self
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    func removeSubview(_ view : NSView) {
        for subview in subviews {
            if subview == view{
                subview.removeFromSuperview()
                break
            }
        }
    }

}

