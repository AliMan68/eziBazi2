//
//  BottomList.swift
//  EziBazi2
//
//  Created by AliArabgary on 2/19/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//
import UIKit




class BottomListShop: NSObject, UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    let cellId = "StateCellId"
    let cellId2 = "CityCellId"
    let cellHeight:CGFloat = 47
    var states: [State] = []
    var cities: [City] = []
    var isCitiesDataSource : Bool = false
    var shopViewController:ShopVC!
    let blackView = UIView()
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.color(red: 66, green: 62, blue: 57, alpha: 1)
        cv.layer.cornerRadius = 5
        return cv
    }()
    let indicator:UIActivityIndicatorView = {
       var ind = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        ind.color = UIColor.easyBaziTheme
        ind.startAnimating()
        return ind
    }()
    let errorMessage:UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "IRANSans", size: 9)
        label.textColor = UIColor.white
        label.isHidden = true
        label.text = "خطایی رخ داده"
        return label
    }()

    public func getStates(){
        cities.removeAll()
        collectionView.reloadData()
        indicator.startAnimating()
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
       let url =  "\(delegate)/api/states"
        isCitiesDataSource = false
            States.get(url: url, complition: { (states, status) in
                if status == 1{
                    self.cities.removeAll()
                    self.errorMessage.isHidden = true
                    self.states = states
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
                }else{
                    print("some thing wrong in states Api")
                    self.errorMessage.isHidden = false
                }
            })
        showList()
        }
    
    public func getCities(cityId id:Int){
        states.removeAll()
        collectionView.reloadData()
        indicator.startAnimating()
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
          let url =  "\(delegate)/api/state/\(shopViewController.currentStateId!)/cities"
        isCitiesDataSource = true
        States.getCities(url:url,complition: { (cities, status) in
                if status == 1{
//                    self.states.removeAll()
                    self.errorMessage.isHidden = true
                    self.cities = cities
                    self.indicator.stopAnimating()
                    self.collectionView.reloadData()
                }else{
                    print("some thing wrong in states Api")
                    self.errorMessage.isHidden = false
                }
            })
        showList()
    }
    
    
    public func showList(){
        collectionView.addSubview(errorMessage)
        errorMessage.center = collectionView.center
        self.collectionView.backgroundView = self.indicator
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.alpha = 0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            window.addSubview(blackView)
            blackView.frame = window.frame
            window.addSubview(collectionView)
            let yPosition = window.frame.height * 0.35
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height * 0.65)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame =  CGRect(x: 0, y: yPosition, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    @objc func dismiss() {
        UIView.animate(withDuration: 0.7, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCitiesDataSource{
            return cities.count
        }else{
            return states.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tempCell:UICollectionViewCell!
        if isCitiesDataSource{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! CityCell
            tempCell = cell
            cell.label.text = cities[indexPath.row].name
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StateCell
            tempCell = cell
            cell.label.text = states[indexPath.row].name
        }
        return tempCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isCitiesDataSource{
            shopViewController.city.text = cities[indexPath.row].name
            shopViewController.currentCityId = cities[indexPath.row].id
            
        }else{
            shopViewController.state.text = states[indexPath.row].name
            shopViewController.city.text = ""
            shopViewController.currentStateId = states[indexPath.row].id
            shopViewController.selectCityBtn.layer.opacity = 1
            shopViewController.selectCityBtn.layer.borderColor = UIColor.easyBaziTheme.cgColor
      
        }
        dismiss()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StateCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CityCell.self, forCellWithReuseIdentifier: cellId2)
        collectionView.layer.cornerRadius = 10
    }
}





