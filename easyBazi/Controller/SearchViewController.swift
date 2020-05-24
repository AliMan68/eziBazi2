//
//  SearchViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/1/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import Reachability
import SafariServices
import SVProgressHUD

class SearchViewController: UIViewController,SFSafariViewControllerDelegate {
//    func networkStatusDidChange(status: Reachability.Connection) {
//        switch status {
//        case .none:
//            let alert = UIAlertController(title: "هشدار", message: "خطا در اتصال به اینترنت!", preferredStyle: .alert)
//            let action = UIAlertAction(title: "اوکی", style: .default, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        case .wifi:
//            debugPrint("ViewController: Network reachable through WiFi")
//        case .cellular:
//            debugPrint("ViewController: Network reachable through Cellular Data")
//            case .unavailable:
//            return
//        }
//    }
    var rentTypes:[rentType] = []
    var message:String = ""
    var index:IndexPath!
    var searchType:String = "rent"
    var activityIndicatorView:UIActivityIndicatorView!
    var isEnoughCharacter = false
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    var searachResult = [Game]()
    var postSearachResult = [Post]()
    var searchedText:String = ""
    var rentCellId:String = "rentCell"
    var shopCellId:String = "shopCell"
    var postCellId:String = "postCell"
    var navBarHeight:CGFloat!
    var statusBarHeight:CGFloat!
    var tabBarHeight:CGFloat!
    var backgroundColor:UIColor!
    let searchCollectionView:UICollectionView = {
        var cvLayout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayout)
        cvLayout.scrollDirection = .vertical
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.color(red: 18, green: 38, blue: 57, alpha: 1)
        return cv
    }()
    
    let segment:UISegmentedControl = {
        var sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
//        sc.insertSegment(withTitle: "کرایه ای ها", at: 0, animated: true)
        sc.insertSegment(withTitle: "فروشی ها", at: 0, animated: true)
        sc.insertSegment(withTitle: "پست ها", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        let attr:[AnyHashable:Any] = [NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 14)!]
//        let attr = NSDictionary(object: UIFont(name: "IRANSans", size: 14)!, forKey: NSAttributedStringKey.font as NSCopying)
        sc.backgroundColor = UIColor.color(red: 18, green: 38, blue: 57, alpha: 1)
        sc.tintColor = .white
        sc.setTitleTextAttributes(attr, for: UIControlState.normal)
        sc.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
        sc.layer.borderWidth = 0.5
        sc.layer.borderColor = UIColor.easyBaziThemeAlphaHalf.cgColor
        return sc
    }()
    
    let footerView:SearchFooter = {
        var view = SearchFooter()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let textView:UISearchBar = {
        var tv = UISearchBar()
        tv.layer.borderWidth = 0
        tv.barTintColor = UIColor.color(red: 18, green: 38, blue: 57, alpha: 1)
        tv.translatesAutoresizingMaskIntoConstraints = false
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font : UIFont(name: "IRANSans", size: 11)! // Note the !
        ]
        tv.placeholder = "کلمه مورد نظر را اینجا وارد کنید"
        let textFieldInsideUISearchBar = tv.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.lightGray
        let label = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        label?.textColor = UIColor.red
        label?.font = UIFont(name: "IRANSans", size: 12)
        return tv
    }()
    var font:UIFont!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rentTypes = (UIApplication.shared.delegate as! AppDelegate).rentTypes
        view.backgroundColor = .backgroundThem
        hideKeyboardWhenTappedAround()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .easyBaziTheme
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicatorView.color = UIColor.easyBaziTheme
        font = UIFont(name: "IRANSans", size: 14)
        configeTextView()
        configeSegment()
        configeTableView()
        configeFooterView()
//        segment.tintColor = UIColor.ezibaziThem
        if #available(iOS 13.0, *) {
            segment.selectedSegmentTintColor = UIColor.easyBaziTheme
        } else {
            // Fallback on earlier versions
            
        }
        let titleAttributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.foregroundColor : UIColor.white , NSAttributedStringKey.font:font]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    fileprivate func configeFooterView(){
        view.addSubview(footerView)
        footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        footerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    fileprivate func configeSegment(){
        view.addSubview(segment)
        segment.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        segment.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        segment.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        let segmentAtrr :[AnyHashable : Any] =  [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font : UIFont(name: "IRANSans", size: 14)!]
        segment.setTitleTextAttributes(segmentAtrr ,for: UIControlState.normal)
                
        //        if #available(iOS 13.0, *) {
        //            rentPriod.selectedSegmentTintColor = UIColor.ezibaziThem
        //        } else {
        //
        //            // Fallback on earlier versions
        //        }
    }
    
    fileprivate func configeTextView(){
        view.addSubview(textView)
        textView.delegate = self
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    fileprivate func configeTableView(){
        view.addSubview(searchCollectionView)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 1).isActive = true
        searchCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0 ).isActive = true
        searchCollectionView.register(SearchShopCell.self, forCellWithReuseIdentifier: shopCellId)
        searchCollectionView.register(SearchRentCell.self, forCellWithReuseIdentifier: rentCellId)
        searchCollectionView.register(SearchPostCell.self, forCellWithReuseIdentifier: postCellId)
        searchCollectionView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        searchCollectionView.scrollIndicatorInsets = .init(top: 20, left: 0, bottom: 20, right: 0)
        searchCollectionView.backgroundView = activityIndicatorView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        ReachabilityManager.shared.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        ReachabilityManager.shared.removeListener(listener: self)
    }
}
    
extension SearchViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchType == "post"{
            return postSearachResult.count
        }else{
        return searachResult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var temp:UICollectionViewCell!
//        if segment.selectedSegmentIndex == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rentCellId, for: indexPath) as! SearchRentCell
//            let game = searachResult[indexPath.row]
//            cell.game = game
//            cell.rentPercent = Int(rentTypes[0].price_percent)
//            temp = cell
//        }else
            if segment.selectedSegmentIndex == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shopCellId, for: indexPath) as! SearchShopCell
            let game = searachResult[indexPath.row]
            cell.game = game
            temp = cell
        }else if segment.selectedSegmentIndex == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as! SearchPostCell
                print(postSearachResult.count)
            let post = postSearachResult[indexPath.row]
            cell.post = post
            temp = cell
        }

        return temp
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = view.frame.size.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom)
//        height = game image + price conyainer + margins
        return CGSize(width: view.frame.size.width - 25, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
   
        if searchType == "shop"{
            destination?.game = searachResult[indexPath.row]
            destination?.isForRent = false
            destination?.isSecondHand = true
            navigationController?.pushViewController(destination!, animated: true)
        }else if searchType == "rent"{
            destination?.game = searachResult[indexPath.row]
            destination?.rentTypes = rentTypes
            destination?.isForRent = true
            destination?.isSecondHand = false
            navigationController?.pushViewController(destination!, animated: true)
        }else if searchType == "post"{
             let safariVC = SFSafariViewController(url: URL(string: "https://www.easybazi.ir/blog-detailes")!)
             self.present(safariVC, animated: true, completion: nil)
             safariVC.delegate = self
        }

    }
    //MARK: Search bar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if !isEnoughCharacter {
            let alert = UIAlertController(title: "توجه !!!", message:  " لطفا برای جستجو بیشتر از دو حرف وارد نمایید .", preferredStyle: UIAlertControllerStyle.alert)
               alert.setValue(NSAttributedString(string:  " لطفا برای جستجو بیشتر از دو حرف وارد نمایید .", attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            alert.setValue(NSAttributedString(string:  "توجه !!!", attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            searachResult.removeAll()
            postSearachResult.removeAll()
            searchCollectionView.reloadData()
            activityIndicatorView.startAnimating()
            if searchType == "post"{
                searchForPosts()
            }else{
                 search()
            }
           
        }
    }
    @objc func segmentValueChanged(sender: UISegmentedControl) {
        footerView.hideFooter()
//        if {
            searachResult.removeAll()
            postSearachResult.removeAll()
            searchCollectionView.reloadData()
            switch sender.selectedSegmentIndex {
//            case 0 :
//                searchType = "rent"
//                search()
//            case 1 :
//                searchType = "shop"
//                search()
//            case 2 :
//                searchType = "post"
//                searchForPosts()
                //new version edit
                case 0 :
                    searchType = "shop"
                    search()
                case 1 :
                    searchType = "post"
                    searchForPosts()
                          
            default:
                print("case here")
            }
//        }
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchedText = searchText
        if searchText == ""{
            searachResult.removeAll()
            searchCollectionView.reloadData()
        }
        if searchText.count <= 2 {
            isEnoughCharacter = false
        }else{
            isEnoughCharacter = true
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
//    //MARK: Helper Method
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func search(){
        if textView.text!.count > 2 {
            activityIndicatorView.startAnimating()
            Search.serachMethod(searchedText,urlType:searchType,completion: { (games,message,status) in
                if status == 1{
                    self.activityIndicatorView.stopAnimating()
                    self.searachResult = games
                    self.message = message
                    self.searchCollectionView.reloadData()
                    if (self.searachResult.count != 0 && self.message == "") {
                        self.footerView.filterShow(self.searachResult.count)
                    }else{
                        self.footerView.filterShow(self.searachResult.count)
                    }
                }else if status == -1{
                     SVProgressHUD.showError(withStatus: "خطایی در ارتباط با سرور ;(")
                }else{
                     self.activityIndicatorView.stopAnimating()
                    self.footerView.filterShow(games.count)
                    print("Error in search Api")
                }
            })
        }
    }
    func searchForPosts(){
         if textView.text!.count > 2 {
            activityIndicatorView.startAnimating()
            Search.forPosts(searchedText,completion: { (posts,message,status) in
                 if status == 1{
                     self.activityIndicatorView.stopAnimating()
                    
                     self.postSearachResult = posts
                     self.message = message
                     self.searchCollectionView.reloadData()
                     if (self.postSearachResult.count != 0) {
                         self.footerView.filterShow(self.postSearachResult.count)
                     }else{
                         self.footerView.filterShow(self.postSearachResult.count)
                     }
                 }else{
                      self.activityIndicatorView.stopAnimating()
                     self.footerView.filterShow(posts.count)
                     print("Error in post Api")
                 }
             })
         }
     }
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        return str
    }

}
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
}
