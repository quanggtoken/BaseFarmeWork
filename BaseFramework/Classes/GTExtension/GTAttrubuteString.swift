//
//  GTAttrubuteString.swift
//  CoinATM
//
//  Created by quangle on 12/11/17.
//  Copyright © 2017 quangle. All rights reserved.
//

import UIKit
import Foundation

extension NSMutableAttributedString{
    static func initFrom(HTML html_string:String) -> NSMutableAttributedString? {
        do {
            let attr = try NSMutableAttributedString(data: html_string.data(using: String.Encoding.utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attr
        }
        catch {
            debugPrint("Cannot make attribute string")
            return nil
        }
    }
    
    static func initFrom(String input_string:String, alignment:NSTextAlignment, font:UIFont, color:UIColor) -> NSMutableAttributedString {
        let paragraph_style = NSMutableParagraphStyle()
        paragraph_style.paragraphSpacing = 0
        paragraph_style.alignment = alignment
        paragraph_style.lineSpacing = 1
        paragraph_style.maximumLineHeight = font.lineHeight
        paragraph_style.minimumLineHeight = font.lineHeight
        
        let attributes_dictionary = [NSAttributedStringKey.font:font,
                                     NSAttributedStringKey.paragraphStyle: paragraph_style,
                                     NSAttributedStringKey.foregroundColor: color]
        
        return NSMutableAttributedString(string: input_string, attributes: attributes_dictionary)
    }
    
    func getAtributeHeight(fromWidth width:CGFloat) -> CGFloat {
        let constrained_size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        let size = self.boundingRect(with: constrained_size, options: .usesLineFragmentOrigin, context: nil)
        return size.height
    }
    
    func getAttributeWidth(fromHeight height:CGFloat) -> CGFloat {
        let constrained_size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
        let size = self.boundingRect(with: constrained_size, options: .usesLineFragmentOrigin, context: nil)
        return size.width
    }
}
