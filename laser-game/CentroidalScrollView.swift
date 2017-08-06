//
//  CentroidalScrollView.swift
//  laser-game
//
//  Created by Thomas Propson on 7/25/17.
//  Copyright © 2017 com.thomaspropson. All rights reserved.
//

import UIKit

class CentroidalScrollView: UIScrollView{
    //MARK: - ScrollView Properties
    var subviewsVisible: Int
    var subviewSpacing: CGFloat
    var contentOffsetMin: CGPoint
    var contentOffsetMax: CGPoint
    var subviewNames: [String]
    
    //MARK: - State Properties
    var currentMiddleViewIndex: Int
    public var currentMiddleView: UIImageView?{
        get{
            return subviews[currentMiddleViewIndex] as? UIImageView
        }
    }
    var nextMiddleView: UIImageView?{
        get{
            if(scrollState == .left){
                return subviews[currentMiddleViewIndex-1] as? UIImageView
            }
            else if(scrollState == .right){
                return subviews[currentMiddleViewIndex+1] as? UIImageView
            }
            else{
                return nil
            }
        }
    }
    var scrollState: ScrollState
    
    //MARK: - Subview Properties
    var peripheralViewSize: CGSize
    var middleViewSize: CGSize
    var peripheralViewAlpha: CGFloat{
        didSet{
            for subview in subviews{
                subview.alpha = peripheralViewAlpha
            }
            currentMiddleView?.alpha = middleViewAlpha
        }
    }
    var middleViewAlpha: CGFloat{
        didSet{
            //update alpha values
            for subview in subviews{
                subview.alpha = peripheralViewAlpha
            }
            currentMiddleView?.alpha = middleViewAlpha
        }
    }
    var subviewNameDisplayEnabled: Bool
    /*
    {
        didSet{
            if (subviewNameDisplayEnabled == false){
                subviewNameDisplay.removeFromSuperview()
            }
        }
    }
   */
    
    //MARK: - Appendages
    var subviewNameDisplay: UITextView
    
    //MARK: - Animation Properties
    let scrollAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut)
    let subviewNameDisplayAnimation = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
    
    //MARK: - Constructors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        subviewsVisible = 3
        subviewSpacing = 0
        contentOffsetMin = CGPoint(x: 0, y: 0)
        contentOffsetMax = CGPoint(x: 0, y: 0)
        subviewNames = [String]()
        currentMiddleViewIndex = 0
        scrollState = .none
        peripheralViewSize = CGSize(width: 0, height: 0)
        middleViewSize = CGSize(width: 0, height: 0)
        peripheralViewAlpha = 1.0
        middleViewAlpha = 1.0
        subviewNameDisplayEnabled = false
        subviewNameDisplay = UITextView()
        super.init(frame: frame)
        //Superclass Property Initialization
        decelerationRate = UIScrollViewDecelerationRateNormal
        isScrollEnabled = false
        isDirectionalLockEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    convenience init(superView: UIView, distanceFromBottomOfView: CGFloat, subviewsVisible: Int, peripheralViewSize: CGSize, middleViewSize: CGSize, subviewSpacing: CGFloat, subviewImages:[UIImage]){
        //calculate scrollview frame
        let scrollViewWidth = (CGFloat)(subviewsVisible - 1) * (peripheralViewSize.width + subviewSpacing) + middleViewSize.width
        let frame = CGRect(x: (superView.bounds.width-scrollViewWidth)/2, y: superView.frame.maxY - (distanceFromBottomOfView + middleViewSize.height), width: scrollViewWidth, height: middleViewSize.height)
        
        //call default constructor
        self.init(frame: frame)
        
        //assign scrollview properties
        self.subviewsVisible = subviewsVisible
        self.peripheralViewSize = peripheralViewSize
        self.middleViewSize = middleViewSize
        self.subviewSpacing = subviewSpacing
        contentOffsetMin = CGPoint(x: -(scrollViewWidth/2 - middleViewSize.width/2), y: 0)
        contentOffsetMax = CGPoint(x:(CGFloat)(subviewImages.count-((subviewsVisible-1)/2+1))*(peripheralViewSize.width+subviewSpacing), y: 0)
        
        //add subviews to scrollview, frames of each subview account for subview spacing and are by default peripheral views
        var i: Int = 0
        var xPos: CGFloat
        for image in subviewImages{
            let imageView = UIImageView()
            imageView.image = image
            if(i == 0){
                xPos = 0
            }
            else{
                xPos = middleViewSize.width + (CGFloat)(i) * subviewSpacing + CGFloat(i-1) * peripheralViewSize.width
            }
            //the x and y coordinates of each imageView frame are relative to the origin, top left, of the scrollview
            imageView.frame = CGRect(x: xPos, y: (self.frame.height-peripheralViewSize.height)/2, width: peripheralViewSize.width, height: peripheralViewSize.height)
            self.addSubview(imageView)
            i += 1
        }
        
        //update the scrollview such that the first subview is the middlewidget
        contentOffset = contentOffsetMin
        currentMiddleView?.alpha = middleViewAlpha
        resizeAndTranslate(currentMiddleView!, to: middleViewSize)
        
        //assign subviewNameDisplay properties
        subviewNameDisplay.frame = CGRect(x: self.frame.midX - (self.middleViewSize.width/2), y: self.frame.minY - 25, width: middleViewSize.width, height: 15)
        subviewNameDisplay.backgroundColor = UIColor.clear
        subviewNameDisplay.textColor = UIColor.white
        subviewNameDisplay.textAlignment = .center
        subviewNameDisplay.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        subviewNameDisplay.font = UIFont(name: "", size: 15)
    }
    
    //MARK: - ScrollView Methods
    public func scrollLeft(){
        //if statement ensures that the scrollview is not already scrolling and that it will not scroll out of bounds
        if(!scrollAnimation.isRunning && (self.contentOffset.x > self.contentOffsetMin.x)){
            //set scroll state
            scrollState = .left
            
            //animations
            self.runScrollAnimation()
        }
    }
    public func scrollRight(){
        //if statement ensures that the scrollview is not already scrolling and that it will not scroll out of bounds
        if(!scrollAnimation.isRunning && (self.contentOffset.x < self.contentOffsetMax.x)){
            //set scroll state
            scrollState = .right
            
            //animations
            self.runScrollAnimation()
        }
    }
    
    //MARK: - Subview Methods
    func resizeAndTranslate(_ subview:UIImageView, to size: CGSize){
        let deltaW = size.width - subview.frame.width
        
        //Determine if the widget is growing or shrinking
        var resizeState: ResizeState = .neither
        if(deltaW < 0){
            resizeState = .shrinking
        }
        else if(deltaW > 0){
            resizeState = .growing
        }
        else{
            resizeState = .neither
        }
        
        //To maintain subviewspacing there are 2 cases where we must translate a resizing subview: when the scrollview is scrolling right and the subview is growing, and when the scrollview is scrolling left and the subview is shrinking. All other cases are fulfilled by simply resizing the subview without a translation.
        if(scrollState == .left && resizeState == .shrinking) || (scrollState == .right && resizeState == .growing){
            subview.frame = CGRect(x: subview.frame.minX-deltaW, y: (self.frame.height-size.height)/2, width: size.width, height: size.height)
        }
        else{
            subview.frame = CGRect(x: subview.frame.minX, y: (self.frame.height-size.height)/2, width: size.width, height: size.height)
        }
    }
    
    //MARK: - Animation Methods
    func runScrollAnimation(){
        self.scrollAnimation.addAnimations {
            //scroll the scrollview
            if(self.scrollState == .left){
                self.setContentOffset(CGPoint(x: self.contentOffset.x - (self.peripheralViewSize.width + self.subviewSpacing), y: self.contentOffset.y), animated: false)
            }
            else{
                self.setContentOffset(CGPoint(x: self.contentOffset.x + (self.peripheralViewSize.width + self.subviewSpacing), y: self.contentOffset.y), animated: false)
            }
            
            //update widget alpha and sizes
            self.resizeAndTranslate(self.currentMiddleView!, to: self.peripheralViewSize)
            self.currentMiddleView?.alpha = self.peripheralViewAlpha
            self.resizeAndTranslate(self.nextMiddleView!, to: self.middleViewSize)
            self.nextMiddleView?.alpha = self.middleViewAlpha
        }
        self.scrollAnimation.addCompletion{_ in
            //update currentMiddleViewIndex
            if (self.scrollState == .left){
                self.currentMiddleViewIndex -= 1
            }
            else{
                self.currentMiddleViewIndex += 1
            }
            //update scrollState
            self.scrollState = .none
            self.runSubviewNameDisplayAnimation()
        }
        self.scrollAnimation.startAnimation()
    }
    
    func runSubviewNameDisplayAnimation(){
        if(subviewNameDisplayEnabled){
            //if the animation is already running it should terminate here
            if(subviewNameDisplayAnimation.isRunning){
                subviewNameDisplayAnimation.stopAnimation(true)
            }
            //update subviewNameDisplay
            self.subviewNameDisplay.text = subviewNames[currentMiddleViewIndex]
            self.subviewNameDisplay.alpha = 1.0
            self.superview?.addSubview(subviewNameDisplay)
        
            self.subviewNameDisplayAnimation.addAnimations {
                self.subviewNameDisplay.alpha = 0.0
            }
            self.subviewNameDisplayAnimation.addCompletion{_ in
                self.subviewNameDisplay.removeFromSuperview()
            }
            self.subviewNameDisplayAnimation.startAnimation()
        }
    }
}
