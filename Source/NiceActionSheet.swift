//
//  NiceActionSheet.swift
//  NiceActionSheet
//
//  Created by David Collado Sela on 22/5/15.
//  Copyright (c) 2015 David Collado Sela. All rights reserved.
//

import UIKit
import EasyConstraints

public class NiceActionSheet: UIViewController {
    
    public class func show(presenter:UIViewController,title:String,titleFont:UIFont = UIFont.systemFontOfSize(14),titleColor:UIColor = UIColor.blackColor()){
        let vc = NiceActionSheet()
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.transitioningDelegate = vc.manager
        vc.actionTitle = title
        vc.titleFont = titleFont
        vc.titleColor = titleColor
        presenter.presentViewController(vc, animated: true, completion: nil)
    }
    
    var backgroundViewAlpha:CGFloat = 0.1
    var backgroundViewColor = UIColor.redColor()
    var actionSheetBackgroundColor = UIColor.grayColor()
    
    var horizontalMargin:CGFloat = 10
    var bottomVerticalMargin:CGFloat = 10
    var buttonToPreviousBorderMargin:CGFloat = 5
    var buttonToTitleMargin:CGFloat = 10
    var borderToTopButtonMargin:CGFloat = 0
    var titleToTopMargin:CGFloat = 10
    
    var actionTitle:String = ""
    
    //Styles
    
    var titleFont:UIFont = UIFont.systemFontOfSize(14)
    var titleColor:UIColor = UIColor.blackColor()
    
    let manager = TransitionManager()
    var viewContainer: UIView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundViewColor.colorWithAlphaComponent(backgroundViewAlpha)
        buttonSelectedImageColor = getImageWithColor(buttonSelectedBackgroundColor,size:CGSize(width: 1, height: 1))
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
        self.dismissViewControllerAnimated(true, completion: nil)
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
        for(var i=0;i<4;i++){
            let button = createButton(container,previousView:lastView)
            if(i==3){
                lastView = button
            }else{
                lastView = createBorder(container, previousButton: button)
            }
        }
        let bottomConstraint = container*<^>(lastView,bottomVerticalMargin)
        container.addConstraint(bottomConstraint)
    }
    
    private func createButton(container:UIView,previousView:UIView)->UIView{
        let button = UIButton()
        button.setTitle("button", forState: UIControlState.Normal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.setBackgroundImage(buttonSelectedImageColor, forState: UIControlState.Highlighted)
        button.setBackgroundImage(buttonSelectedImageColor, forState: UIControlState.Selected)
        container.addSubview(button)
        let topSpace = button*><>(previousView,buttonToPreviousBorderMargin)
        container.addConstraint(topSpace)

        let leadingConstraint = button<<>(container,horizontalMargin)
        let trailingConstraint = container<>>(button,horizontalMargin)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 50)
        button.addConstraint(heightConstraint)
        container.addConstraints([trailingConstraint,leadingConstraint])
        return button
    }
    
    private func createBorder(container:UIView,previousButton:UIView)->UIView{
        let border = UIView()
        border.setTranslatesAutoresizingMaskIntoConstraints(false)
        border.backgroundColor = UIColor.blackColor()
        container.addSubview(border)
        let topSpace = border*><>(previousButton,borderToTopButtonMargin)
        let leadingConstraint = border<<>(container,horizontalMargin)
        let trailingConstraint = container<>>(border,horizontalMargin)
        let heightConstraint = NSLayoutConstraint(item: border, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 1)
        container.addConstraints([topSpace,trailingConstraint,leadingConstraint,heightConstraint])
        return border
    }
    
    var buttonSelectedBackgroundColor = UIColor.blackColor()
    var buttonSelectedImageColor:UIImage!
    
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
