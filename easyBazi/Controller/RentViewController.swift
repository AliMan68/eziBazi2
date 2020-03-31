//
//  SaleViewController.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/26/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import SDWebImage
class RentViewController: UIViewController {
    var delegate = (UIApplication.shared.delegate as! AppDelegate).url
    var gameArray = [Game]()
    var nextPageUrl:String!
    var isFetchingMore = false
    var rentTypes:[rentType] = []
    var activityIndicatorView:UIActivityIndicatorView!
    var spinner:UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    @IBOutlet weak var rentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        rentTypes = (UIApplication.shared.delegate as! AppDelegate).rentTypes//get from delegate
        let rentUrl:String = "\(delegate)/api/game-for-rent-index/14"
        title = "اجاره ای ها"
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        rentTableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = UIColor.easyBaziTheme
        rentTableView.isUserInteractionEnabled = false
        GetDataForRentVC.getData(rentUrl) {(status,games, nextPage) in
            if status == 1{
                self.gameArray = games
                           self.nextPageUrl = nextPage
                           self.rentTableView.reloadData()
                           self.rentTableView.isUserInteractionEnabled = true
                           OperationQueue.main.addOperation() {
                               self.activityIndicatorView.stopAnimating()
                           }
            }else{
                self.activityIndicatorView.stopAnimating()
                let label = UILabel()
                label.text = "خطایی رخ داده،دوباره تلاش کنید."
                label.font = UIFont(name: "IRANSans", size: 13)
                label.textAlignment = .center
                label.textColor = .white
                self.rentTableView.backgroundView = label
            }
           
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        animateTable()
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
}
extension RentViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rentCell = tableView.dequeueReusableCell(withIdentifier: "rentCell", for: indexPath) as! RentTableViewCell
        rentCell.view.layer.cornerRadius = 5
        makeCircular(rentCell.price)
        rentCell.gameImage.layer.cornerRadius = 5
         if gameArray[indexPath.row].game_info.photos.count != 0{
               let url = URL(string: gameArray[indexPath.row].game_info.photos[0].url)
                   rentCell.gameImage.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
               }else{
                   rentCell.gameImage.image = UIImage(named:"GOW")
               }
        rentCell.gameName.text = gameArray[indexPath.row].game_info.name
        rentCell.region.text = "Region :\((gameArray[indexPath.row].region))"
        rentCell.price.font = UIFont(name: "IRANSans", size: 15)
        if gameArray[indexPath.row].count == 0{
            rentCell.price.backgroundColor = UIColor.notAvailable
            rentCell.weekly.isHidden = true
            rentCell.price.text = " ناموجود "
//            rentCell.price.textAlignment = .center
        }else{
            rentCell.weekly.isHidden = false
            rentCell.price.backgroundColor = UIColor.Available
            rentCell.price.textColor = UIColor.white
            let price = Int(gameArray[indexPath.row].price)/100
            let percent:Int!
            if rentTypes.count != 0{//check if rent type not recieved yet
                percent = Int(rentTypes[0].price_percent)
            }else{
                percent = 10
            }
          
            
            let weeklyRentPrice = (price*percent).formattedWithSeparator
            rentCell.price.text =  convertToPersian(inputStr: "\(String(describing: weeklyRentPrice))") + " تومان "
        }
        if gameArray[indexPath.row].game_info.console?.name == "ps1" || gameArray[indexPath.row].game_info.console!.name == "ps4" || gameArray[indexPath.row].game_info.console.name == "ps2"{
                rentCell.consoleType.image = UIImage(named:"ps")
            }else{
                rentCell.consoleType.image = UIImage(named:"xbox")
            }
        return rentCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
        destination?.game = gameArray[indexPath.row]
        destination?.rentTypes = (UIApplication.shared.delegate as! AppDelegate).rentTypes
        destination?.isForRent = true
        destination?.isSecondHand = false
        navigationController?.pushViewController(destination!, animated: true)
    }
    //request for new data when arrived to end if scroll view
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = 0
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                if nextPageUrl != "" {
                    spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    spinner.startAnimating()
                    spinner.color = UIColor.easyBaziTheme
                    spinner.frame = CGRect(x: 30, y: 30, width: 100, height: 40)
//                    spinner.center = rentTableView.tableFooterView!.center
                    self.rentTableView.tableFooterView?.addSubview(spinner)
                    self.rentTableView.tableFooterView?.backgroundColor = .white
                self.rentTableView.tableFooterView?.isHidden = false
            GetDataForRentVC.getData(nextPageUrl) { (status,games, nextPage) in
                if status == 1{
                    self.gameArray.append(contentsOf: games)
                    self.nextPageUrl = nextPage
                    self.isFetchingMore = true
                    self.rentTableView.reloadData()
                }else{
                    self.spinner.stopAnimating()
        
                }
             
//                self.rentTableView.tableFooterView?.isHidden = true
                        }
                }else{
                    self.rentTableView.tableFooterView = nil
//                    self.spinner.removeFromSuperview()
                }
//            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //Helper Methods
//    func scrollViewDidScroll(_ tableView: UIScrollView) {
//        print(tableView.frame.height)
//        if tableView.contentSize.height != 0 {
//            if tableView.contentOffset.y > (tableView.contentSize.height - tableView.frame.height * 1.5){
//                if !isFetchingMore{
//                    self.isFetchingMore = true
//                    print("End of tableView")
//                    print("this next page URl = \(nextPageUrl)")
//                    if nextPageUrl != "" {
//                    GetDataForRentVC.getData(nextPageUrl) { (games, nextPage) in
//                        self.gameArray.append(contentsOf: games)
//                        self.nextPageUrl = nextPage
//                        print(self.nextPageUrl)
////                        if self.nextPageUrl != "<null>"{
////                        }
//                        self.isFetchingMore = true
//                        self.rentTableView.reloadData()
//
//                    }
//                }
//            }
//        }
//    }
//}
    internal func makeCircular(_ view:UIView){
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/10
        view.clipsToBounds = true
    }
    func animateTable() {
        rentTableView.reloadData()
        let cells = rentTableView.visibleCells
        let tableViewHeight = rentTableView.bounds.size.height
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
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }

}
