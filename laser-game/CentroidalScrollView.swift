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
    var visibleSubviews: Int
    var subviewSpacing: CGFloat
    var contentOffsetMin: CGPoint
    var contentOffsetMax: CGPoint
    
    //MARK: - State Properties
    var currentMiddleViewIndex: Int
    var currentMiddleView: UIImageView?{
        get{
            return subviews[currentMiddleViewIndex] as? UIImageView
        }
    }
    var nextMiddleView: UIImageView?{
        get{
            if(scrollingState == .left){
                return subviews[currentMiddleViewIndex-1] as? UIImageView
            }
            else if(scrollingState == .right){
                return subviews[currentMiddleViewIndex+1] as? UIImageView
            }
            else{
                return nil
            }
        }
    }
    enum scrollState{
        case right, left, none
    }
    var scrollingState: scrollState
    
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
    
    //MARK: - Animation Properties
    let scrollAnimation = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut)
    
    //MARK: - Constructors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        visibleSubviews = 3
        subviewSpacing = 0
        contentOffsetMin = CGPoint(x: 0, y: 0)
        contentOffsetMax = CGPoint(x: 0, y: 0)
        currentMiddleViewIndex = 0
        scrollingState = .none
        peripheralViewSize = CGSize(width: 0, height: 0)
        middleViewSize = CGSize(width: 0, height: 0)
        peripheralViewAlpha = 1.0
        middleViewAlpha = 1.0
        super.init(frame: frame)
        //Superclass Property Initialization
        decelerationRate = UIScrollViewDecelerationRateNormal
        isScrollEnabled = false
        isDirectionalLockEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    convenience init(superView: UIView, distanceFromBottomOfView: CGFloat, visibleSubviews: Int, peripheralViewSize: CGSize, middleViewSize: CGSize, subviewSpacing: CGFloat, imagesForSubviews:[UIImage]){
        //calculate scrollview frame
        let scrollViewWidth = (CGFloat)(visibleSubviews - 1) * (peripheralViewSize.width + subviewSpacing) + middleViewSize.width
        let frame = CGRect(x: (superView.bounds.width-scrollViewWidth)/2, y: superView.frame.maxY - (distanceFromBottomOfView + middleViewSize.height), width: scrollViewWidth, height: middleViewSize.height)
        
        //call default constructor
        self.init(frame: frame)
        
        //set property values
        self.visibleSubviews = visibleSubviews
        self.peripheralViewSize = peripheralViewSize
        self.middleViewSize = middleViewSize
        self.subviewSpacing = subviewSpacing
        contentOffsetMin = CGPoint(x: -(scrollViewWidth/2 - middleViewSize.width/2), y: 0)
        contentOffsetMax = CGPoint(x:(CGFloat)(imagesForSubviews.count-((visibleSubviews-1)/2+1))*(peripheralViewSize.width+subviewSpacing), y: 0)
        
        //add subviews to scrollview, frames of each subview account for subview spacing and are by default peripheral views
        var i: Int = 0
        var xPos: CGFloat
        for thisImage in imagesForSubviews{
            let imageView = UIImageView()
            imageView.image = thisImage
            imageView.alpha = peripheralViewAlpha
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
        self.contentOffset = self.contentOffsetMin
        self.currentMiddleView?.alpha = self.middleViewAlpha
        self.resizeAndTranslate(self.currentMiddleView!, to: self.middleViewSize)
    }
    
    //MARK: - ScrollView Methods
    func scrollLeft(){
        //if statement ensures that the scrollview is not already scrolling and that it will not scroll out of bounds
        if(!scrollAnimation.isRunning && (self.contentOffset.x > self.contentOffsetMin.x)){
            //set scroll state
            scrollingState = .left
            
            //animations
            self.setScrollAnimation()
            scrollAnimation.startAnimation()
        }
    }
    
    func scrollRight(){
        //if statement ensures that the scrollview is not already scrolling and that it will not scroll out of bounds
        if(!scrollAnimation.isRunning && (self.contentOffset.x < self.contentOffsetMax.x)){
            //set scroll state
            scrollingState = .right
            
            //animations
            self.setScrollAnimation()
            scrollAnimation.startAnimation()
        }
    }
    
    //MARK: - Subview Methods
    func resizeAndTranslate(_ subview:UIImageView, to size: CGSize){
        let deltaW = size.width - subview.frame.width
        
        //Determine if the widget is growing or shrinking
        enum resizeState{
            case growing, shrinking, neither
        }
        var resizingState: resizeState = .neither
        if(deltaW < 0){
            resizingState = .shrinking
        }
        else if(deltaW > 0){
            resizingState = .growing
        }
        else{
            resizingState = .neither
        }
        
        //To maintain subviewspacing there are 2 cases where we must translate a resizing subview: when the scrollview is scrolling right and the subview is growing, and when the scrollview is scrolling left and the subview is shrinking. All other cases are fulfilled by simply resizing the subview without a translation.
        if(scrollingState == .left && resizingState == .shrinking) || (scrollingState == .right && resizingState == .growing){
            subview.frame = CGRect(x: subview.frame.minX-deltaW, y: (self.frame.height-size.height)/2, width: size.width, height: size.height)
        }
        else{
            subview.frame = CGRect(x: subview.frame.minX, y: (self.frame.height-size.height)/2, width: size.width, height: size.height)
        }
    }
    
    //MARK: - Animation Methods
    func setScrollAnimation(){
        self.scrollAnimation.addAnimations {
            //scroll the scrollview
            if(self.scrollingState == .left){
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
            if (self.scrollingState == .left){
                self.currentMiddleViewIndex -= 1
            }
            else{
                self.currentMiddleViewIndex += 1
            }
            self.scrollingState = .none
        }
    }
}
