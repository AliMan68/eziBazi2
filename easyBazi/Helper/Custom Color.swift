//
//  Custom Color.swift
//  EziBazi2
//
//  Created by AliArabgary on 2/19/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func color (red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat)->UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    static let easyBaziTheme = UIColor(red: 255/255, green: 90/255, blue: 20/255, alpha: 1)
    static let easyBaziThemeAlphaHalf = UIColor(red: 255/255, green: 90/255, blue: 20/255, alpha: 0.5)
    static let notAvailable = UIColor(red: 255/255, green: 0/255, blue: 68/255, alpha: 1)
    static let Available = UIColor(red: 0/255, green: 149/255, blue: 59/255, alpha: 1)
    static let navAndTabColor = UIColor(red: 14/255, green: 22/255, blue: 33/255, alpha: 0.8)
    static let backgroundThem = UIColor.color(red: 18, green: 38, blue: 57, alpha: 1)
    static let easyBaziGreen = UIColor.color(red: 0, green: 143, blue: 0, alpha: 1)
//    static let activityCardBackgroung = UIColor.color(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
}
