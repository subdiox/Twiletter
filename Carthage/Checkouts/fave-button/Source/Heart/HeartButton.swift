//
//  HeartButton.swift
//  HeartButton
//
// Copyright © 2016 Jansel Valentin.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public protocol HeartButtonDelegate{
    func heartButton(_ heartButton: HeartButton, didSelected selected: Bool)
    
    func heartButtonDotColors(_ heartButton: HeartButton) -> [DotColors]?
}


// MARK: Default implementation
public extension HeartButtonDelegate{
    func heartButtonDotColors(_ heartButton: HeartButton) -> [DotColors]?{ return nil }
}

open class HeartButton: UIButton {
    
    fileprivate struct Const{
        static let duration             = 1.0
        static let expandDuration       = 0.1298 
        static let collapseDuration     = 0.1089
        static let heartIconShowDelay   = Const.expandDuration + Const.collapseDuration / 2.0
        static let dotRadiusFactors     = (first: 0.0633, second: 0.04)
    }
    
    @IBInspectable open var normalColor: UIColor     = UIColor(red: 137/255, green: 156/255, blue: 167/255, alpha: 1)
    @IBInspectable open var selectedColor: UIColor   = UIColor(red: 226/255, green: 38/255,  blue: 77/255,  alpha: 1)
    @IBInspectable open var dotFirstColor: UIColor   = UIColor(red: 152/255, green: 219/255, blue: 236/255, alpha: 1)
    @IBInspectable open var dotSecondColor: UIColor  = UIColor(red: 247/255, green: 188/255, blue: 48/255,  alpha: 1)
    @IBInspectable open var circleFromColor: UIColor = UIColor(red: 221/255, green: 70/255,  blue: 136/255, alpha: 1)
    @IBInspectable open var circleToColor: UIColor   = UIColor(red: 205/255, green: 143/255, blue: 246/255, alpha: 1)
    @IBInspectable open var colorfulDots: Bool = false
    
    @IBOutlet open weak var delegate: AnyObject?
    
    fileprivate(set) var sparkGroupCount: Int = 7
    
    fileprivate var heartIconImage: UIImage?
    fileprivate var heartIcon: HeartIcon!
    
    override open var isSelected: Bool {
        didSet{
            animateSelect(self.isSelected, duration: Const.duration)
        }
    }
    
    convenience public init(frame: CGRect, heartIconNormal: UIImage?) {
        self.init(frame: frame)
        
        guard let icon = heartIconNormal else {
            fatalError("missing image for normal state")
        }
        heartIconImage = icon
        
        applyInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyInit()
    }
}


// MARK: create
extension HeartButton {
    fileprivate func applyInit() {
        
        if nil == heartIconImage {
            heartIconImage = image(for: UIControlState())
        }
        
        guard let heartIconImage = heartIconImage else {
            fatalError("please provide an image for normal state.")
        }
        
        setImage(UIImage(), for: UIControlState())
        setImage(UIImage(), for: .selected)
        setTitle(nil, for: UIControlState())
        setTitle(nil, for: .selected)
        
        heartIcon  = createHeartIcon(heartIconImage)
    }
    
    fileprivate func createHeartIcon(_ heartIconImage: UIImage) -> HeartIcon {
        return HeartIcon.createHeartIcon(self, icon: heartIconImage,color: normalColor)
    }
    
    fileprivate func createHeartSparks(_ radius: CGFloat) -> [HeartSpark] {
        var sparks    = [HeartSpark]()
        let step      = 360.0 / Double(sparkGroupCount)
        let base      = Double(bounds.size.width)
        let dotRadius = (base * Const.dotRadiusFactors.first, base * Const.dotRadiusFactors.second)
        let offset    = 10.0
        
        for index in 0 ..< sparkGroupCount{
            let theta  = step * Double(index) + offset
            let colors = dotColors(atIndex: index)
            
            let spark  = HeartSpark.createHeartSpark(self, radius: radius, firstColor: colors.first,secondColor: colors.second, angle: theta,
                                           dotRadius: dotRadius)
            sparks.append(spark)
        }
        return sparks
    }
    
    fileprivate func dotColors(atIndex index: Int) -> DotColors {
        if case let delegate as HeartButtonDelegate = delegate , nil != delegate.heartButtonDotColors(self){
            let colors     = delegate.heartButtonDotColors(self)!
            let colorIndex = 0..<colors.count ~= index ? index : index % colors.count
            
            return colors[colorIndex]
        }
        if colorfulDots {
            let colors = [
                DotColors(first: UIColor.rgb(0x7DC2F4), second: UIColor.rgb(0xE2264D)),
                DotColors(first: UIColor.rgb(0xF8CC61), second: UIColor.rgb(0x9BDFBA)),
                DotColors(first: UIColor.rgb(0xAF90F4), second: UIColor.rgb(0x90D1F9)),
                DotColors(first: UIColor.rgb(0xE9A966), second: UIColor.rgb(0xF8C852)),
                DotColors(first: UIColor.rgb(0xF68FA7), second: UIColor.rgb(0xF6A2B8))
            ]
            let colorIndex = 0..<colors.count ~= index ? index : index % colors.count
            
            return colors[colorIndex]
        }
        return DotColors(self.dotFirstColor, self.dotSecondColor)
    }
}

// MARK: actions
extension HeartButton {
    open func toggle() {
        isSelected = !isSelected
        self.animateSelect(self.isSelected, duration: 1.0)
    }
}

// MARK: animation
extension HeartButton {
    fileprivate func animateSelect(_ isSelected: Bool, duration: Double) {
        let color  = isSelected ? selectedColor : normalColor
        
        heartIcon.animateSelect(isSelected, fillColor: color, duration: duration, delay: Const.heartIconShowDelay)
        
        if isSelected {
            let radius           = bounds.size.scaleBy(1.7).width / 2 // ring radius
            let igniteFromRadius = radius * 0.85
            let igniteToRadius   = radius * 1.05
            
            let ring = HeartRing.createHeartRing(self, radius: 0.01, lineWidth: 3, fillColor: self.circleFromColor)
            let sparks = createHeartSparks(igniteFromRadius)
            
            ring.animateToRadius(radius, toColor: circleToColor, duration: Const.expandDuration, delay: 0)
            ring.animateColapse(radius, duration: Const.collapseDuration, delay: Const.expandDuration)

            sparks.forEach {
                $0.animateIgniteShow(igniteToRadius, duration:0.4, delay: Const.collapseDuration / 3.0)
                $0.animateIgniteHide(0.7, delay: 0.2)
            }
        }
    }
}
