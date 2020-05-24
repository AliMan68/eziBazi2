//
//  SliderCell.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 5/17/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import FSPagerView
import SafariServices

class SliderCell: baseCell,FSPagerViewDelegate,FSPagerViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var homeVC:HomeViewController!
    var sliderArray = [SliderDataObject]()
    var sliderActivityIndicatorView:UIActivityIndicatorView!
   
    let slider:FSPagerView = {
        var slider = FSPagerView(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        slider.automaticSlidingInterval = 3.0
        slider.isInfinite = true
        slider.itemSize = .zero
        //pageView.interitemSpacing = 10
        slider.transformer = FSPagerViewTransformer(type: .depth)
        return slider
    }()
    
    let sliderController:FSPageControl = {
        var controller = FSPageControl(frame: .zero)
        controller.translatesAutoresizingMaskIntoConstraints = false
//        controller.numberOfPages = sliderArray.count
                   controller.contentHorizontalAlignment = .left
        controller.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        controller.hidesForSinglePage = true

        
        return controller
    }()
    
    override func setupViews() {
        super.setupViews()
        setupSlider()
        setupController()
        
    }
    
    fileprivate func setupController(){
        addSubview(sliderController)
        sliderController.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sliderController.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sliderController.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sliderController.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    fileprivate func setupSlider(){
        addSubview(slider)
        slider.delegate = self
        slider.dataSource = self
        slider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        slider.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        //setup slider indicator
        sliderActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        sliderActivityIndicatorView.color = .easyBaziTheme
        slider.backgroundView = sliderActivityIndicatorView
    }
    
    
    //fetch data stuff
    override func fetchData() {
        super.fetchData()
        sliderActivityIndicatorView.startAnimating()
         GetDataForSlider.getData() {(games,status) in
            if status == 1{
                self.sliderArray = games
                self.slider.reloadData()
                self.sliderController.numberOfPages = games.count
                OperationQueue.main.addOperation() {
                    self.sliderActivityIndicatorView.stopAnimating()
                }
            }else{
                print("Status is not 1 in slider api")
            }
        }
    }
    
    
    
    
    //slider data source
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        sliderArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let imageUrl = URL(string:sliderArray[index].photos[0].url)
        if let url = imageUrl {
            cell.imageView?.sd_setImage(with: url , placeholderImage: UIImage(named:"GOW"), completed: nil)
        }else{
            cell.imageView?.image = UIImage(named:"notFound")
        }
        cell.textLabel?.font = self.font
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.text = sliderArray[index].title
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    //slider delegate
    
     func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
            pagerView.deselectItem(at: index, animated: true)
            pagerView.scrollToItem(at: index, animated: true)
            self.sliderController.currentPage = index
//        MOVE TO ANOTHER VIEW WHEN ITEM IN SLIDER CLICKED
    //        let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "webView") as! WebViewController
    //        navigationController?.pushViewController(destination, animated: true)
            let safariVC = SFSafariViewController(url: URL(string: "https://www.easyBazi.ir/")!)
            homeVC.present(safariVC, animated: true, completion: nil)
        }
        //  CHANGE PAGE CONTROLLER CURRENT STATE
    
        func pagerViewDidScroll(_ pagerView: FSPagerView) {
            guard self.sliderController.currentPage != pagerView.currentIndex else {
                return
            }
            self.sliderController.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
        }
    
}
