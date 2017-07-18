//
//  Sinusoid.swift
//  Laser-Game
//
//  Created by Thomas Propson on 1/13/17.
//  Copyright © 2017 com.thomaspropson. All rights reserved.
//

import Foundation
import UIKit

class Sinusoid: UIBezierPath {
    
    init(from p1: CGPoint, to p2: CGPoint, frequency f: CGFloat, amplitude a: CGFloat) {
        
        let distance = p1.deltaTo(p2).hypotenuse()
        
        let nodes = [CGFloat](stride(from: .pi/2 * f, to: distance, by: .pi * f))
        
        let rotation = atan(p1.slopeTo(p2))
        let rotationTransform = CGAffineTransform(rotationAngle: rotation)
        
        let peaks = nodes.enumerated().map(){(index, value) -> CGPoint in
            
            let amp = index % 2 == 0 ? a : -a
            
            return CGPoint(x: value, y: amp).applying(rotationTransform).addTo(p1)
        }
        
        
        let lastPt = CGPoint(x: nodes.last! + .pi/2 * f, y: 0).applying(rotationTransform).addTo(p1)
        
        let curve = UIBezierPath(catmullRomPoints: [p1] + peaks + [lastPt], alpha: 0.75)!
        
        super.init()
        self.append(curve)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




extension CGPoint {
    func slopeTo(_ p: CGPoint) -> CGFloat {
        let d = p.deltaTo(self)
        return d.y / d.x
    }
    
    func addTo(_ a: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + a.x, y: self.y + a.y)
    }
    
    func absoluteDeltaY(_ a: CGPoint) -> Double {
        return Double(abs(self.y - a.y))
    }
    
    func deltaTo(_ a: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - a.x, y: self.y - a.y)
    }
    
    func multiplyBy(_ value:CGFloat) -> CGPoint{
        return CGPoint(x: self.x * value, y: self.y * value)
    }
    
    func addX(_ x: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + x, y: self.y)
    }
    
    func hypotenuse() -> CGFloat {
        return CGFloat(sqrt(self.x*self.x + self.y*self.y))
    }
    
    
    func belowLine(point1 p1: CGPoint, point2 p2: CGPoint) -> Bool {
        
        guard p1.x != p2.x else { return self.y < p1.y && self.y < p2.y }
        
        let p = p1.x < p2.x ? [p1,p2] : [p2,p1]
        
        if self.x == p[0].x {
            return self.y < p[0].y
        } else if self.x == p[1].x {
            return self.y < p[1].y
        }
        
        let delta = p[1].deltaTo(p[0])
        let slope = delta.y / delta.x
        let myDeltaX = self.x - p[0].x
        let pointOnLineY = slope * myDeltaX + p[0].y
        
        return self.y < pointOnLineY
    }
    
    func aboveLine(point1 p1: CGPoint, point2 p2: CGPoint) -> Bool {
        
        guard p1.x != p2.x else { return self.y > p1.y && self.y > p2.y }
        
        let p = p1.x < p2.x ? [p1,p2] : [p2,p1]
        
        if self.x == p[0].x {
            return self.y > p[0].y
        } else if self.x == p[1].x {
            return self.y > p[1].y
        }
        
        let delta = p[1].deltaTo(p[0])
        let slope = delta.y / delta.x
        let myDeltaX = self.x - p[0].x
        let pointOnLineY = slope * myDeltaX + p[0].y
        
        return self.y > pointOnLineY
    }
    
}


extension UIBezierPath {
    
    convenience init(pointsForLine p: [CGPoint]) {
        self.init()
        
        move(to: p[0])
        
        for i in 0..<p.count {
            addLine(to: p[i])
        }
        
    }
    
    
    convenience init?(catmullRomPoints: [CGPoint], alpha: CGFloat) {
        
        if catmullRomPoints.count < 2 {
            return nil
        } else if catmullRomPoints.count < 3 {
            self.init()
            move(to: catmullRomPoints[0])
            addLine(to: catmullRomPoints[1])
            return
        } else {
            
            var p = [catmullRomPoints[0].addTo(catmullRomPoints[1].deltaTo(catmullRomPoints[0]).multiplyBy(-1))]
            p += catmullRomPoints
            p.append(catmullRomPoints.last!.addTo(catmullRomPoints[catmullRomPoints.count-2].deltaTo(catmullRomPoints[catmullRomPoints.count-1]).multiplyBy(-1)))
            
            
            self.init()
            
            let startIndex = 1
            let endIndex = p.count - 2
            
            for i in startIndex..<endIndex {
                let p0 = p[i-1 < 0 ? p.count - 1 : i - 1]
                let p1 = p[i]
                let p2 = p[(i+1)%p.count]
                let p3 = p[(i+1)%p.count + 1]
                
                let d1 = p1.deltaTo(p0).hypotenuse()
                let d2 = p2.deltaTo(p1).hypotenuse()
                let d3 = p3.deltaTo(p2).hypotenuse()
                
                var b1 = p2.multiplyBy(pow(d1, 2 * alpha))
                b1 = b1.deltaTo(p0.multiplyBy(pow(d2, 2 * alpha)))
                b1 = b1.addTo(p1.multiplyBy(2 * pow(d1, 2 * alpha) + 3 * pow(d1, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
                b1 = b1.multiplyBy(1.0 / (3 * pow(d1, alpha) * (pow(d1, alpha) + pow(d2, alpha))))
                
                var b2 = p1.multiplyBy(pow(d3, 2 * alpha))
                b2 = b2.deltaTo(p3.multiplyBy(pow(d2, 2 * alpha)))
                b2 = b2.addTo(p2.multiplyBy(2 * pow(d3, 2 * alpha) + 3 * pow(d3, alpha) * pow(d2, alpha) + pow(d2, 2 * alpha)))
                b2 = b2.multiplyBy(1.0 / (3 * pow(d3, alpha) * (pow(d3, alpha) + pow(d2, alpha))))
                
                if i == startIndex {
                    move(to: p1)
                }
                
                
                addCurve(to: p2, controlPoint1: b1, controlPoint2: b2)
                
            }
        }
        
    }
    
    
    
    convenience init(hermiteInterpolation points: [CGPoint], tauX: CGFloat = 1/3, tauY: CGFloat = 1/3, bufferRatio: CGFloat? = nil) {
        
        self.init()
        
        guard points.count > 1 else { return }
        guard points.count > 2 else {
            self.move(to: points[0])
            self.addLine(to: points[1])
            return
        }
        
        self.move(to: points.first!)
        let numberOfCurves = points.count - 1
        var prevPoint = points.first!
        
        var currentPoint : CGPoint
        var nextPoint : CGPoint
        var endPoint : CGPoint
        
        for i in 0..<numberOfCurves{
            currentPoint = points[i]
            nextPoint = points[i+1]
            endPoint = nextPoint
            var mx: CGFloat
            var my: CGFloat
            
            var preventCurveX: CGFloat = 1
            var preventCurveY: CGFloat = 1
            
            if i > 0{
                
                mx = (nextPoint.x - prevPoint.x) * 0.5
                my = (nextPoint.y - prevPoint.y) * 0.5
                
                
                if let r = bufferRatio{
                    let ratioX = (currentPoint.x - prevPoint.x)/(nextPoint.x - currentPoint.x)
                    
                    if ratioX > r {
                        preventCurveX = 2/r
                    }
                    
                    let ratioY = (currentPoint.y - prevPoint.y)/(nextPoint.y - currentPoint.y)
                    if ratioY > r {
                        preventCurveY = 2/r
                    }
                }
            } else {
                
                mx = (nextPoint.x - currentPoint.x) * 0.5
                my = (nextPoint.y - currentPoint.y) * 0.5
            }
            
            let controlPoint1 = CGPoint(x: currentPoint.x + mx * tauX * preventCurveX, y: currentPoint.y + my * tauY * preventCurveY)
            
            prevPoint = currentPoint
            currentPoint = nextPoint
            nextPoint = i + 2 > numberOfCurves ? points[0] : points[i+2]
            
            preventCurveX = 1
            preventCurveY = 1
            
            
            if i < numberOfCurves - 1 {
                
                mx = (nextPoint.x - prevPoint.x) * 0.5
                my = (nextPoint.y - prevPoint.y) * 0.5
                
                if let r = bufferRatio{
                    let ratioX = (nextPoint.x - currentPoint.x)/(currentPoint.x - prevPoint.x)
                    
                    if ratioX > r {
                        preventCurveX = 2/r
                    }
                    
                    let ratioY = (nextPoint.y - currentPoint.y)/(currentPoint.y - prevPoint.y)
                    if ratioY > r {
                        preventCurveY = 2/r
                    }
                }
            } else {
                
                
                mx = (currentPoint.x - prevPoint.x) * 0.5
                my = (currentPoint.y - prevPoint.y) * 0.5
                
            }
            
            let controlPoint2 = CGPoint(x: currentPoint.x - mx * tauX * preventCurveX, y: currentPoint.y - my * tauY * preventCurveX)
            
            self.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            
        }
        
        return
    }
    
}
