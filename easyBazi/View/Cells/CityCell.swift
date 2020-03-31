//
//  CityCell.swift
//  EziBazi2
//
//  Created by AliArabgary on 3/5/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
class CityCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.color(red: 66, green: 62, blue: 57, alpha: 1)
            label.textColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
    override var isSelected: Bool{
        didSet{
            label.textColor = isSelected ? UIColor.black : UIColor.white
        }
    }
    let label:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 13)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    let divider : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.easyBaziTheme
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(divider)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        label.widthAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
