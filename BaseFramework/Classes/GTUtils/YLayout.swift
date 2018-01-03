//
//  YLayout.swift
//  CoinATM
//
//  Created by quangle on 12/11/17.
//  Copyright © 2017 quangle. All rights reserved.
//

import Foundation
import UIKit

typealias GTMargin = (left:CGFloat, top:CGFloat, right:CGFloat, bottom:CGFloat)

enum YPhoneInfo:Int {
    case iPhoneX
    case iPhoneFiveInch
    case iphoneFourInch
    case iphoneOlder
    func iphoneDescription() -> (width: CGFloat, height: CGFloat, statusbar: CGFloat, info: String, source_name:String){
        switch self {
            case .iPhoneX :
                return (375, 812, 30, "iphone X", "_x")
            case .iPhoneFiveInch  :
                return (414, 736, 20, "iphone 5.5 inches. Ex 6+, 6s+, 7+, 8+", "")
            case .iphoneFourInch :
                return (375, 667, 20, "iphone 4.7 inches. Ex 6, 6s, 7, 8", "")
            case .iphoneOlder :
                return (320, 568, 20, "iphone 4 inches. Ex 5, 5s, 5c, SE", "")
        }
    }
}

enum YPhoneLabel:String{
    case iphoneX = "_iphoneX"
    case iPhoneFiveInch = "_iphone5"
    case iphoneFourInch = "_iphone4"
    case iphoneOlder = "_iphone"
}

struct YLayoutInfo {
    var screen_size = CGRect()
    var current_orientation:UIDeviceOrientation = .portrait
    var base_screen_desgin = YPhoneInfo.iphoneOlder
    var current_device_info = YPhoneInfo.iphoneOlder
    var sx:CGFloat = 1
    var sy:CGFloat = 1
    var status_bar_height:CGFloat = 20
    var suffix_resource:String = ""
    var device_label = YPhoneLabel.iphoneOlder.rawValue
    
    private typealias PhoneInfo = (width: CGFloat, height: CGFloat, statusbar: CGFloat, info: String, source_name:String)
    
    init(withBaseDesign info:YPhoneInfo){
        base_screen_desgin = info
        self.updateLayoutInfo()
        self.getCurrentiPhoneInfo()
    }
    
    mutating func imageSource(FromName name:String) -> UIImage {
        let arr = name.components(separatedBy: ".")
        if arr.count <= 1 {
            return UIImage(named: "\(name)\(self.device_label)\(self.suffix_resource)")!
        }
        else {
            let new_name = "\(arr[0])\(self.device_label)\(self.suffix_resource).\(arr[1])"
            return UIImage(named: new_name)!
        }
    }
    
    private mutating func getCurrentiPhoneInfo(){
        let area = screen_size.size.width*screen_size.size.height
        if let phone = YPhoneInfo.iPhoneX.iphoneDescription() as PhoneInfo?, phone.width*phone.height == area {
            current_device_info = .iPhoneX
            device_label = YPhoneLabel.iphoneX.rawValue
            self.sx = current_device_info.iphoneDescription().width/base_screen_desgin.iphoneDescription().width
            self.sy = current_device_info.iphoneDescription().height/base_screen_desgin.iphoneDescription().height
        }
        else if let phone = YPhoneInfo.iPhoneFiveInch.iphoneDescription() as PhoneInfo?, phone.width*phone.height == area {
            current_device_info = .iPhoneFiveInch
            device_label = YPhoneLabel.iPhoneFiveInch.rawValue
            self.sx = current_device_info.iphoneDescription().width/base_screen_desgin.iphoneDescription().width
            self.sy = current_device_info.iphoneDescription().height/base_screen_desgin.iphoneDescription().height
        }
        else if let phone = YPhoneInfo.iphoneFourInch.iphoneDescription() as PhoneInfo?, phone.width*phone.height == area {
            current_device_info = .iphoneFourInch
            device_label = YPhoneLabel.iphoneFourInch.rawValue
            self.sx = current_device_info.iphoneDescription().width/base_screen_desgin.iphoneDescription().width
            self.sy = current_device_info.iphoneDescription().height/base_screen_desgin.iphoneDescription().height
        }
    }
    
    private mutating func updateLayoutInfo(){
        current_orientation = UIDevice.current.orientation
        screen_size = UIScreen.main.bounds
        switch current_orientation {
        case .unknown, .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            self.portraitLayoutInfo()
        default:
            self.landcapseLayoutInfo()
        }
    }
    
    private mutating func landcapseLayoutInfo(){
        let device_info = base_screen_desgin.iphoneDescription()
        sx = screen_size.size.width/device_info.height
        sy = screen_size.size.height/device_info.width
        status_bar_height = 20
        suffix_resource = "_land"
    }
    
    private mutating func portraitLayoutInfo(){
        let device_info = base_screen_desgin.iphoneDescription()
        sx = screen_size.size.width/device_info.width
        sy = screen_size.size.height/device_info.height
        suffix_resource = "_port"
        
        let iphonex = YPhoneInfo.iPhoneX.iphoneDescription()
        if screen_size.height >= iphonex.height {
            status_bar_height = iphonex.statusbar
        }
        else {
            status_bar_height = 20
        }
    }
}
