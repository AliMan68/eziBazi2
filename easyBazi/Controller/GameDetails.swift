//
//  GameDetails.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/11/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation
import SDWebImage
import Reachability
import SafariServices
class GameDetails: UIViewController {
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
//            case .unavailable:
//            return
//        }
//    }
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var gameName: UILabel!
    
    @IBOutlet weak var gameRegion: UILabel!
    
    @IBOutlet weak var gameGenres: UILabel!
    
    @IBOutlet weak var rentPeriod: UISegmentedControl!
    
    @IBOutlet weak var gamePrice: UIButton!
    
    @IBOutlet weak var gameReleaseYear: UILabel!
    
    @IBOutlet weak var gameConsole: UIImageView!
    
    @IBOutlet weak var gameAge: UILabel!
    
    @IBOutlet weak var gameComment: UIButton!
    
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    
    @IBOutlet weak var relatedLabel: UILabel!
    
    @IBOutlet weak var secondHandLabel: UILabel!
    
    
    
    var isSecondHand:Bool = true
    
    var game:Game!
    
    var rentTypes:[rentType] = []
    
    var currentPeriod:String = "۱۰"
    
    var rentId:Int = 2
    
    
    @IBAction func PriceBtn(_ sender: UIButton) {
        
        if getToken() ==  "" {
            let message:String = "باشه"
            let attributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : self.font, NSAttributedStringKey.foregroundColor : UIColor.green])
            let alert = UIAlertController(title: "توجه!!!", message: "لطفا وارد حساب کاربری خود شوید و یا ثبت نام کنید.", preferredStyle: UIAlertControllerStyle.actionSheet)
             alert.setValue(NSAttributedString(string:  "توجه!!!", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string:  "لطفا وارد حساب کاربری خود شوید و یا ثبت نام کنید.", attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                      
            let action = UIAlertAction(title: attributedString.string, style: UIAlertActionStyle.destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            if gameIsforRent{
                        let storyBorad = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let rentVC = storyBorad.instantiateViewController(withIdentifier: "rentVC") as! RentVC
                        rentVC.game = self.game
                        rentVC.selectedPeriod = currentPeriod
                        rentVC.rentTypeId = rentId
                        rentVC.rentPercent = Int(rentTypes[rentId-1].price_percent)
                        rentVC.gameIsforRent = isForRent
            
                        navigationController?.pushViewController(rentVC, animated: true)
            }else{
                let storyBorad = UIStoryboard(name: "Main", bundle: Bundle.main)
                let shopVC = storyBorad.instantiateViewController(withIdentifier: "shopVC") as! ShopVC
                shopVC.game = self.game
                navigationController?.pushViewController(shopVC, animated: true)
            }
        }
    }
    @IBOutlet weak var buyButtonConstraibt: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    var isPlaying:Bool = true
    var isLoop: Bool = false
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var overLayView:UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    var playPauseButton :UIButton = {
        var btn = UIButton()
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        btn.setImage(UIImage(named:"pauseIcon"), for: .normal)
        btn.addTarget(self, action: #selector(playPause), for: .touchDown)
        btn.tintColor = UIColor.white
        return btn
    }()
    @objc func playPause(){
        if isPlaying{
            playPauseButton.setImage(UIImage(named:"pauseIcon"), for: .normal)
            play()
        }else{
            playPauseButton.setImage(UIImage(named:"playIcon"), for: .normal)
            player?.pause()
        }
        isPlaying = !isPlaying
    }
    @IBAction func commentBtn(_ sender: Any) {
        CommentsVC.game = self.game
    }
    @IBAction func selectedSegment(_ sender: UISegmentedControl) {
        let price:Int = Int(game.price)/100
        currentPeriod = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        if sender.selectedSegmentIndex == 0 {
                let percent:Int = Int(rentTypes[sender.selectedSegmentIndex].price_percent)
               let rentPrice = (price*percent).formattedWithSeparator
               rentId = sender.selectedSegmentIndex + 1
  
               gamePrice.setTitle("کرایه با مبلغ " + convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان ", for: .normal)
            
        }else if sender.selectedSegmentIndex == 1 {
            rentId = sender.selectedSegmentIndex + 1
            let percent:Int = Int(rentTypes[sender.selectedSegmentIndex].price_percent)
            let rentPrice = (price*percent).formattedWithSeparator
  
            gamePrice.setTitle("کرایه با مبلغ " + convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان ", for: .normal)
           
        }else if sender.selectedSegmentIndex == 2 {
            rentId = sender.selectedSegmentIndex + 1
           let percent:Int = Int(rentTypes[sender.selectedSegmentIndex].price_percent)
           let rentPrice = (price*percent).formattedWithSeparator

           gamePrice.setTitle("کرایه با مبلغ " + convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان ", for: .normal)
           
        }else if sender.selectedSegmentIndex == 3 {
            rentId = sender.selectedSegmentIndex + 1
            let percent:Int = Int(rentTypes[sender.selectedSegmentIndex].price_percent)
            let rentPrice = (price*percent).formattedWithSeparator

            gamePrice.setTitle("کرایه با مبلغ " + convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان ", for: .normal)
           
        }
    }
    var relatedActivityIndicator:UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    let loading:UIActivityIndicatorView = {
        var av = UIActivityIndicatorView(activityIndicatorStyle: .white)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.color = .easyBaziTheme
        av.startAnimating()
        return av
    }()
    var RentRelatedUrl:String!
    var saleRelatedeUrl:String!
    var postRelatedUrl:String!
    var relatedGames = [Game]()
   
    var isForRent:Bool!
    var font:UIFont!
    var gameIsforRent = false
    var hasVideo:Bool = true // check if game have Video or Not
    deinit{
        player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
//        player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
//        player?.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
//        player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferFull")
//        loading.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        ReachabilityManager.shared.removeListener(listener: self)
    }
    let label = UILabel()
    
    func configeURL()->String{
        let delegate = (UIApplication.shared.delegate as! AppDelegate).url
        let id:Int = game.game_info.id
        RentRelatedUrl = "\(delegate)/api/game-for-rent-related/\(String(describing: id))"
        saleRelatedeUrl = "\(delegate)/api/game-for-shop-related/\(String(describing: id))"
        postRelatedUrl = "\(delegate)/api/game-for-post-related/\(String(describing: id))"
        var url = ""
        if !gameIsforRent{
            url = RentRelatedUrl
        }else {
            url = saleRelatedeUrl
        }
        return url
    }
    
    fileprivate func configeAdditionalView() {
        font = UIFont(name: "IRANSans", size: 15)
        gamePrice.titleLabel?.font = UIFont(name: "IRANSans", size: 14)
        label.text = "موردی یافت نشد."
        label.textAlignment = .center
        label.textColor = UIColor.white
        relatedActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        relatedActivityIndicator.color = .easyBaziTheme
        relatedActivityIndicator.startAnimating()
        relatedCollectionView.backgroundView = relatedActivityIndicator
    }
    
    fileprivate func configeVideoPlayer() {
        containerView.frame.size.width = self.view.frame.size.width
        player(url: game.game_info.videos[0].url)
        containerView.addSubview(overLayView)
        overLayView.addSubview(loading)
        overLayView.addSubview(playPauseButton)
        isLoop = true
        overLayView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        overLayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        overLayView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        overLayView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: overLayView.centerYAnchor).isActive = true
        playPauseButton.centerXAnchor.constraint(equalTo: overLayView.centerXAnchor).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: overLayView.centerYAnchor).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func handleContainerViewContent() {
        playPauseButton.isHidden = true
        containerView.addSubview(overLayView)
        overLayView.addSubview(playPauseButton)
        overLayView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        overLayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        overLayView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        overLayView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        playPauseButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        playPauseButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        playPauseButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30 ).isActive = true
        playPauseButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30 ).isActive = true
    }
    
    fileprivate func configesegmentedControlColors() {
        let segmentAtrr :[AnyHashable : Any] =  [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font : UIFont(name: "IRANSans", size: 18)!]
        rentPeriod.setTitleTextAttributes(segmentAtrr ,for: UIControlState.normal)
        rentPeriod.tintColor = .easyBaziTheme
    }
    
    fileprivate func extactGenres(_ genreText: inout String) {
        let attr : [NSAttributedStringKey : Any] = [NSAttributedStringKey.font:font]
            if game.game_info.genres.count != 0{
               if game.game_info.genres.count > 1{
                 for genre in game.game_info.genres{
                     if genre.name == game.game_info.genres[0].name{
                        let attGenre = NSAttributedString(string: genre.name, attributes: attr )
                        genreText = attGenre.string
                       
                     }else{
                        let attGenre = NSAttributedString(string: genreText + "," + genre.name, attributes: attr )
                        genreText = attGenre.string
                        }
                     
                     }
                 }else{
                
                let attGenre = NSAttributedString(string: game.game_info.genres[0].name, attributes: attr )
                     genreText = attGenre.string
                     
             }
           }else{
                    let attGenre = NSAttributedString(string: "ندارد !", attributes: attr)
                    genreText = attGenre.string
           }
    }
    
    fileprivate func getRelatedGames(_ url: String) {
        
        RelatedGames.get(url){(Games,status) in
            if status == 1{
                if Games.count == 0 {
                    self.label.font = UIFont(name: "IRANSans", size: 13)
                    self.relatedCollectionView.backgroundView = self.label
                    self.relatedLabel.isHidden = false
                }else{
                    self.relatedCollectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    self.relatedGames = Games
                    self.relatedCollectionView.reloadData()
                    self.relatedActivityIndicator.stopAnimating()
                }
            }else{
                print("Err in related games")
            }
        }
    }
    //add segment control part's amd value's
    fileprivate func configeSegmentControl(_ allRentTypes:[rentType]){
        var counter = 0
        for type in allRentTypes{
            rentPeriod.insertSegment(withTitle: convertToPersian(inputStr: String(describing: type.day_count)), at: counter, animated: true)
            counter = counter + 1
        }
        rentPeriod.selectedSegmentIndex = 1
    }
    //set price for first time when view appear.
    fileprivate func configeFirstRentTypePrice(){
        let price:Int = Int(game.price)/100
        let percent:Int = Int(rentTypes[1].price_percent)
        let rentPrice = (price*percent).formattedWithSeparator
        gamePrice.setTitle("کرایه با مبلغ " + convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان ", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rentPeriod.layer.borderWidth = 0.5
        rentPeriod.layer.borderColor = UIColor.easyBaziThemeAlphaHalf.cgColor
//        getRentTypes()
        title = game.game_info.name
        if isForRent{
        rentPeriod.removeAllSegments()
        configeSegmentControl(rentTypes)
        configeFirstRentTypePrice()
        secondHandLabel.isHidden = true
        }else{
            secondHandLabel.isHidden = false
            if isSecondHand{
                secondHandLabel.text = "دست دوم"
            }else{
                secondHandLabel.text = "نو"
            }
        }
       
        configeAdditionalView()
        gameComment.backgroundColor = .easyBaziTheme
        configesegmentedControlColors()
        let url = configeURL()
        getRelatedGames(url)
        
        if hasVideo{ //check if game have video file or not
            configeVideoPlayer()
        }else{
            handleContainerViewContent()
        }
        gameIsforRent = isForRent!
        playPauseButton.isHidden = true
        relatedGames.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makeCircular(gamePrice)
        appDelegate.makeCircular(gameComment)
        var genreText:String = ""
        extactGenres(&genreText)//get genres from game object
        if game.count == 0{
            gameName.text = game.game_info.name
            timeLabel.isHidden = true
            gamePrice.backgroundColor = UIColor.notAvailable
            gamePrice.setTitle(" ناموجود ", for: .normal)
            gamePrice.isUserInteractionEnabled = false
            if game.game_info.photos.count != 0{
               let url = URL(string: game.game_info.photos[0].url)
                   gameImage.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
               }else{
                   gameImage.image = UIImage(named:"GOW")
               }
            
            
            rentPeriod.isHidden = true
            
            gameRegion.text = "Region : \(String(describing: game.region))"
            
            gameGenres.text = "Genres : \(genreText)"
            if game.game_info.console?.name == "ps1" || game.game_info.console?.name == "ps4" || game.game_info.console?.name == "ps2"{
                gameConsole.image = UIImage(named:"ps")
            }else{
                gameConsole.image = UIImage(named:"xbox")
            }
            
            gameAge.text = String(describing:game.game_info.age_class)
            let date = game.game_info.production_date
            let idx = date!.index(date!.startIndex, offsetBy: 3)
            gameReleaseYear.text = String(date![...idx])
            
        }else if gameIsforRent{
            gameName.text = game.game_info.name
            timeLabel.isHidden = false
            gamePrice.backgroundColor = UIColor.easyBaziGreen
            if game.game_info.photos.count != 0{//set image here
               let url = URL(string: game.game_info.photos[0].url)
                   gameImage.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
               }else{
                   gameImage.image = UIImage(named:"GOW")
               }
            
            gameName.text = game.game_info.name
            if rentPeriod.selectedSegmentIndex == 0 {
                let price = (Int(game.price)/1500).formattedWithSeparator
                gamePrice.setTitle("کرایه با مبلغ " + convertToPersian(inputStr: "\(String(describing: price))") + " تومان ", for: .normal)
            }
            
            gameRegion.text = "Region : \(String(describing: game.region))"
            gameGenres.text = "Genres : \(genreText)"
            if game.game_info.console?.name == "ps1" || game.game_info.console?.name == "ps4" || game.game_info.console?.name == "ps2"{
                gameConsole.image = UIImage(named:"ps")
            }else{
                gameConsole.image = UIImage(named:"xbox")
            }
            gameAge.text = String(describing:game.game_info.age_class)
            let date = game.game_info.production_date!
            let idx = date.index(date.startIndex, offsetBy: 3)
            gameReleaseYear.text = String(date[...idx])
      
        }else if !gameIsforRent{
            timeLabel.isHidden = true
            gameName.text = game.game_info.name
            gamePrice.backgroundColor = UIColor.easyBaziGreen
            gamePrice.setTitle("خرید با " + convertToPersian(inputStr: "\(String(describing: Int(game.price).formattedWithSeparator))") + " تومان ", for: .normal)

            
            if game.game_info.photos.count != 0{
               let url = URL(string: game.game_info.photos[0].url)
                   gameImage.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
               }else{
                   gameImage.image = UIImage(named:"GOW")
               }
            
            
            rentPeriod.isHidden = true
            gameRegion.text = "Region : \(String(describing: game.region))"
            gameGenres.text = "Genres : \(genreText)"
            if game.game_info.console?.name == "ps1" || game.game_info.console?.name == "ps4" || game.game_info.console?.name == "ps2"{
                gameConsole.image = UIImage(named:"ps")
            }else{gameConsole.image = UIImage(named:"xbox")
            }
            gameAge.text = String(describing: game.game_info.age_class)
            let date = game.game_info.production_date!
            let idx = date.index(date.startIndex, offsetBy: 3)
            gameReleaseYear.text = String(date[...idx])
            
        }
       
}
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        ReachabilityManager.shared.addListener(listener: self)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        playPauseButton.setImage(UIImage(named:"playIcon"), for: .normal)
        isPlaying = !isPlaying
        loading.isHidden = true
    }
    
}
extension GameDetails:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedGames.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomandCell", for: indexPath) as? GameDetailsCell
        detailesCell?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        if relatedGames[indexPath.row].game_info.photos.count != 0{
        let url = URL(string: relatedGames[indexPath.row].game_info.photos[0].url)
            detailesCell?.gameImage.sd_setImage(with: url , placeholderImage: UIImage(named:"logo-1"), completed: nil)
        }else{
            detailesCell?.gameImage.image = UIImage(named:"GOW")
        }
        
        detailesCell?.gameName.text = relatedGames[indexPath.row].game_info.name
       
        if gameIsforRent {//check for show weekly or not
            if relatedGames[indexPath.row].count == 0{
                                detailesCell?.weekly.isHidden = true
                                detailesCell?.gamePrice.textColor = .notAvailable
                                detailesCell?.gamePrice.text = "ناموجود"
                             }else{
                                detailesCell?.gamePrice.textColor = UIColor.color(red: 251, green: 130, blue: 62, alpha: 1)
                                detailesCell?.weekly.isHidden = false
                let price = Int(relatedGames[indexPath.row].price)/100
                                let percent:Int = Int(rentTypes[0].price_percent)
                                let weeklyRentPrice = (price*percent).formattedWithSeparator
                                detailesCell?.gamePrice.text = convertToPersian(inputStr: "\(String(describing: weeklyRentPrice))") + " تومان "
                            }
            
            
        }else{
            
            detailesCell?.gamePrice.text =  convertToPersian(inputStr: "\(String(describing: Int(relatedGames[indexPath.row].price).formattedWithSeparator))") + " تومان "
            detailesCell?.weekly.isHidden = true
            
        }
     
        
        
        
        return detailesCell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "gameDetails") as? GameDetails
        destination?.game = relatedGames[indexPath.row]
        destination?.rentTypes = rentTypes
        destination?.isForRent = gameIsforRent
        navigationController?.pushViewController(destination!, animated: true)
    }
    func player(url:String){
//
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
//            <#code#>
//        }
        
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            containerView.layer.addSublayer(playerLayer!)
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
//        player?.play()
        }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            playerLayer?.frame = CGRect(x: 0, y: 0, width: view.frame.size.height, height: containerView.frame.size.height)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        } else {
            print("Portrait")
            playerLayer?.frame = CGRect(x: 0, y: 0, width: view.frame.size.height, height: containerView.frame.size.height)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
    }
    private func addobserver(){
//        player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
//        player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
//        player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "currentItem.loadedTimeRanges"{
                loading.stopAnimating()
                overLayView.backgroundColor = UIColor.clear
                playPauseButton.isHidden = false
            }
//            switch keyPath {
//            case "playbackBufferEmpty"?:
//                loading.isHidden = false
//                print("Buffering")
//                playPauseButton.isHidden = true
//            case "playbackLikelyToKeepUp"?:
//                playPauseButton.isHidden = false
//                loading.isHidden = true
//                print("Not Buffering 1")
//            case "playbackBufferFull"?:
//                loading.isHidden = true
//                playPauseButton.isHidden = false
//                print("Not Buffering 2")
//            default:
//                loading.isHidden = true
//                print("Nothing Happenig")
//            }
    }
func stop() {
    player?.pause()
    player?.seek(to: kCMTimeZero)
}
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
    if isLoop {
        player?.pause()
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
}
func play() {
    if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
        player?.play()
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
    //get all types and percents
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
