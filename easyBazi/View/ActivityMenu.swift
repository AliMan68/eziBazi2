//
//  ActivityMenu.swift
//  EziBazi2
//
//  Created by AliArabgary on 3/25/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//


import UIKit
class ActivityMenu: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var activityController: ActivityViewController?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.layer.cornerRadius = 2
        horizontalBarView.backgroundColor = UIColor.easyBaziTheme
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        activityController?.scrollToMenuIndex(menuIndex: indexPath.item , cv:collectionView)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.darkGray
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["اجاره شده ها", "خریداری شده ها"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
        setupHorizontalBar()
        backgroundColor = .red
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.label.text = imageNames[indexPath.item]
        cell.tintColor = UIColor.color(red: 91, green: 14, blue: 13, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: baseCell {
    let label: UILabel = {
        let iv = UILabel()
        iv.tintColor = UIColor.color(red: 91, green: 14, blue: 13, alpha: 1)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.font = UIFont(name: "IRANSans", size: 14)
        iv.textColor = UIColor.lightGray
        iv.textAlignment = .center
        return iv
    }()

    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? UIColor.white : UIColor.lightGray
        }
    }

    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? UIColor.white : UIColor.lightGray
        }
    }

    override func setupViews() {
        super.setupViews()

        addSubview(label)
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

}

