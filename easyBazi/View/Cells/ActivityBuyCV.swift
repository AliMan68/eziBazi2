//
//  ActivityBuyCV.swift
//  EziBazi2
//
//  Created by AliArabgary on 3/27/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import UIKit

class ActivityBuyCV:baseCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    
    lazy var collectionView:UICollectionView = {
        var cvLayout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cvLayout.scrollDirection = .vertical
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        return cv
    }()
    var indicator:UIActivityIndicatorView!
    var data = [BuyedGameData]()
    let cellId = "cellId"
    let buyedCellId = "buyedCellId"
    var tabBarHeight:CGFloat?
    var noData:UILabel!
    var plzLogIn:UILabel!
    fileprivate func configeLabels() {
        noData = UILabel()
        plzLogIn = UILabel()
        noData.textColor = .white
        plzLogIn.textColor = .white
        noData.text = "موردی وجود ندارد."
        plzLogIn.text = "لطفا وارد حساب کاربری خود شوید."
        plzLogIn.font = UIFont(name: "IRANSans", size: 16)
        noData.font = UIFont(name: "IRANSans", size: 16)
        noData.textAlignment = .center
        plzLogIn.textAlignment = .center
    }
    override func setupViews() {
        super.setupViews()
        configeLabels()
        backgroundColor = .green
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.backgroundThem

        collectionView.topAnchor.constraint(equalTo: topAnchor ).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ActivityBuyCell.self, forCellWithReuseIdentifier: buyedCellId)
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    override func observer() {
        super.observer()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "userLogout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "userShoped"), object: nil)
    }
    //get data from server here
    @objc override func fetchData(){
        super.fetchData()
        data.removeAll()
        collectionView.reloadData()
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.startAnimating()
        indicator.color = UIColor.easyBaziTheme
        indicator.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundView = indicator
        // check is user loged in here
        if getToken() != "" {
            BuyActivity.Get(token:getToken()) { (status, games) in
                if status == 1 {
                    if games.count != 0 {
                        self.data = games
//                        self.data.reverse()
                        self.indicator.stopAnimating()
                        self.collectionView.reloadData()
                    }else{
                        self.collectionView.backgroundView = self.noData
                    }
                }else{
                    print("Error in rented games")
                }
            }
        }else{
            collectionView.backgroundView = plzLogIn
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buyedCellId, for: indexPath) as! ActivityBuyCell
        let game = data[indexPath.row]
        cell.game = game
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // height = image + price container height + margins
        return .init(width: frame.width - 25, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    
}

