//
//  SaleViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/26/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import Reachability
class SaleViewController: UIViewController{
//    func networkStatusDidChange(status: Reachability.Connection) {
//        switch status {
//        case .none:
//            let alert = UIAlertController(title: "هشدار", message: "خطا در اتصال به اینترنت.لطفا دوباره سعی کنید!", preferredStyle: .alert)
//            let action = UIAlertAction(title:"باشه", style: .destructive, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//                case .wifi:
//                    debugPrint("ViewController: Network reachable through WiFi")
//                case .cellular:
//                    debugPrint("ViewController: Network reachable through Cellular Data")
//        case .unavailable:
//            return
//            }
//        }
    
    var gameArray = [Game]()
    var nextPageUrl:String!
    var delegate = (UIApplication.shared.delegate as! AppDelegate).url
    var activityIndicatorView:UIActivityIndicatorView!
    var isFetchingMore = false
    var spinner:UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    @IBOutlet weak var saleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saleTableView.isUserInteractionEnabled = false
        saleTableView.backgroundView = activityIndicatorView
        let saleUrl:String = "\(delegate)/api/game-for-shop-index/14"
        title = "فروشی ها"
        saleTableView.register(UINib(nibName: "spinnerCell", bundle: nil), forCellReuseIdentifier: "spinnerCell")
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        saleTableView.backgroundView = activityIndicatorView
        activityIndicatorView.color = UIColor.easyBaziTheme
        activityIndicatorView.startAnimating()
        GetDataForSaleVC.getData(saleUrl) {(games, nextPage,status,message) in
            if status == 1 {
                self.gameArray = games
                print(nextPage)
                self.nextPageUrl = nextPage
                self.saleTableView.reloadData()
                self.saleTableView.isUserInteractionEnabled = true
                
                OperationQueue.main.addOperation() {
                    self.activityIndicatorView.stopAnimating()
                }
            }else{
                print("\(String(describing: message))")
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("Disappear")
    }
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
//        ReachabilityManager.shared.addListener(listener: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
extension SaleViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return gameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let saleCell = tableView.dequeueReusableCell(withIdentifier: "saleCell", for: indexPath) as! SaleTableViewCell
        saleCell.gamePrice.font = UIFont(name: "IRANSans", size: 14)
        saleCell.View.layer.cornerRadius = 5
        makeCircular(saleCell.gamePrice)
        saleCell.gameImage.layer.cornerRadius = 5
//        saleCell.isSecondHand.layer.cornerRadius = 5
//        saleCell.isSecondHand.frame.size.width = 2/3 * saleCell.isSecondHand.frame.width
        
        if gameArray[indexPath.row].game_info.photos.count != 0{
            let url = URL(string: gameArray[indexPath.row].game_info.photos[0].url)
            saleCell.gameImage.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
        }else{
            saleCell.gameImage.image = UIImage(named:"GOW")
        }
        saleCell.gameName.text = gameArray[indexPath.row].game_info.name
        if gameArray[indexPath.row].count == 0{
            saleCell.gamePrice.backgroundColor = UIColor.notAvailable
            saleCell.gamePrice.text = " ناموجود "
        }else{
            saleCell.gamePrice.backgroundColor = UIColor.Available
            saleCell.gamePrice.text = convertToPersian(inputStr: "\(String(describing: Int(gameArray[indexPath.row].price).formattedWithSeparator))") + " تومان "
        }
            saleCell.gameRegion.text = "Region :\((gameArray[indexPath.row].region))"
        if gameArray[indexPath.row].game_info.console.name == "ps1" || gameArray[indexPath.row].game_info.console.name == "ps4" || gameArray[indexPath.row].game_info.console.name == "ps2"{
            saleCell.consoleImage.image = UIImage(named:"ps")
        }else{
            saleCell.consoleImage.image = UIImage(named:"xbox")
        }
        return saleCell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
        destination?.game = gameArray[indexPath.row]
        destination?.isForRent = false
        destination?.isSecondHand = true
        navigationController?.pushViewController(destination!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = 0
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        //check for lasr cell
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            if nextPageUrl != "" {
                spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                spinner.startAnimating()
                spinner.color = UIColor.easyBaziTheme
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.saleTableView.tableFooterView = spinner
                self.saleTableView.tableFooterView?.backgroundColor = .white
                self.saleTableView.tableFooterView?.isHidden = false
                GetDataForSaleVC.getData(nextPageUrl) { (games, nextPage,status,message) in
                    self.gameArray.append(contentsOf: games)
                    self.nextPageUrl = nextPage
                    self.isFetchingMore = true
                    self.saleTableView.reloadData()
                }
            }else{
                self.saleTableView.tableFooterView = nil
            }
        }
    }
    //MARK...Helper Methods
    internal func makeCircular(_ view:UIView){
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/9
        view.clipsToBounds = true
}
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    func animateTable() {
        let cells = saleTableView.visibleCells
        let tableViewHeight = saleTableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
