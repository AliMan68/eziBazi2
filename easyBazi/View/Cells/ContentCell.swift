//
//  ContentCell.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 5/19/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import SafariServices
class  ContentCell: baseCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    let cellWidth:CGFloat = 200.0
    let stackHeight:CGFloat = 30.0
    var postsArray = [Post]()
    let cellId = "contentCell"
    
    var homeVC:HomeViewController!
    var gameArray = [SliderDataObject]()
    var postActivityIndicatorView:UIActivityIndicatorView!
   
    let labelStack:UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.backgroundColor = .backgroundThem
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let dividerView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.alpha = 0.45
        return view
    }()
    var saleLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
//        label.font = self.font
        label.font = UIFont(name: "IRANSans", size: 15)
        label.text = "پست ها"
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
        //present safari vc here
    let safariVC = SFSafariViewController(url: URL(string: "https://www.easyBazi.ir/")!)
    homeVC.present(safariVC, animated: true, completion: nil)
    }
    
    lazy var postCollectionView:UICollectionView = {
        var cvLayout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cvLayout.scrollDirection = .horizontal
        cv.backgroundColor = UIColor.backgroundThem
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = true
        cv.showsHorizontalScrollIndicator = false
//        cv.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -80)
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
        addSubview(postCollectionView)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        postCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        postCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        postCollectionView.topAnchor.constraint(equalTo: labelStack.bottomAnchor ,constant: 16).isActive = true
//        saleCollectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: -8)
        //change scroll direction to RTL
         postCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        //register cell
        postCollectionView.register(ContentCellCell.self, forCellWithReuseIdentifier: cellId)
        //indicator here
        postActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        postCollectionView.backgroundView = postActivityIndicatorView
        postActivityIndicatorView.center = postCollectionView.center
        postActivityIndicatorView.color = .easyBaziTheme
        

    }
    
    
    //fetch data stuff
    override func fetchData() {
        super.fetchData()
        postActivityIndicatorView.startAnimating()
         GetDataForPostCV.getData() {(posts,status) in
                if status == 1{
                    self.postsArray = posts
                    self.postCollectionView.reloadData()
                    OperationQueue.main.addOperation() {
                        self.postActivityIndicatorView.stopAnimating()
                    }
                }else{
                    print("Err in posts Api")
                }
            }

    }
    
    
    //slider data source
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postsArray.count
      }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ContentCellCell
        cell.post = postsArray[indexPath.row]
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        cell.layer.cornerRadius = 5
        return cell
      }
    
    //slider delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: cellWidth, height: frame.size.height - stackHeight - 16)
    }
    
    
}
