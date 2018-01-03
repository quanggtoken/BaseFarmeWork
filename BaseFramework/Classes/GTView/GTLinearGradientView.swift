//
//  GTLinearGradientView.swift
//  GtokenBaseFramework
//
//  Created by quangle on 12/7/17.
//  Copyright © 2017 quangle. All rights reserved.
//

import UIKit
import CoreGraphics
import Foundation

class GTLinearGradientView:UIView{
    
    private var begin_color: CIColor?
    private var end_clolor:CIColor?
    private var gradient:CGGradient?
    
    init(beginColor:UIColor, endColor:UIColor, frame:CGRect){
        super.init(frame:frame)
        self.begin_color = CIColor.init(color: beginColor)
        self.end_clolor = CIColor.init(color: endColor)
        createGadient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createGadient() -> Void {
        let myColorspace:CGColorSpace = CGColorSpace.init(name:CGColorSpace.sRGB)!
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [(begin_color?.red)!, (begin_color?.green)!, (begin_color?.blue)!, (begin_color?.alpha)!, (end_clolor?.red)!, (end_clolor?.green)!, (end_clolor?.blue)!, (end_clolor?.alpha)!]
        gradient = CGGradient.init(colorSpace: myColorspace, colorComponents: components, locations: locations, count: num_locations)
    }
    
    func updateViewWithFrame(newFrame:CGRect){
        self.frame = newFrame
        self.setNeedsDisplay()
    }
    
    func update(BeginColor begin:UIColor, end:UIColor){
        self.begin_color = CIColor(color: begin)
        self.end_clolor = CIColor(color: end)
        self.createGadient()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.beginPath()
        ctx?.move(to: CGPoint.init(x: 0, y: 0))
        ctx?.addRect(CGRect.init(x: 0, y: 0, width: rect.width, height: rect.height))
        ctx?.clip()
        ctx?.drawLinearGradient(gradient!, start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: rect.width, y: rect.height), options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
}
