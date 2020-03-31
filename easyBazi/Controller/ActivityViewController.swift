//
//  ActivityViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 11/11/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import CoreData
import Reachability
class ActivityViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
//    func networkStatusDidChange(status: Reachability.Connection) {
//        switch status {
//        case .none:
//            let alert = UIAlertController(title: "هشدار", message: "خطا در اتصال به اینترنت!", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        case .wifi:
//            debugPrint("ViewController: Network reachable through WiFi")
//        case .cellular:
//            debugPrint("ViewController: Network reachable through Cellular Data")
//        }
//    }

    let collectionView:UICollectionView = {
        var cvLayout = UICollectionViewFlowLayout()
        cvLayout.scrollDirection = .horizontal
        cvLayout.minimumLineSpacing = 0
        cvLayout.sectionInset = .zero
        var cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.isDirectionalLockEnabled = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.bounces = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.tintAdjustmentMode = UIViewTintAdjustmentMode.normal
        cv.backgroundColor = .clear
        return cv
    }()
    
    var rentCell:ActivityRentCV!
    var rentGames = [RentedGameData]()
    var buyGames = [BuyedGameData]()
    let label = UILabel()
    let label2 = UILabel()
    var cellId = "cellId"
    var activityRentCV = "ActivityRentCV"
    var activityBuyCV = "activityBuyCV"
    static var tabBarHeight:CGFloat?
    var sections:[String] = ["rented","buyed"]
    var rentTypes:[rentType]? = []
    //declear Activity Menu here
    
    lazy var activityMenu: ActivityMenu = {
        let am = ActivityMenu()
        am.activityController = self
        am.translatesAutoresizingMaskIntoConstraints = false
        return am
    }()
    var font :UIFont!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
        }
        rentTypes = (UIApplication.shared.delegate as! AppDelegate).rentTypes
        font = UIFont(name: "IRANSans", size: 16)
        let titleAttributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.foregroundColor : UIColor.white , NSAttributedStringKey.font:font]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        setupMenu()
        view.backgroundColor = .green
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionView()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ActivityRentCV.self, forCellWithReuseIdentifier: activityRentCV)
        collectionView.register(ActivityBuyCV.self, forCellWithReuseIdentifier: activityBuyCV)
        
    }
    
    //config menu here
    func setupMenu(){
        view.addSubview(activityMenu)
        activityMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        activityMenu.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        activityMenu.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        activityMenu.heightAnchor.constraint(equalToConstant: 50).isActive = true
      
    }
    
    public func setupCollectionView(){
        collectionView.topAnchor.constraint(equalTo: activityMenu.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: collectionView.frame.size.height)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let temp:UICollectionViewCell!
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityBuyCV, for: indexPath) as! ActivityBuyCV
            temp = cell
        }else{
            rentCell = collectionView.dequeueReusableCell(withReuseIdentifier: activityRentCV, for: indexPath) as? ActivityRentCV
            rentCell.activityVC = self
            temp = rentCell
        }
        return temp
    }
  
  
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        activityMenu.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityMenu.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.layer.removeAllAnimations()
//        ReachabilityManager.shared.removeListener(listener: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.view.layoutIfNeeded()
//        rentCell.collectionView.reloadData()
        ActivityViewController.tabBarHeight = tabBarController?.tabBar.frame.size.height
//        ReachabilityManager.shared.addListener(listener: self)
    }
    
    
    //For scroll to specific index when AactivityMenu selected
    func scrollToMenuIndex(menuIndex: Int , cv:UICollectionView) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func handleRenewalStaff( activityObject:ActivityRentCell){
//        print("game name is = \(String(describing: game.game_info.name!))")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "renewalVC") as? RenewalViewController
        destination?.game = activityObject.game
        destination?.rentTypes = rentTypes
        if #available(iOS 13.0, *) {
            destination?.isModalInPresentation = false
        } else {
            // Fallback on earlier versions
        }
        self.present(destination!, animated: true, completion: nil)
    }
    
}
//declear a base cell for better handling cells
class baseCell : UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        fetchData()
        observer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){}
    func fetchData(){}
    func observer(){}
}


    func getToken()->String{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        var token = ""
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                // print(data.value(forKey: "token")!)
                if data.value(forKey: "token") != nil{
                    token = data.value(forKey: "token") as! String
                }
            }
        }catch{
            print("Fetching Error")

        }
        return token
    }


