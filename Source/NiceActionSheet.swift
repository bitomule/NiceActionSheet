//
//  NiceActionSheet.swift
//  NiceActionSheet
//
//  Created by David Collado Sela on 22/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit
import EasyConstraints

public struct NiceActionSheetButton {
    public var title:String
    public var titleColor:UIColor
    
    public init(title:String) {
        self.title = title
        self.titleColor = UIColor.whiteColor()
    }
    
    public init(title:String,titleColor:UIColor) {
        self.title = title
        self.titleColor = titleColor
    }
}

public class NiceActionSheet: UIViewController {
    
    private var parentVC:UIViewController!
    
    public class func show(presenter:UIViewController,backgroundColor:UIColor,backgroundAlpha:CGFloat = 1,sheetBackgroundColor:UIColor,title:String,titleFont:UIFont = UIFont.systemFontOfSize(14),titleColor:UIColor = UIColor.blackColor(),buttons:[NiceActionSheetButton],buttonSelectedColor:UIColor?=nil,buttonsFont:UIFont=UIFont.systemFontOfSize(14),buttonSelectedIndex:Int?=nil,buttonsHandler: (index:Int) -> Void)->NiceActionSheet{
        let vc = NiceActionSheet()
        vc.parentVC = presenter
        vc.actionTitle = title
        vc.titleFont = titleFont
        vc.titleColor = titleColor
        vc.buttons = buttons
        vc.buttonSelectedColor = buttonSelectedColor
        vc.buttonsHandler = buttonsHandler
        vc.buttonSelectedIndex = buttonSelectedIndex
        vc.buttonsFont = buttonsFont
        vc.backgroundViewAlpha = backgroundAlpha
        vc.backgroundViewColor = backgroundColor
        vc.actionSheetBackgroundColor = sheetBackgroundColor
        vc.show()
        return vc
    }
    
    private var inTime = 0.5
    private var outTime = 0.3
    
    private var displayed = false
    
    private func show(){
        displayed = true
        self.willMoveToParentViewController(parentVC)
        parentVC.view.addSubview(self.view)
        self.didMoveToParentViewController(parentVC)
        
        self.view.backgroundColor = self.backgroundViewColor.colorWithAlphaComponent(0)
        UIView.animateWithDuration(self.inTime, animations: { () -> Void in
            self.view.backgroundColor = self.backgroundViewColor.colorWithAlphaComponent(self.backgroundViewAlpha)
        })
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = self.inTime
        animation.fromValue = UIScreen.mainScreen().bounds.height + self.viewContainer.bounds.height * 0.5
        animation.toValue = UIScreen.mainScreen().bounds.height - self.viewContainer.bounds.height * 0.5
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        self.viewContainer.layer.addAnimation(animation, forKey: "show")
    }
    
    private func hide(){
        displayed = false
        self.viewContainer.layer.removeAllAnimations()
        self.view.backgroundColor = self.backgroundViewColor.colorWithAlphaComponent(self.backgroundViewAlpha)
        
        UIView.animateWithDuration(self.outTime, animations: { () -> Void in
            self.view.backgroundColor = self.backgroundViewColor.colorWithAlphaComponent(0)
        }) { (completed) -> Void in
            self.view.removeFromSuperview()
        }
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = outTime
        animation.fromValue = UIScreen.mainScreen().bounds.height - self.viewContainer.bounds.height * 0.5
        animation.toValue = UIScreen.mainScreen().bounds.height + self.viewContainer.bounds.height * 0.5
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
        self.viewContainer.layer.addAnimation(animation, forKey: "hide")
    }
    
    var horizontalMargin:CGFloat = 37
    var bottomVerticalMargin:CGFloat = 20
    var buttonToPreviousBorderMargin:CGFloat = 0
    var buttonToTitleMargin:CGFloat = 10
    var borderToTopButtonMargin:CGFloat = 0
    var titleToTopMargin:CGFloat = 19
    var buttonHeight:CGFloat = 43
    
    var actionTitle:String = ""
    var buttons:[NiceActionSheetButton]!
    var buttonSelectedIndex:Int?
    var buttonsHandler: ((index:Int) -> Void)!
    
    //Styles
    
    var titleFont:UIFont = UIFont.systemFontOfSize(14)
    var titleColor:UIColor = UIColor.blackColor()
    var buttonSelectedColor:UIColor?
    var backgroundViewAlpha:CGFloat = 0.1
    var backgroundViewColor = UIColor.redColor()
    var actionSheetBackgroundColor = UIColor.grayColor()
    var buttonsFont:UIFont = UIFont.systemFontOfSize(15)
    
    var viewContainer: UIView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundViewColor.colorWithAlphaComponent(backgroundViewAlpha)
        if let buttonSelectedColor = buttonSelectedColor{
            buttonSelectedImageColor = getImageWithColor(buttonSelectedColor,size:CGSize(width: 1, height: 1))
        }
        createViewContainer()
        addGestureRecognizers()
    }
    
    private func addGestureRecognizers(){
        let tapGesture = UITapGestureRecognizer(target: self, action: "viewTapped")
        self.view.addGestureRecognizer(tapGesture)
        
        let ignoreTapInContainer = UITapGestureRecognizer(target: self, action: "ignoreTapInContainer")
        viewContainer.addGestureRecognizer(ignoreTapInContainer)
    }
    
    func viewTapped(){
        hide()
    }
    
    func ignoreTapInContainer(){
        
    }
    
    private func createViewContainer(){
        viewContainer = UIView()
        viewContainer.backgroundColor = actionSheetBackgroundColor
        viewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        viewContainer.clipsToBounds = true
        let trailingConstraint = self.view<>>(viewContainer,0)
        let leadingConstraint = self.view<<>(viewContainer,0)
        let bottomSpaceConstraint = self.view*<^>(viewContainer,0)
        self.view.addSubview(viewContainer)
        titleView = createTitle(viewContainer)
        createButtons(viewContainer)
        self.view.addConstraints([trailingConstraint,leadingConstraint,bottomSpaceConstraint])
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    var titleView:UILabel!
    
    private func createTitle(container:UIView)->UILabel{
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.text = actionTitle
        label.textColor = titleColor
        label.font = titleFont
        label.textAlignment = NSTextAlignment.Center
        container.addSubview(label)
        let topSpace = label<^>(container,titleToTopMargin)
        let leadingConstraint = label<<>(container,horizontalMargin)
        let trailingConstraint = container<>>(label,horizontalMargin)
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 30)
        label.addConstraint(heightConstraint)
        container.addConstraints([topSpace,leadingConstraint,trailingConstraint])
        return label
    }
    
    private func createButtons(container:UIView){
        var lastView:UIView = titleView
        assert(buttons.count > 0, "At least one button needed")
        for(var i=0;i<buttons.count;i++){
            let button = createButton(buttons[i],container:container,previousView:lastView,index:i)
            if(i==(buttons.count - 1)){
                lastView = button
            }else{
                lastView = createBorder(container, previousButton: button)
            }
        }
        let bottomConstraint = container*<^>(lastView,bottomVerticalMargin)
        container.addConstraint(bottomConstraint)
    }
    
    private var renderedButtons:[UIButton] = [UIButton]()
    
    private func createButton(buttonInfo:NiceActionSheetButton,container:UIView,previousView:UIView,index:Int)->UIView{
        let button = UIButton()
        renderedButtons.append(button)
        button.setTitle(buttonInfo.title, forState: .Normal)
        button.titleLabel?.font = buttonsFont
        button.setTitleColor(buttonInfo.titleColor, forState: .Normal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        if let buttonSelectedIndex = buttonSelectedIndex where buttonSelectedIndex == index{
            button.selected = true
        }else{
            button.selected = false
        }
        
        if let buttonSelectedImageColor = buttonSelectedImageColor{
            button.setBackgroundImage(buttonSelectedImageColor, forState: UIControlState.Highlighted)
            button.setBackgroundImage(buttonSelectedImageColor, forState: UIControlState.Selected)
        }
        button.tag = index
        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        container.addSubview(button)
        let topSpace:NSLayoutConstraint
        if(index == 0)
        {
            //Is first button
            let topSpace = button*><>(previousView,buttonToTitleMargin)
            container.addConstraint(topSpace)
        }else{
            let topSpace = button*><>(previousView,buttonToPreviousBorderMargin)
            container.addConstraint(topSpace)
        }

        let leadingConstraint = button<<>(container,horizontalMargin)
        let trailingConstraint = container<>>(button,horizontalMargin)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: buttonHeight)
        button.addConstraint(heightConstraint)
        container.addConstraints([trailingConstraint,leadingConstraint])
        return button
    }
    
    private func resetButtons(){
        for button in renderedButtons{
            button.selected = false
        }
    }
    
    func buttonPressed(button:UIButton){
        resetButtons()
        button.selected = true
        hide()
        buttonsHandler(index:button.tag)
    }
    
    private func createBorder(container:UIView,previousButton:UIView)->UIView{
        let border = UIView()
        border.setTranslatesAutoresizingMaskIntoConstraints(false)
        if let buttonSelectedColor = buttonSelectedColor{
            border.backgroundColor = buttonSelectedColor
        }else{
            border.backgroundColor = UIColor.clearColor()
        }
        container.addSubview(border)
        let topSpace = border*><>(previousButton,borderToTopButtonMargin)
        let leadingConstraint = border<<>(container,horizontalMargin)
        let trailingConstraint = container<>>(border,horizontalMargin)
        let heightConstraint = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 1)
        container.addConstraints([topSpace,trailingConstraint,leadingConstraint,heightConstraint])
        return border
    }
    
    var buttonSelectedImageColor:UIImage?
    
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        var rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
