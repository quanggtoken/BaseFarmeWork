//
//  GTUIImage.swift
//  GtokenBaseFramework
//
//  Created by quangle on 12/7/17.
//  Copyright © 2017 quangle. All rights reserved.
//

import UIKit
import Foundation

extension UIImage{
    func blurredImage(WithRadius radius:CGFloat) -> (UIImage){
        let ciContext = CIContext.init(options: nil)
        let inputImage = CIImage.init(cgImage: self.cgImage!, options: nil)
        let ciFilter = CIFilter.init(name: "CIGaussianBlur")
        ciFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter?.setValue(NSNumber.init(value: Float(radius)), forKey: "inputRadius")
        
        let resultImage:CIImage = ciFilter?.value(forKey: kCIOutputImageKey) as! CIImage
        let cgImage = ciContext.createCGImage(resultImage, from: inputImage.extent)
        return UIImage.init(cgImage: cgImage!)
    }
    
    static func imageFrom(Path path:String?)->UIImage?{
        if let the_path = path {
            let file = the_path.components(separatedBy: ".")
            guard let img_path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return nil
            }
            return UIImage.init(contentsOfFile: img_path)
        }
        else {
            debugPrint( "Empty path")
            return nil
        }
    }
}
