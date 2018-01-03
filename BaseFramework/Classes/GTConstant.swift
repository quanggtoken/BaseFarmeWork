//
//  GTConstant.swift
//  BaseProject
//
//  Created by quangle on 1/2/18.
//  Copyright © 2018 Gtoken. All rights reserved.
//

import Foundation
import UIKit

// TODO: Define constant will use in app
let GT_IS_DEV                       = true
let GT_IS_LOG                       = true
let GT_TIME_OUT:Double              = 10
let GT_MINIMUM_STRING_LENGTH        = 1
let GT_MAXIMUM_STRING_LENGTH        = Int.max

/**
 Private key hash length for encode controller data
 */
let GT_LENGTH_OF_STRING_KEY         = 20

let GT_PREFIX                       = "gtoken_"

let GT_LINK_REGEXR                  = "<a\\s+[^>]*href=\"([^\"]*)\"[^>]*>"
let GT_USERNAME_REGEXR              = "^[a-z']{2,10}$"
let GT_PASSWORD_REGEXR              = ""

let GT_DEV_SERVER_URL               = "http://wipco.is.my/api/"
let GT_PROD_SERVER_URL              = "http://wipco.is.my/api/"
let GT_BIRTHDAY_FORMAT_URL          = "yyyy-MM-dd"

let GT_CLIENT_KEY                   = ""
let GT_PRIVATE_KEY                  = ""

/**
  Private key for encode data
 */
let GT_HASH_KEY                     = "azpkxEx`ZaR#v[du=]V?O?T=`yGBL3*e s9%f2D>z.^P|i.fMy9_f:-yz{<F/US="

/**
 Private key for encode form data
 */
let GT_NONCE_KEY                    = "LuqN}6DLCN:#!bw+NpK)Ogov[)2pO`Y;().|vu uR ds w=k(:7G4`!=#xrh7nM."

/**
 Time for cache alive. Defaul is a week
 */
let GT_CACHE_EXPIRATE_TIME          = 60*60*24*7

/**
 Maximum size of cache. Defaul is 50 Mbs
 */
let GT_MAXIMUM_CACHE_SIZE           = 1024*1024*50

/**
 Cache path
 */
let GT_CACHE_PATH                   = "gtoken.private.cache"

/**
 Cache queue
 */
let GT_CACHE_QUEUE_ID               = "gtoken.private.cache"

/**
 Define api name(url) use in app.
 You need to add more value here.
 This value just a example value.
 
 - Login : for the login api (you need to edit this value)
 */
enum GTAPIName:String {
    case Login                              = "auth/login"
}

/**
 Define custom font name(url) use in app.
 You need to add more value here. This value just a example value.
 If your app don't use custom front, just ignore it.
 
 - SanFrancisco_Text_Bold : for the custom font name (you need to edit this value)
 */
enum GTAppFontNames:String{
    case SanFrancisco_Text_Bold             = "SanFranciscoText-Bold"
}

/**
 Define default layout margin
 */
typealias GTAppMargin = (left:CGFloat, right:CGFloat, top:CGFloat, bottom:CGFloat)

/**
 Define default controller data
 */
typealias GTControllerInfo = (storyboard_name:String, controller_id:String, contoller_data_hash:String, show_navi:Bool)

/**
 Define controller name use in app.
 You need to add more value here. This value just a example value.
 
 - RootViewController : for the root view controller
 - LancherViewController : example view controller (need edit it)
 - SignInViewController : example view controller (need edit it)
 */
enum GTAppController {
    case RootViewController
    case LancherViewController
    case SignInViewController
    func controllerInfo()->GTControllerInfo{
        switch self {
        case .RootViewController:
            return ("MainApp","RootViewController", GTToolKit.shareInstance.keyHashFroContronller(fromName: "RootViewController"), false)
        case .LancherViewController:
            return ("MainApp","LancherViewController", GTToolKit.shareInstance.keyHashFroContronller(fromName: "LancherViewController"), false)
        case .SignInViewController:
            return ("MainApp","SignInViewController", GTToolKit.shareInstance.keyHashFroContronller(fromName: "SignInViewController"), false)
        }
    }
}

