//
//  CustomButton.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/04/17.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0{
           didSet{
           self.layer.cornerRadius = cornerRadius
           }
       }

       @IBInspectable var borderWidth: CGFloat = 0{
           didSet{
               self.layer.borderWidth = borderWidth
           }
       }

       @IBInspectable var borderColor: UIColor = UIColor.clear{
           didSet{
               self.layer.borderColor = borderColor.cgColor
           }
       }

}
