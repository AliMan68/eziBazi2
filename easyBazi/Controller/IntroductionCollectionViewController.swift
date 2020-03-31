//
//  IntroductionCollectionViewController.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/10/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
let reuseIdentifier = "Cell"

class SwipingController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let prevButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("قبلی", for: .normal)
        btn.alpha = 0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
        btn.setTitleColor(.gray, for: .normal)
        btn.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return btn
    }()
    let nextButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("بعدی", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
        btn.setTitleColor(.easyBaziTheme, for: .normal)
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return btn
    }()
    @objc func handleNext(){
        let nextIndex = min(pageControl.currentPage + 1,2)
        if nextButton.titleLabel?.text == "اتمام" && nextIndex == 2{
            print("moving to main app")
            SVProgressHUD.show()
            SVProgressHUD.dismiss(withDelay: 0.5)
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "homeVC") as? UITabBarController
            destination?.modalPresentationStyle = .fullScreen
            
            self.present(destination!, animated: true, completion: nil)
            
            return
        }
        
        if pageControl.currentPage >= 2 {
            nextButton.setTitle("اتمام", for: .normal)
        }else{
            prevButton.alpha = 1
            nextButton.setTitle("بعدی", for: .normal)
        }
        
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = nextIndex
    }
    @objc func handlePrev(){
        let nextIndex = max(pageControl.currentPage - 1,0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        print(pageControl.currentPage)
        if pageControl.currentPage == 1 {
//            prevButton.setTitle("", for: .normal)
            prevButton.alpha = 0
        }else{
            print("Here We Are")
            prevButton.alpha = 1
            prevButton.setTitle("قبلی", for: .normal)
        }
        if pageControl.currentPage > 2{
            nextButton.setTitle("بعدی", for: .normal)
        }
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = nextIndex
    }
    let pageControl:UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.isEnabled = false
        pc.numberOfPages = 3
        pc.currentPageIndicatorTintColor = .easyBaziTheme
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    var contents1:String!
    var baseUrl1:URL!
    var contents2:String!
    var baseUrl2:URL!
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
        }
            return .default
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomControls()
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.backgroundColor = .clear
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(IntroCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.backgroundThem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         do{
            guard let path1 = Bundle.main.path(forResource: "motorcycle", ofType: "svg")else{ print("Error in reading path"); return}
            contents1 = try String(contentsOfFile: path1, encoding: .utf8)
            baseUrl1 = URL(fileURLWithPath: path1)
            guard let path2 = Bundle.main.path(forResource: "motorcycle", ofType: "svg")else{ print("Error in reading path"); return}
            contents2 = try String(contentsOfFile: path2, encoding: .utf8)
            baseUrl2 = URL(fileURLWithPath: path2)
                }
                catch{
                    print("Err in lading html's")
                }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IntroCell
        if indexPath.row == 0 {
                cell.imageView.loadHTMLString(contents1 as String, baseURL: baseUrl1)
        }else if indexPath.row == 1 {
                cell.imageView.loadHTMLString(contents2 as String, baseURL: baseUrl2)
            return cell
        }
        cell.imageView.loadHTMLString(contents1 as String, baseURL: baseUrl1)
//        print("Row ==>\(indexPath.row)")
//        print("This is Item==>\(indexPath.item)")
//        cell.backgroundColor = indexPath.item % 2 == 0 ? .blue : .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
        
        prevButton.alpha = 1
        if pageControl.currentPage  > 2 {
            nextButton.setTitle("اتمام", for: .normal)
        }else{
            nextButton.setTitle("بعدی", for: .normal)
        }
        print(pageControl.currentPage)
        if pageControl.currentPage == 0{
            prevButton.alpha = 0
        }
    }
    fileprivate func setupBottomControls(){
        let bottomStack = UIStackView(arrangedSubviews: [prevButton,pageControl,nextButton])
        view.addSubview(bottomStack)
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.distribution = .fillEqually
        NSLayoutConstraint.activate([
            bottomStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomStack.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
}
struct html {
    var content:String
    var url:URL
    var title:String
}


