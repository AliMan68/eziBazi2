//
//  SaleCell.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 5/17/20.
//  Copyright © 2020 AliArabgary. All rights reserved.

import UIKit
import FSPagerView
import SafariServices

class SaleCell: baseCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {


    let cellWidth:CGFloat = 125.0
    let cellHeight:CGFloat = 185.0
    let stackHeight:CGFloat = 30.0
    var saleGameArray = [Game]()
    let cellId = "saleCell"
    var homeVC:HomeViewController!
    var gameArray = [SliderDataObject]()
    var saleActivityIndicatorView:UIActivityIndicatorView!

    let dividerView:UIView = {
            var view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 5
            view.alpha = 0.45
            return view
        }()
    let labelStack:UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.backgroundColor = .backgroundThem
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    var saleLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
//        label.font = self.font
        label.font = UIFont(name: "IRANSans", size: 15)
        label.text = "فروشی ها"
        return label
    }()
    
    var moreLabel:UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.titleLabel!.textColor = .easyBaziTheme
        btn.titleLabel?.textAlignment = .left
        btn.backgroundColor = .backgroundThem
        btn.setTitle("بیشتر", for: .normal)
        btn.setTitleColor(.easyBaziTheme, for: .normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans-Bold", size: 15)
        return btn
        }()
   @objc func handleMoreButton(){
        //present sale vc here
    print("more btn clicked...")
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
     let destination = storyboard.instantiateViewController(withIdentifier: "saleVC") as? SaleViewController
    homeVC.navigationController?.pushViewController(destination!, animated: true)
    }
    
    lazy var saleCollectionView:UICollectionView = {
        var cvLayout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cvLayout.scrollDirection = .horizontal
        cvLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        cv.backgroundColor = UIColor.backgroundThem
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    override func setupViews() {
        super.setupViews()
        setupStackView()
        setupCollectionView()
    }
    
    fileprivate func setupStackView(){
        addSubview(labelStack)
        addSubview(dividerView)
     
    
        labelStack.addArrangedSubview(moreLabel)
        labelStack.addArrangedSubview(saleLabel)
        moreLabel.addTarget(self, action: #selector(handleMoreButton), for: .touchDown)
        labelStack.topAnchor.constraint(equalTo: topAnchor ,constant: 16).isActive = true
        labelStack.leftAnchor.constraint(equalTo: leftAnchor ,constant: 16).isActive = true
        labelStack.rightAnchor.constraint(equalTo: rightAnchor ,constant: -8).isActive = true
        labelStack.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
           //divider here
        dividerView.topAnchor.constraint(equalTo: labelStack.topAnchor ,constant: -8).isActive = true
        dividerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dividerView.rightAnchor.constraint(equalTo: rightAnchor ,constant: -8).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
           
    }
    
    fileprivate func setupCollectionView(){
        addSubview(saleCollectionView)
        saleCollectionView.delegate = self
        saleCollectionView.dataSource = self
        saleCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        saleCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        saleCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        saleCollectionView.topAnchor.constraint(equalTo: labelStack.bottomAnchor ,constant: 16).isActive = true
//        saleCollectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: -8)
        //change scroll direction to RTL
        saleCollectionView.semanticContentAttribute = .forceLeftToRight
        //register cell
        saleCollectionView.register(SaleCellCell.self, forCellWithReuseIdentifier: cellId)
        //indicator here
        saleActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        saleCollectionView.backgroundView = saleActivityIndicatorView
        saleActivityIndicatorView.center = saleCollectionView.center
        saleActivityIndicatorView.color = .easyBaziTheme
    }
    
    //fetch data stuff
    override func fetchData() {
        super.fetchData()
        saleActivityIndicatorView.startAnimating()
        GetDataForSaleCV.getData() {(games,status) in
            if status == 1 {
                self.saleGameArray = games
                self.saleCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                self.saleCollectionView.reloadData()
               
                OperationQueue.main.addOperation() {
                self.saleActivityIndicatorView.stopAnimating()
                }
            }else{
                print("Error in getder,SaleCell")
            }
        }
    }
    
    
    //slider data source
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        saleGameArray.count
      }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SaleCellCell
        cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        cell.game = saleGameArray[indexPath.row]
//        cell.layer.cornerRadius =
        cell.clipsToBounds = true
        return cell
      }
    
    //slider delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
      let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
        destination?.game = saleGameArray[indexPath.row]
        destination?.isForRent = false
        destination?.isSecondHand = false
        homeVC.navigationController?.pushViewController(destination!, animated: true)
    }
    
}
