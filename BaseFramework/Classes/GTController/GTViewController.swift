//
//  GTViewController.swift
//  BaseProject
//
//  Created by quangle on 1/2/18.
//  Copyright © 2018 Gtoken. All rights reserved.
//

import UIKit

class GTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Create New UI
     */
    func initControllerUI(){
        self.view.frame = UIScreen.main.bounds
    }
    
    /**
     Layout UI
     */
    func layoutController(){
        
    }
    
    /**
     Setting Navi UI
     */
    func settingNavigationUI(){
        
    }
    
    /**
     Show Loading
     */
    func showLoading(){
        self.view.isUserInteractionEnabled = false
        self.view.alpha = 0.4
    }
    
    /**
     Hide Loading
     */
    func hideLoading(){
        self.view.isUserInteractionEnabled = true
        self.view.alpha = 1
    }
    /**
     Update UI when Internet Conection Status Change
     */
    func internetStatusChange(){
        
    }
    
    func getControllerName()-> GTAppController {
        return .RootViewController
    }
    
    func getPrevControllerName()-> GTAppController {
        return .RootViewController
    }
    
    func getNextControllerName() -> GTAppController {
        return .RootViewController
    }
}
