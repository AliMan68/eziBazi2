//
//  ViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/13/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage
import Reachability
import CoreData
import SafariServices
class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,SFSafariViewControllerDelegate,UICollectionViewDelegateFlowLayout{
    let cellId = "cellId"
    let sliderCellId = "sliderCellId"
    let saleCellId = "saleCellId"
    let contentCellId = "contentCellId"
   let mainCollectionView:UICollectionView = {
          var cvLayout = UICollectionViewFlowLayout()
          cvLayout.scrollDirection = .vertical
//          cvLayout.minimumLineSpacing = 5
    
          cvLayout.sectionInset = .zero
          var cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
          cv.translatesAutoresizingMaskIntoConstraints = false
          cv.showsVerticalScrollIndicator = false
          cv.isPagingEnabled = false
          cv.isDirectionalLockEnabled = false
          cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          cv.bounces = true
          cv.contentInsetAdjustmentBehavior = .never
          cv.tintAdjustmentMode = UIViewTintAdjustmentMode.normal
          cv.backgroundColor = .backgroundThem
          return cv
      }()
    //    func networkStatusDidChange(status: Reachability.Connection) {
//        switch status {
//        case .none:
//            let alert = UIAlertController(title: "هشدار", message: "خطا در اتصال به اینترنت!", preferredStyle: .alert)
//            let action = UIAlertAction(title: "تلاش مجدد", style: .destructive, handler: { (completed) in
//                // send request to server again
//                let saleUrl:String = "\(self.delegate)/api/game-for-shop-index/14"
////                let rentUrl:String = "\(self.delegate)/api/game-for-rent-index/329"
//                let postUrl:String = "\(self.delegate)/api/post"
//
//                print("Sending all request to server again")
//                GetDataForPostCV.getData(postUrl) {(posts,status) in
//                    if status == 1{
//                        self.postArray = posts
//                        self.newsCollectionView.reloadData()
//                        OperationQueue.main.addOperation() {
//                            self.newsActivityIndicatorView.stopAnimating()
//                        }
//                        
//                    }else{
//                        print("Status is not 1 in posts Api")
//                    }
//                }
//                GetDataForSaleCV.getData(saleUrl) {(games,status) in
//                    if status == 1 {
//                        self.saleGameArray = games
//                        self.saleCollectionView.reloadData()
//                        OperationQueue.main.addOperation() {
//                            self.saleActivityIndicatorView.stopAnimating()
//                                            }
//                    }else{
//                        print("Error in getder,home VC")
//                    }
//                }
//           GetDataForSlider.getData(slideUrl) {(games,status) in
//                    if status == 1{
//                        self.sliderArray = games
//                        self.slider.reloadData()
//                        self.sliderController.numberOfPages = games.count
//                        OperationQueue.main.addOperation() {
//                            self.sliderActivityIndicatorView.stopAnimating()
//                        }
//                        
//                    }else{
//                        print("Status is not 1 in slider api")
//                    }
//                }
//            })
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        case .wifi:
//            debugPrint("ViewController: Network reachable through WiFi")
//            
//        case .cellular:
//            debugPrint("ViewController: Network reachable through Cellular Data")
//        case .unavailable:
//        return
//        }
//    }
    var rentTypes:[rentType]? = []
//    @IBOutlet weak var homeContent: UIView!
//    @IBOutlet weak var newsCollectionView: UICollectionView!
//    @IBOutlet weak var saleCollectionView: UICollectionView!
//    @IBOutlet weak var rentCollectionView: UICollectionView!
    
    @IBOutlet weak var weekly: UILabel!
    var delegate = (UIApplication.shared.delegate as! AppDelegate).url
    var saleActivityIndicatorView:UIActivityIndicatorView!
    var rentActivityIndicatorView:UIActivityIndicatorView!
    var newsActivityIndicatorView:UIActivityIndicatorView!
    var sliderActivityIndicatorView:UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
//    @IBOutlet weak var slider: FSPagerView!{
//        didSet {
//            self.slider.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//            slider.automaticSlidingInterval = 3.0
//            slider.isInfinite = true
//            slider.itemSize = .zero
//            //pageView.interitemSpacing = 10
//            slider.transformer = FSPagerViewTransformer(type: .depth)
//        }
//    }
//    @IBOutlet weak var sliderController:FSPageControl!{
//        didSet {
//            self.sliderController.numberOfPages = sliderArray.count
//            self.sliderController.contentHorizontalAlignment = .left
//            self.sliderController.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//            self.sliderController.hidesForSinglePage = true
//        }
//    }
    
    var saleGameArray = [Game]()
    var nextPageUrl:String!
    var rentGameArray = [Game]()
    var postArray = [Post]()
    var font:UIFont!
    var sliderArray = [SliderDataObject]()
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func eraseToken(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                context.delete(data)
                try context.save()
            }
            print("Erasing Seccessfully")
        }catch{
            print("Erasing Error")
        }
    }
     func getRents(_ rentUrl: String) {
        GetDataForRentCV.getData(rentUrl) {(games,status) in
            if status == 1 {
                    self.rentGameArray = games
//                    self.rentCollectionView.reloadData()
                    OperationQueue.main.addOperation() {
                    self.rentActivityIndicatorView.stopAnimating()
                    }
            }else{
                print("Error in rent apt,Home VC")
            }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainCollectioView()
//        getRentTypes()
//        font = UIFont(name: "IRANSans", size: 14)
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        view.backgroundColor = UIColor.backgroundThem
//        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
//            print("Timer is Timing Now !!! Ha ha ha")
//
        // setup new back button for navigation controller
//        self.title = "خانه"
//        let backButton = UIBarButtonItem(title: "بازگشت", style: .done, target: nil, action: nil)
//        self.navigationController?.navigationItem.backBarButtonItem = backButton
        tabBarController?.tabBar.barTintColor = UIColor.navAndTabColor
        tabBarController?.tabBar.isTranslucent = true
//        let saleUrl:String = "\(delegate)/api/game-for-shop-index/14"
////        let rentUrl:String = "\(delegate)/api/game-for-rent-index/14"
//        let postUrl:String = "\(delegate)/api/post"
//        let slideUrl:String = "\(delegate)/api/slider"
        navigationController?.navigationBar.tintColor = UIColor.easyBaziTheme
//        saleActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        rentActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        newsActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        sliderActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        saleActivityIndicatorView.color = .easyBaziTheme
//        rentActivityIndicatorView.color = .easyBaziTheme
//        newsActivityIndicatorView.color = .easyBaziTheme
//        sliderActivityIndicatorView.color = .easyBaziTheme
//        slider.backgroundView = sliderActivityIndicatorView
//        saleCollectionView.backgroundView = saleActivityIndicatorView
////        rentCollectionView.backgroundView = rentActivityIndicatorView
//        newsCollectionView.backgroundView = newsActivityIndicatorView
//        saleActivityIndicatorView.startAnimating()
//        sliderActivityIndicatorView.startAnimating()
//        rentActivityIndicatorView.startAnimating()
//        newsActivityIndicatorView.startAnimating()
//        GetDataForSlider.getData() {(games,status) in
//            if status == 1{
//                self.sliderArray = games
//                self.slider.reloadData()
//                self.sliderController.numberOfPages = games.count
//                OperationQueue.main.addOperation() {
//                    self.sliderActivityIndicatorView.stopAnimating()
//                }
//
//            }else{
//                print("Status is not 1 in slider api")
//            }
//        }
//        GetDataForPostCV.getData(postUrl) {(posts,status) in
//            if status == 1{
//                self.postArray = posts
//                self.newsCollectionView.reloadData()
//                OperationQueue.main.addOperation() {
//                    self.newsActivityIndicatorView.stopAnimating()
//                }
//            }else{
//                print("Status is not 1 in posts Api")
//            }
//        }
//        GetDataForSaleCV.getData(saleUrl) {(games,status) in
//           if status == 1 {
//               self.saleGameArray = games
//               self.saleCollectionView.reloadData()
//               OperationQueue.main.addOperation() {
//                   self.saleActivityIndicatorView.stopAnimating()
//                                   }
//           }else{
//               print("Error in slider,home VC")
//                     }
//                 }
//
////        getRents(rentUrl)
//
//      //change scroll direction in collection Views
//        saleCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
////        rentCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        newsCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
   //setup main colletionview
    fileprivate func setupMainCollectioView(){
        view.addSubview(mainCollectionView)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        mainCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: sliderCellId)
        mainCollectionView.register(SaleCell.self, forCellWithReuseIdentifier: saleCellId)
        mainCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: contentCellId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        ReachabilityManager.shared.addListener(listener: self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        ReachabilityManager.shared.removeListener(listener: self)
    }
//    // MARK:- FSPagerViewDataSource
//
//    public func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return sliderArray.count
//    }
//
//    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        let imageUrl = URL(string:sliderArray[index].photos[0].url)
//        if let url = imageUrl {
//            cell.imageView?.sd_setImage(with: url , placeholderImage: UIImage(named:"GOW"), completed: nil)
//        }else{
//            cell.imageView?.image = UIImage(named:"notFound")
//        }
//        cell.textLabel?.font = font
//        cell.textLabel?.numberOfLines = 1
//        cell.textLabel?.textAlignment = .right
//        cell.textLabel?.text = sliderArray[index].title
//        cell.imageView?.contentMode = .scaleAspectFill
//        cell.imageView?.clipsToBounds = true
//        return cell
//    }
//    //Page view delegate
//
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        pagerView.deselectItem(at: index, animated: true)
//        pagerView.scrollToItem(at: index, animated: true)
//        self.sliderController.currentPage = index
//        //        MOVE TO ANOTHER VIEW WHEN ITEM IN SLIDER CLICKED
////        let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "webView") as! WebViewController
////        navigationController?.pushViewController(destination, animated: true)
//        let safariVC = SFSafariViewController(url: URL(string: "https://www.easyBazi.ir/")!)
//        self.present(safariVC, animated: true, completion: nil)
//        safariVC.delegate = self
//    }
//    //  CHANGE PAGE CONTROLLER CURRENT STATE
//
//    func pagerViewDidScroll(_ pagerView: FSPagerView) {
//        guard self.sliderController.currentPage != pagerView.currentIndex else {
//            return
//        }
//        self.sliderController.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
//    }
    
    //CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell!
        switch indexPath.row {
        case 0:
            let temp = collectionView.dequeueReusableCell(withReuseIdentifier: sliderCellId, for: indexPath) as! SliderCell
            temp.homeVC = self
            cell = temp
        case 1:
            let temp = collectionView.dequeueReusableCell(withReuseIdentifier: saleCellId, for: indexPath) as! SaleCell
            temp.homeVC = self
            cell = temp
        case 2:
        let temp = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellId, for: indexPath) as! ContentCell
        temp.homeVC = self
        cell = temp
        default:
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as UICollectionViewCell
            cell.backgroundColor = .blue
        }
        
        return cell
        
        
//        var temp:UICollectionViewCell!
//        if collectionView == newsCollectionView{
//            let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCollectionViewCell
//            makeCircular(newsCell.newsImage)
//            newsCell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
////            let imageUrl = URL(string:postArray[indexPath.row].photos[0].url)
//            if postArray[indexPath.row].photos.count != 0{
//            let url = URL(string: postArray[indexPath.row].photos[0].url)
//                newsCell.newsImage?.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
//            }else{
//                newsCell.newsImage?.image = UIImage(named:"GOW")
//            }
//            newsCell.newTitle.text = postArray[indexPath.row].title
//            temp = newsCell
//    }
////            else if collectionView == rentCollectionView{
////            let rentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "rentCell", for: indexPath) as! RentCollectionViewCell
////            makeCircular(rentCell.gameImage)
////            rentCell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//////            let imageUrl = URL(string:rentGameArray[indexPath.row].game_info.photos[0].url)
////            if rentGameArray[indexPath.row].game_info.photos.count != 0{
////            let url = URL(string: rentGameArray[indexPath.row].game_info.photos[0].url)
////                rentCell.gameImage?.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
////            }else{
////                rentCell.gameImage?.image = UIImage(named:"GOW")
////            }
////             rentCell.gameTitle.text = rentGameArray[indexPath.row].game_info.name
////            if rentGameArray[indexPath.row].count == 0{
////                rentCell.weekly.isHidden = true
////                rentCell.gameRentPrice.textColor = .notAvailable
////                rentCell.gameRentPrice.text = " ناموجود "
//////                rentCell.gameRentPrice.textAlignment = .center
////             }else{
//////                rentCell.gameRentPrice.textColor = UIColor.color(red: 251, green: 130, blue: 62, alpha: 1)
////                rentCell.weekly.isHidden = false
////                let price = Int(rentGameArray[indexPath.row].price)/100
////                let percent:Int!
//////                if rentTypes?.count != nil{//check if rent type not recieved yet
//////                    print(rentTypes?.count)
//////                    percent = Int(rentTypes![0].price_percent)!
//////                }else{
////                    percent = 10
//////                }
////                let weeklyRentPrice = (price*percent).formattedWithSeparator
////                rentCell.gameRentPrice.text = convertToPersian(inputStr: "\(String(describing: weeklyRentPrice))") + " تومان "
////            }
////            temp = rentCell
////    }
//        else if collectionView == saleCollectionView{
//            let saleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "saleCell", for: indexPath) as! SaleCollectionViewCell
//            makeCircular(saleCell.gameImage)
//            saleCell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
////            let imageUrl = URL(string:saleGameArray[indexPath.row].game_info.photos[0].url)
//            if saleGameArray[indexPath.row].game_info.photos.count != 0{
//                let url = URL(string: saleGameArray[indexPath.row].game_info.photos[0].url)
//                saleCell.gameImage?.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
//            }else{
//                saleCell.gameImage?.image = UIImage(named:"GOW")
//            }
//            saleCell.gameTitle.text = saleGameArray[indexPath.row].game_info.name
//
//            if saleGameArray[indexPath.row].count == 0{
//                    saleCell.gameprice.textColor = .notAvailable
//                    saleCell.gameprice.text = "ناموجود"
//                        }else{
////                    saleCell.gameprice.textColor = UIColor.easyBaziTheme
//                let price = Int(saleGameArray[indexPath.row].price!).formattedWithSeparator
//                    saleCell.gameprice.text = convertToPersian(inputStr: "\(String(describing: price))") + " تومان "
//                       }
//            temp = saleCell
//        }
//
//        return temp
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
//         if collectionView == rentCollectionView {
////            destination?.game = rentGameArray[indexPath.row]
////            destination?.rentTypes = (UIApplication.shared.delegate as! AppDelegate).rentTypes
////            destination?.isForRent = true
////            destination?.isSecondHand = false
////            navigationController?.pushViewController(destination!, animated: true)
////        }
//        else if collectionView == newsCollectionView{
////            let destination = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "webView") as! WebViewController
//            //            navigationController?.pushViewController(safariVC, animated: true)
////            UIApplication.shared.open(URL(string: "https://www.easyBazi.ir/")!, options: [:], completionHandler: nil)
//            let safariVC = SFSafariViewController(url: URL(string: "https://www.easyBazi.ir/")!)
//            self.present(safariVC, animated: true, completion: nil)
//            safariVC.delegate = self
//        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height / 3)
    }
    
    // Helper Methods
    internal func makeCircular(_ imageFram:UIImageView){
        imageFram.layer.masksToBounds = true
        imageFram.layer.cornerRadius = imageFram.frame.height/15
        imageFram.clipsToBounds = true
    }
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        return str
    }
    fileprivate func getRentTypes(){
          let delegate = (UIApplication.shared.delegate as! AppDelegate).url
          let rentTypesUrl = "\(delegate)/api/rent-type"
          RentTypes.get(rentTypesUrl) { (typesArray, status, message) in
              if status == 1{
                  self.rentTypes = typesArray
              }else{
                  print("Err in Home VC")
              }
          }
        
      }

    
}


