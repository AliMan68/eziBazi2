//
//  Activity-RentedGames.swift
//  EziBazi2
//
//  Created by AliArabgary on 3/25/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
class ActivityRentCV:baseCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CollectionViewCellDelegate {
    func renewalButtonPressed(cell: ActivityRentCell) {
        
        activityVC.handleRenewalStaff(activityObject: cell)
    }
    
    var indicator:UIActivityIndicatorView!
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
    var activityVC:ActivityViewController!
    var data = [RentedGameData]()
    let cellId = "cellId"
    let rentedCellId = "rentedCellId"
    var tabBarHeight:CGFloat?
    var noData:UILabel!
    var plzLogIn:UILabel!
    var currentDataCount:Int!
    var isFirstTime:Bool = true
    var rentCell:ActivityRentCell!
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
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.backgroundThem
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ActivityRentCell.self, forCellWithReuseIdentifier: rentedCellId)
    }
    override func observer() {
        super.observer()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "userLogout"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "userRented"), object: nil)
    }
    //get data from server here
    @objc override func fetchData(){
        super.fetchData()
        data.removeAll()
        print("we are in fetchin data Rent")
        collectionView.reloadData()
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.startAnimating()
        indicator.color = UIColor.easyBaziTheme
        indicator.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundView = indicator
        
        // check is user loged in here
        if getToken() != "" {
            RentActivity.Get(token:getToken()) { (status, games) in
                if status == 1{
                    if games.count != 0{
                        self.data = games
                        
//                        self.data.reverse()
                        self.indicator.stopAnimating()
                        self.collectionView.reloadData()
                    }else{
                        self.collectionView.backgroundView = self.noData
                    }
                }else if status == -1 {
                    SVProgressHUD.showError(withStatus: "خطایی در ارتباط با سرور ;(")
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
    fileprivate func buttonBorderAnimation(for button:UIButton) {
//          button.layer.removeAllAnimations()
          let animation1 = CABasicAnimation(keyPath: "borderColor")
          animation1.fromValue = UIColor.cyan.cgColor
          animation1.toValue = UIColor.easyBaziTheme.cgColor
          animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
          animation1.repeatCount = .infinity
          animation1.duration = 1
          animation1.autoreverses = true
          animation1.isRemovedOnCompletion = false
          button.layer.add(animation1, forKey: nil)
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        rentCell = collectionView.dequeueReusableCell(withReuseIdentifier: rentedCellId, for: indexPath) as? ActivityRentCell
        let game = data[indexPath.row]
        rentCell.delegate = self
        rentCell.game = game
        rentCell.layer.cornerRadius = 5
//        buttonBorderAnimation(for: rentCell.renewal)
        return rentCell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ActivityRentCell {
            buttonBorderAnimation(for: cell.renewal)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        // height = image + price container height + renewal button + margins
        return .init(width: frame.width - 25, height: 278	)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
