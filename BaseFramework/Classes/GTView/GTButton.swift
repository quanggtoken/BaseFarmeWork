//
//  GTButton.swift
//  CoinATM
//
//  Created by quangle on 12/11/17.
//  Copyright © 2017 quangle. All rights reserved.
//

import UIKit

enum GTButtonState {
    case normal
    case highlight
    case selected
}

enum GTButtonContentAligment{
    case center
    case custom
}

class GTButton: UIView {
    var button_state:GTButtonState = .normal
    var button_name:String = ""
    var button_tag:String = ""
    
    private typealias GTButtonBorder = (width:CGFloat, color:UIColor, radius:CGFloat)
    private typealias GTButtonMargin = (left:CGFloat, top:CGFloat, bottom:CGFloat, right:CGFloat)
    private typealias GTButtonGradient = (begin_color:UIColor, end_color:UIColor)
    private typealias GTButtonBackgroundColor = (normal:UIColor, hightlight:UIColor, selected:UIColor)
    
    private var button_content_aligment:GTButtonContentAligment = .center
    private var button_label_normal:UILabel?
    private var button_label_highlight:UILabel?
    private var button_label_selected:UILabel?
    private var button_icon_normal:UIImageView?
    private var button_icon_highlight:UIImageView?
    private var button_icon_selected:UIImageView?
    private var button_gradient_view:GTLinearGradientView?
    private var button_gradient_color_normal:GTButtonGradient?
    private var button_gradient_color_highlight:GTButtonGradient?
    private var button_gradient_color_selected:GTButtonGradient?
    private var button_background_color:GTButtonBackgroundColor = (UIColor.clear, UIColor.clear, UIColor.clear)
    private var button_border_normal:GTButtonBorder?
    private var button_border_highlight:GTButtonBorder?
    private var button_border_selected:GTButtonBorder?
    private var button_icon_margin:GTButtonMargin = (5,5,5,5)
    private var button_content_margin:GTButtonMargin = (5,5,5,5)
    private var is_touch_start:Bool = false
    private var is_init_step:Bool = true
    private var target:AnyObject?
    private var action:Selector?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(BackgroundColor color:UIColor, state:GTButtonState){
        switch state {
        case .normal:
            self.button_background_color.normal = color
            self.backgroundColor = color
        case .highlight:
            self.button_background_color.hightlight = color
        case .selected:
            self.button_background_color.selected = color
        }
    }
    
    func add(GradientColor begin:UIColor, end:UIColor, state:GTButtonState){
        switch state {
        case .normal:
            self.button_gradient_color_normal = (begin,end)
        case .highlight:
            self.button_gradient_color_highlight = (begin,end)
        case .selected:
            self.button_gradient_color_selected = (begin,end)
        }
        
        self.button_gradient_view = GTLinearGradientView.init(beginColor: begin, endColor: end, frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.button_gradient_view?.isUserInteractionEnabled = false
        self.button_gradient_view?.isHidden = true
        self.addSubview(self.button_gradient_view!)
        self.sendSubview(toBack: self.button_gradient_view!)
    }
    
    func add(Target target:AnyObject, action:Selector){
        self.target = target
        self.action = action
    }
    
    func add(ContentAligment aligment:GTButtonContentAligment, left:CGFloat = 5, top:CGFloat = 5, bottom:CGFloat = 5, right:CGFloat = 5){
        self.button_content_aligment = aligment
        self.button_content_margin = (left, top, bottom, right)
    }
    
    func add(IconMargin left:CGFloat, top:CGFloat, bottom:CGFloat, right:CGFloat){
        self.button_icon_margin = (left, top, bottom, right)
    }
    
    func add(IconImage image:UIImage, size:CGSize, state:GTButtonState){
        switch state {
        case .normal:
            if let img_view = self.button_icon_normal {
                img_view.image = image
                img_view.frame.size = size
            }
            else {
                self.button_icon_normal = UIImageView(image: image)
                self.button_icon_normal?.frame.size = size
                self.button_icon_normal!.isHidden = false
                self.button_icon_normal!.isUserInteractionEnabled = false
                self.addSubview(self.button_icon_normal!)
            }
        case .highlight:
            if let img_view = self.button_icon_highlight {
                img_view.image = image
                img_view.frame.size = size
            }
            else {
                self.button_icon_highlight = UIImageView(image: image)
                self.button_icon_highlight?.frame.size = size
                self.button_icon_highlight!.isHidden = true
                self.button_icon_highlight!.isUserInteractionEnabled = false
                self.addSubview(self.button_icon_highlight!)
            }
        case .selected:
            if let img_view = self.button_icon_selected {
                img_view.image = image
                img_view.frame.size = size
            }
            else {
                self.button_icon_selected = UIImageView(image: image)
                self.button_icon_selected?.frame.size = size
                self.button_icon_selected!.isHidden = true
                self.button_icon_selected!.isUserInteractionEnabled = false
                self.addSubview(self.button_icon_selected!)
            }
        }
    }
    
    func addLabel(text:String, font:UIFont, color:UIColor , textAlignment:NSTextAlignment, state:GTButtonState){
        switch state {
        case .normal:
            if let lb = self.button_label_normal {
                lb.text = text
                lb.textColor = color
                lb.font = font
                lb.textAlignment = textAlignment
                lb.sizeToFit()
            }
            else {
                // Create new
                self.button_label_normal = UILabel.init()
                self.button_label_normal!.text = text
                self.button_label_normal!.backgroundColor = .clear
                self.button_label_normal!.textColor = color
                self.button_label_normal!.font = font
                self.button_label_normal!.textAlignment = textAlignment
                self.button_label_normal!.sizeToFit()
                self.button_label_normal!.isHidden = false
                self.button_label_normal!.isUserInteractionEnabled = false
                self.addSubview(self.button_label_normal!)
            }
        case .highlight:
            if let lb = self.button_label_highlight {
                lb.text = text
                lb.textColor = color
                lb.font = font
                lb.textAlignment = textAlignment
                lb.sizeToFit()
            }
            else {
                // Create new
                self.button_label_highlight = UILabel.init()
                self.button_label_highlight!.text = text
                self.button_label_highlight!.textColor = color
                self.button_label_highlight!.font = font
                self.button_label_highlight!.backgroundColor = .clear
                self.button_label_highlight!.textAlignment = textAlignment
                self.button_label_highlight!.sizeToFit()
                self.button_label_highlight!.isHidden = true
                self.button_label_highlight!.isUserInteractionEnabled = false
                self.addSubview(self.button_label_highlight!)
            }
        case .selected:
            if let lb = self.button_label_selected {
                lb.text = text
                lb.textColor = color
                lb.font = font
                lb.textAlignment = textAlignment
                lb.sizeToFit()
            }
            else {
                // Create new
                self.button_label_selected = UILabel.init()
                self.button_label_selected!.text = text
                self.button_label_selected!.textColor = color
                self.button_label_selected!.font = font
                self.button_label_selected!.textAlignment = textAlignment
                self.button_label_selected!.sizeToFit()
                self.button_label_selected!.isHidden = true
                self.button_label_selected!.isUserInteractionEnabled = false
                self.addSubview(self.button_label_selected!)
            }
        }
    }
    
    func add(BorderWidth borderWidth:CGFloat, borderColor:UIColor, radius:CGFloat, state:GTButtonState){
        switch state {
        case .normal:
            self.button_border_normal = (borderWidth, borderColor, radius)
        case .highlight:
            self.button_border_highlight = (borderWidth, borderColor, radius)
        case .selected:
            self.button_border_selected = (borderWidth, borderColor, radius)
        }
    }
    
    func refresh(){
        button_state = .normal
        self.setNeedsDisplay()
    }
    
    private func setButtonState(state:GTButtonState){
        button_state = state
        self.setNeedsDisplay()
    }
    
    private func doButtonAction(){
        self.isUserInteractionEnabled = false
        if let target_obj = self.target{
            if let action_obj = self.action {
                if target_obj.responds(to: action_obj) {
                    _ = target_obj.perform(action_obj, with: self)
                }
            }
        }
        self.isUserInteractionEnabled = true
    }
    
    private func drawLayout(){
        switch self.button_state {
        case .normal:
            self.button_icon_selected?.isHidden = true
            self.button_label_selected?.isHidden = true
            self.button_icon_highlight?.isHidden = true
            self.button_label_highlight?.isHidden = true
            self.button_icon_normal?.isHidden = false
            self.button_label_normal?.isHidden = false
            if let border = self.button_border_normal {
                self.layer.borderWidth = border.width
                self.layer.borderColor = border.color.cgColor
                self.layer.cornerRadius = border.radius
            }
            else {
                self.layer.borderWidth = 0
                self.layer.cornerRadius = 0
            }
            
            // Background
            if let color = self.button_gradient_color_normal {
                self.button_gradient_view?.update(BeginColor: color.begin_color, end: color.end_color)
                self.button_gradient_view?.isHidden = false
            }
            else {
                self.button_gradient_view?.isHidden = true
            }
            
            self.backgroundColor = self.button_background_color.normal
            
        case .highlight:
            self.button_icon_selected?.isHidden = true
            self.button_label_selected?.isHidden = true
            self.button_icon_highlight?.isHidden = false
            self.button_label_highlight?.isHidden = false
            self.button_icon_normal?.isHidden = true
            self.button_label_normal?.isHidden = true
            if let border = self.button_border_highlight {
                self.layer.borderWidth = border.width
                self.layer.borderColor = border.color.cgColor
                self.layer.cornerRadius = border.radius
            }
            
            // Background
            if let color = self.button_gradient_color_highlight {
                self.button_gradient_view?.update(BeginColor: color.begin_color, end: color.end_color)
                self.button_gradient_view?.isHidden = false
            }
            
            if !self.button_background_color.hightlight.isEqual(UIColor.clear) {
                self.backgroundColor = self.button_background_color.hightlight
            }
            
        case .selected:
            self.button_icon_selected?.isHidden = false
            self.button_label_selected?.isHidden = false
            self.button_icon_highlight?.isHidden = true
            self.button_label_highlight?.isHidden = true
            self.button_icon_normal?.isHidden = true
            self.button_label_normal?.isHidden = true
            if let border = self.button_border_selected {
                self.layer.borderWidth = border.width
                self.layer.borderColor = border.color.cgColor
                self.layer.cornerRadius = border.radius
            }
            
            // Background
            if let color = self.button_gradient_color_selected{
                self.button_gradient_view?.update(BeginColor: color.begin_color, end: color.end_color)
                self.button_gradient_view?.isHidden = false
            }
            
            if !self.button_background_color.selected.isEqual(UIColor.clear) {
                self.backgroundColor = self.button_background_color.selected
            }
        }
    }
    
    private func configLayout(){
        switch self.button_content_aligment {
        case .center:
            self.configLayoutWithCenter()
        case .custom:
            self.configLayoutWithCustom()
        }
    }
    
    private func configLayoutWithCenter(){
        var p = CGPoint()
        // Normal
        if let lb = self.button_label_normal {
            if let img = self.button_icon_normal {
                p.x = (self.frame.size.width - (img.frame.size.width + self.button_icon_margin.left + self.button_icon_margin.right + lb.frame.size.width))/2
                p.y = (self.frame.size.height - (img.frame.size.height + self.button_icon_margin.top + self.button_icon_margin.bottom))/2
                img.frame.origin = p
                
                p.x = p.x + img.frame.size.width + self.button_icon_margin.right
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                lb.frame.origin = p
            }
            else {
                p.x = (self.frame.size.width - lb.frame.size.width)/2
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                lb.frame.origin = p
            }
        }
        else {
            if let img = self.button_icon_normal {
                p.x = (self.frame.size.width - (img.frame.size.width + self.button_icon_margin.left + self.button_icon_margin.right))/2
                p.y = (self.frame.size.height - (img.frame.size.height + self.button_icon_margin.top + self.button_icon_margin.bottom))/2
                img.frame.origin = p
            }
        }
        
        // HighLight
        if let lb = self.button_label_highlight {
            if let img = self.button_icon_highlight {
                p.x = (self.frame.size.width - (img.frame.size.width + self.button_icon_margin.left + self.button_icon_margin.right + lb.frame.size.width))/2
                p.y = (self.frame.size.height - (img.frame.size.height + self.button_icon_margin.top + self.button_icon_margin.bottom))/2
                img.frame.origin = p
                
                p.x = p.x + img.frame.size.width + self.button_icon_margin.right
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                lb.frame.origin = p
            }
            else {
                p.x = (self.frame.size.width - lb.frame.size.width)/2
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                lb.frame.origin = p
            }
        }
        else {
            if let img = self.button_icon_highlight {
                p.x = (self.frame.size.width - (img.frame.size.width + self.button_icon_margin.left + self.button_icon_margin.right))/2
                p.y = (self.frame.size.height - (img.frame.size.height + self.button_icon_margin.top + self.button_icon_margin.bottom))/2
                img.frame.origin = p
            }
        }
        
        // Selected
        if let lb = self.button_label_selected {
            if let img = self.button_icon_selected {
                p.x = (self.frame.size.width - (img.frame.size.width + self.button_icon_margin.left + self.button_icon_margin.right + lb.frame.size.width))/2
                p.y = (self.frame.size.height - (img.frame.size.height + self.button_icon_margin.top + self.button_icon_margin.bottom))/2
                img.frame.origin = p
                
                p.x = p.x + img.frame.size.width + self.button_icon_margin.right
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                lb.frame.origin = p
            }
            else {
                p.x = (self.frame.size.width - lb.frame.size.width)/2
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                lb.frame.origin = p
            }
        }
        else {
            if let img = self.button_icon_selected {
                p.x = (self.frame.size.width - (img.frame.size.width + self.button_icon_margin.left + self.button_icon_margin.right))/2
                p.y = (self.frame.size.height - (img.frame.size.height + self.button_icon_margin.top + self.button_icon_margin.bottom))/2
                img.frame.origin = p
            }
        }
        
        // Border
        if let border = self.button_border_normal {
            self.layer.borderWidth = border.width
            self.layer.borderColor = border.color.cgColor
            self.layer.cornerRadius = border.radius
        }
        
        // Background
        if let color = self.button_gradient_color_normal {
            self.button_gradient_view?.update(BeginColor: color.begin_color, end: color.end_color)
            self.button_gradient_view?.isHidden = false
        }
        else {
            self.button_gradient_view?.isHidden = true
        }
        
        self.backgroundColor = self.button_background_color.normal
    }
    
    private func configLayoutWithCustom(){
        var p = CGPoint()
        var width:CGFloat = 0
        // Normal
        if let lb = self.button_label_normal {
            if let img = self.button_icon_normal {
                p.x = self.button_content_margin.left + self.button_icon_margin.left
                p.y = self.button_content_margin.top + self.button_icon_margin.top
                img.frame.origin = p
                
                p.x = p.x + img.frame.size.width + self.button_icon_margin.right
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                width = self.frame.width - p.x - self.button_content_margin.right
                lb.frame.origin = p
                lb.frame.size.width = width
            }
            else {
                p.x = self.button_content_margin.left
                p.y = self.button_content_margin.top
                width = self.frame.width - self.button_content_margin.left - self.button_content_margin.right
                lb.frame.origin = p
                lb.frame.size.width = width
            }
        }
        else {
            if let img = self.button_icon_normal {
                p.x = self.button_content_margin.left + self.button_icon_margin.left
                p.y = self.button_content_margin.top + self.button_icon_margin.top
                img.frame.origin = p
            }
        }
        
        // HighLight
        if let lb = self.button_label_highlight {
            if let img = self.button_icon_highlight {
                p.x = self.button_content_margin.left + self.button_icon_margin.left
                p.y = self.button_content_margin.top + self.button_icon_margin.top
                img.frame.origin = p
                
                p.x = p.x + img.frame.size.width + self.button_icon_margin.right
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                width = self.frame.width - p.x - self.button_content_margin.right
                lb.frame.origin = p
                lb.frame.size.width = width
            }
            else {
                p.x = self.button_content_margin.left
                p.y = self.button_content_margin.top
                width = self.frame.width - self.button_content_margin.left - self.button_content_margin.right
                lb.frame.origin = p
                lb.frame.size.width = width
            }
        }
        else {
            if let img = self.button_icon_highlight {
                p.x = self.button_content_margin.left + self.button_icon_margin.left
                p.y = self.button_content_margin.top + self.button_icon_margin.top
                img.frame.origin = p
            }
        }
        
        // Selected
        if let lb = self.button_label_selected {
            if let img = self.button_icon_selected {
                p.x = self.button_content_margin.left + self.button_icon_margin.left
                p.y = self.button_content_margin.top + self.button_icon_margin.top
                img.frame.origin = p
                
                p.x = p.x + img.frame.size.width + self.button_icon_margin.right
                p.y = (self.frame.size.height - lb.frame.size.height)/2
                width = self.frame.width - p.x - self.button_content_margin.right
                lb.frame.origin = p
                lb.frame.size.width = width
            }
            else {
                p.x = self.button_content_margin.left
                p.y = self.button_content_margin.top
                width = self.frame.width - self.button_content_margin.left - self.button_content_margin.right
                lb.frame.origin = p
                lb.frame.size.width = width
            }
        }
        else {
            if let img = self.button_icon_selected {
                p.x = self.button_content_margin.left + self.button_icon_margin.left
                p.y = self.button_content_margin.top + self.button_icon_margin.top
                img.frame.origin = p
            }
        }
        
        // Border
        if let border = self.button_border_normal {
            self.layer.borderWidth = border.width
            self.layer.borderColor = border.color.cgColor
            self.layer.cornerRadius = border.radius
        }
        else {
            self.layer.borderWidth = 0
            self.layer.cornerRadius = 0
        }
        
        // Background
        if let color = self.button_gradient_color_normal {
            self.button_gradient_view?.update(BeginColor: color.begin_color, end: color.end_color)
            self.button_gradient_view?.isHidden = false
        }
        else {
            self.button_gradient_view?.isHidden = true
        }
        
        self.button_icon_normal?.isHidden = true
        self.button_icon_selected?.isHidden = true
        self.button_label_selected?.isHidden = true
        self.button_icon_highlight?.isHidden = true
        self.button_label_highlight?.isHidden = true
        self.button_icon_normal?.isHidden = false
        self.button_label_normal?.isHidden = false
        
        self.backgroundColor = self.button_background_color.normal
    }
    
    //MARK : Touch Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setButtonState(state: .highlight)
        self.is_touch_start = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setButtonState(state: .normal)
        if self.is_touch_start == true {
            self.is_touch_start = false
            self.doButtonAction()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if self.is_init_step == true {
            self.configLayout()
            self.is_init_step = false
        }
        else {
            self.drawLayout()
        }
    }

}
