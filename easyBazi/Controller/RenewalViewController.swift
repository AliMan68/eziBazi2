//
//  RenewalViewController.swift
//  Easy Bazi
//
//  Created by Ali Arabgary on 1/23/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class RenewalViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    var game:RentedGameData!
    
    var contentFont:UIFont!
    
    var rentTypes:[rentType]!
    
    var price:Int!
    
    var rentExtensionView:RentExtensionWithWallet!
    
    var rentExtensionViewWithEpay:RentExtensionWithEpay!
    
    let firstView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 5
        return view
    }()
    let dividerView:UIView = {
         var view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.easyBaziTheme
         view.layer.cornerRadius = 5
        view.alpha = 0.45
         return view
     }()
    
    let dividerView2:UIView = {
          var view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.backgroundColor = UIColor.easyBaziTheme
          view.layer.cornerRadius = 5
          view.alpha = 0.45
          return view
      }()
    let dividerView3:UIView = {
            var view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.easyBaziTheme
            view.layer.cornerRadius = 5
            view.alpha = 0.45
            return view
        }()
    let dividerView4:UIView = {
             var view = UIView()
             view.translatesAutoresizingMaskIntoConstraints = false
             view.backgroundColor = UIColor.easyBaziTheme
             view.layer.cornerRadius = 5
             view.alpha = 0.45
             return view
         }()
    let dividerView5:UIView = {
              var view = UIView()
              view.translatesAutoresizingMaskIntoConstraints = false
              view.backgroundColor = UIColor.easyBaziTheme
              view.layer.cornerRadius = 5
              view.alpha = 0.45
              return view
          }()
    let dividerView6:UIView = {
              var view = UIView()
              view.translatesAutoresizingMaskIntoConstraints = false
              view.backgroundColor = UIColor.easyBaziTheme
              view.layer.cornerRadius = 5
              view.alpha = 0.45
              return view
          }()
    let dividerView7:UIView = {
                 var view = UIView()
                 view.translatesAutoresizingMaskIntoConstraints = false
                 view.backgroundColor = UIColor.easyBaziTheme
                 view.layer.cornerRadius = 5
                 view.alpha = 0.45
                 return view
             }()
    
    let secondView:UIView = {
         var view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = UIColor.clear
         view.layer.cornerRadius = 5
         return view
     }()
    
    let gameNameLabel:UILabel = {
       var name = UILabel()
        name.text = " نام بازی :"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont(name: "IRANSans",size: 13)
        name.textColor = .lightGray
        name.textAlignment = .right
        return name
    }()
    
      let renewalInfoLabel:UILabel = {
            var name = UILabel()
             name.text = "اطلاعات تمدید"
             name.translatesAutoresizingMaskIntoConstraints = false
             name.font = UIFont(name: "IRANSans",size: 14)
             name.textColor = .white
             name.textAlignment = .right
             return name
         }()
    
    let renewalPeriodLabel:UILabel = {
          var name = UILabel()
           name.text = " بازه(روز) : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 13)
           name.textColor = .lightGray
           name.textAlignment = .right
           return name
       }()
    let penaltyPriceLabel:UILabel = {
             var name = UILabel()
              name.text = "جریمه دیرکرد :"
              name.translatesAutoresizingMaskIntoConstraints = false
              name.font = UIFont(name: "IRANSans",size: 13)
              name.textColor = .lightGray
              name.textAlignment = .right
              return name
          }()
    let penaltyPrice:UILabel = {
               var name = UILabel()
                name.text = ""
                name.translatesAutoresizingMaskIntoConstraints = false
                name.font = UIFont(name: "IRANSans",size: 13)
                name.textColor = .white
                name.textAlignment = .left
                return name
            }()
    let renewalPriceLabel:UILabel = {
                var name = UILabel()
                 name.text = "هزینه اجاره :"
                 name.translatesAutoresizingMaskIntoConstraints = false
                 name.font = UIFont(name: "IRANSans",size: 13)
                 name.textColor = .lightGray
                 name.textAlignment = .right
                 return name
             }()
       let renewalPrice:UILabel = {
                  var name = UILabel()
                   name.text = ""
                   name.translatesAutoresizingMaskIntoConstraints = false
                   name.font = UIFont(name: "IRANSans",size: 13)
                   name.textColor = .white
                   name.textAlignment = .left
                   return name
               }()
    
    let renewalPeriods:UISegmentedControl = {
               var segment = UISegmentedControl()
               segment.insertSegment(withTitle: "۷", at: 0, animated: true)
               segment.insertSegment(withTitle:  "۱۰", at: 1, animated: true)
               segment.insertSegment(withTitle: "۱۵", at: 2, animated: true)
               segment.translatesAutoresizingMaskIntoConstraints = false
               segment.tintColor = .easyBaziTheme
               segment.selectedSegmentIndex = 1
               if #available(iOS 13.0, *) {
                         segment.selectedSegmentTintColor = UIColor.easyBaziTheme
                     }
               let attr:[AnyHashable:Any] = [NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.white]
               segment.tintColor = .white
               segment.setTitleTextAttributes(attr, for: UIControlState.normal)
               segment.layer.borderWidth = 0.5
               segment.layer.borderColor = UIColor.backgroundThem.cgColor
        segment.addTarget(self, action: #selector(handlePeriodChanges(_sender:)), for: UIControlEvents.valueChanged)
               return segment
           }()
    
    let gameRegionLabel:UILabel = {
          var name = UILabel()
           name.text = " ریجن : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 13)
           name.textColor = .lightGray
           name.textAlignment = .right
           return name
       }()
    let gameGenreLabel:UILabel = {
          var name = UILabel()
           name.text = " ژانر : "
           name.translatesAutoresizingMaskIntoConstraints = false
           name.font = UIFont(name: "IRANSans",size: 13)
           name.textColor = .lightGray
           name.textAlignment = .right
           return name
       }()
    let region:UILabel = {
         var label = UILabel()
         label.text = "All"
         label.textColor = .white
         label.font = UIFont(name: "San Francisco Display", size:14)
         label.textAlignment = .left
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
     let genre:UILabel = {
           var label = UILabel()
           label.text = ""
           label.textColor = .white
           label.font = UIFont(name: "IRANSans", size:14)
           label.textAlignment = .left
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    
    let exit:UIButton = {
       var btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "exit"), for: UIControlState.normal)
        btn.imageView?.tintColor = .easyBaziTheme
        btn.imageView?.contentMode = .scaleToFill
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(hanldeExit), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let renewalDetailesLabel:UILabel = {
          var label = UILabel()
          label.text = "جزییات تمدید بازی"
          label.textColor = .white
          label.font = UIFont(name: "IRANSans", size: 15)
          label.textAlignment = .right
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    let gameName:UILabel = {
        var label = UILabel()
        label.text = "Red dead redemption 2 "
        label.textColor = .white
        label.font = UIFont(name: "San Francisco Display", size:13)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let productLabel:UILabel = {
          var label = UILabel()
          label.text = "مشخصات بازی"
          label.textColor = .white
          label.font = UIFont(name: "IRANSans", size: 14)
          label.textAlignment = .right
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    let btnStack:UIStackView = {
          var stack = UIStackView()
          stack.axis = .horizontal
          stack.spacing = 8
          stack.backgroundColor = .red
          stack.distribution = .fillEqually
          stack.translatesAutoresizingMaskIntoConstraints = false
          return stack
      }()
    
    let ePayButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("پرداخت اینترنتی", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:14)
        btn.titleLabel?.textColor = .red
        btn.backgroundColor = UIColor.easyBaziGreen
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.backgroundThem.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(handleEpay), for: UIControlEvents.touchDown)
        return btn
    }()
    
    let localPayButton : UIButton = {
        var btn = UIButton()
        btn.setTitle("پرداخت با اعتبار", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size:13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.textColor = UIColor.easyBaziTheme
        btn.backgroundColor = UIColor.color(red: 58, green: 58, blue: 66, alpha: 1)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.backgroundThem.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(handleWalletPay), for: .touchDown)
        return btn
    }()

    
    fileprivate func setupFirstViewContent() {

        firstView.addSubview(gameName)
        nameLabelSetup()
        firstView.addSubview(region)
        regionSetup()
        firstView.addSubview(genre)
        genreSetup()
        firstView.addSubview(gameNameLabel)
        gameNameSetup()
        firstView.addSubview(gameRegionLabel)
        gameRegionSetup()
        firstView.addSubview(gameGenreLabel)
        gameGenreSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gamePenalty()
    }
    
    fileprivate func gamePenalty() {
        RentPenalty.get(for: game.id,token: getToken()) { (status, message, amount) in
              if status == 1{// add penalty amount to ui
                  
                  self.penaltyPrice.text = self.convertToPersian(inputStr: String(describing: amount.formattedWithSeparator)) + "تومان"
              }else{
                  self.penaltyPrice.font = UIFont(name: "IRANSans", size: 11)
                  self.penaltyPrice.text = message
              }
          }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 13)!)
        rentExtensionView = RentExtensionWithWallet()
        rentExtensionViewWithEpay = RentExtensionWithEpay()
        rentExtensionViewWithEpay.renewalVC = self
        rentExtensionView.renewalVC = self
        view.backgroundColor = UIColor.backgroundThem
        setupExitButton()
        setupFirstView()
        setupFirstViewContent()
        setupSecondView()
        setupSecondViewContent()
        setupButtomStack()
    }
    
    @objc func handlePeriodChanges(_sender:UISegmentedControl){
        price = Int(game.game_price)/100
        print("price is = \(price!)")
        switch _sender.selectedSegmentIndex {
        case 0:
            let percent:Int = Int(rentTypes[_sender.selectedSegmentIndex].price_percent)
            let rentPrice = (price*percent).formattedWithSeparator
            renewalPrice.text = convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان "
        case 1:
            let percent:Int = Int(rentTypes[_sender.selectedSegmentIndex].price_percent)
            let rentPrice = (price*percent).formattedWithSeparator
            print("percent is = \(percent)")
            renewalPrice.text = convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان "
        case 2:
            let percent:Int = Int(rentTypes[_sender.selectedSegmentIndex].price_percent)
            let rentPrice = (price*percent).formattedWithSeparator
            renewalPrice.text = convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان "
        case 3:
            let percent:Int = Int(rentTypes[_sender.selectedSegmentIndex].price_percent)
            let rentPrice = (price*percent).formattedWithSeparator
            renewalPrice.text = convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان "
        default:
             print("segment id is Unknown")
        }
    }
    
    @objc func hanldeExit(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEpay(){
        //connect to server later,here
        rentExtensionViewWithEpay.show()
    }
    
    @objc func handleWalletPay(){
        //connect to server later,here
        rentExtensionView.show()
        
    }
    
    fileprivate func setupButtomStack(){
        containerView.addSubview(btnStack)
        btnStack.addArrangedSubview(localPayButton)
        btnStack.addArrangedSubview(ePayButton)
     
        btnStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        btnStack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        btnStack.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        
    }
    
    fileprivate func setupSecondViewContent(){
        secondView.addSubview(renewalPeriodLabel)
        secondView.addSubview(renewalPeriods)
        secondView.addSubview(penaltyPriceLabel)
        secondView.addSubview(penaltyPrice)
        containerView.addSubview(renewalPriceLabel)
        containerView.addSubview(renewalPrice)
        secondView.addSubview(dividerView5)
        secondView.addSubview(dividerView6)
        secondView.addSubview(dividerView7)
        renewalPeriodLabel.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 12).isActive = true
        renewalPeriodLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
        penaltyPriceLabel.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -8).isActive = true
        penaltyPriceLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
        
        
        let contentSize = CGSize(width: containerView.frame.width, height: 1000)
        contentFont = UIFont(name: "IRANSans", size: 13)
        let contentEstimatedFrame = NSString(string: renewalPeriodLabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
        renewalPeriodLabel.widthAnchor.constraint(equalToConstant: contentEstimatedFrame.width + 10).isActive = true
        renewalPeriods.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 8).isActive = true
        renewalPeriods.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        renewalPeriods.rightAnchor.constraint(equalTo: renewalPeriodLabel.leftAnchor, constant: -8).isActive = true
        renewalPeriods.removeAllSegments()
        for type in rentTypes{
            renewalPeriods.insertSegment(withTitle: convertToPersian(inputStr:String(describing: type.day_count)), at: type.id, animated: true)
        }
        renewalPeriods.selectedSegmentIndex = 1
        dividerView5.topAnchor.constraint(equalTo: renewalPeriods.bottomAnchor, constant: 8).isActive = true
        dividerView5.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        dividerView5.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
        dividerView5.heightAnchor.constraint(equalToConstant: 1).isActive = true
        penaltyPrice.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: -8).isActive = true
        penaltyPrice.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        penaltyPrice.rightAnchor.constraint(equalTo: penaltyPriceLabel.leftAnchor, constant: -8).isActive = true
        price = Int(game.game_price)/100
        
        penaltyPrice.text = ""
        dividerView6.topAnchor.constraint(equalTo: penaltyPrice.bottomAnchor, constant: 8).isActive = true
        dividerView6.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        dividerView6.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
        dividerView6.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        renewalPriceLabel.topAnchor.constraint(equalTo: dividerView6.bottomAnchor, constant: 8).isActive = true
        renewalPriceLabel.rightAnchor.constraint(equalTo: secondView.rightAnchor, constant: -8).isActive = true
        
        renewalPrice.topAnchor.constraint(equalTo: dividerView6.bottomAnchor, constant: 8).isActive = true
        renewalPrice.leftAnchor.constraint(equalTo: secondView.leftAnchor, constant: 8).isActive = true
        //set first view load price
        let percent:Int = Int(rentTypes[1].price_percent)
        let rentPrice = (price*percent).formattedWithSeparator
        renewalPrice.text = convertToPersian(inputStr: "\(String(describing: rentPrice))") + " تومان "
      
    }
    fileprivate func setupSecondView(){
        containerView.addSubview(secondView)
        containerView.addSubview(renewalInfoLabel)
        renewalInfoLabel.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 16).isActive = true
        renewalInfoLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        let top = secondView.topAnchor.constraint(equalTo: renewalInfoLabel.bottomAnchor, constant: 8)
        let right = secondView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
        let left = secondView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
        let contentSize = CGSize(width: containerView.frame.width, height: 1000)
        contentFont = UIFont(name: "IRANSans", size: 13)
        NSLayoutConstraint.activate([top,right,left])
        let contentEstimatedFrame = NSString(string: gameNameLabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
        secondView.heightAnchor.constraint(equalToConstant: (contentEstimatedFrame.height * 2) + 48).isActive = true
    }
    fileprivate func setupRentPeriod(){
        
    }
    
    fileprivate func gameNameSetup(){
        gameNameLabel.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 8).isActive = true
        gameNameLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
    }
    fileprivate func gameRegionSetup(){
    
        gameRegionLabel.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 8).isActive = true
        gameRegionLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
 
    }
    fileprivate func gameGenreSetup(){
        
        gameGenreLabel.topAnchor.constraint(equalTo: gameRegionLabel.bottomAnchor, constant: 16).isActive = true
        gameGenreLabel.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true

    }
    
    fileprivate func nameLabelSetup(){
           firstView.addSubview(dividerView2)
           gameName.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 10).isActive = true
           gameName.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
        gameName.text = game.game_for_rent.game_info.name
           dividerView2.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 8).isActive = true
           dividerView2.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
           dividerView2.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
           dividerView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
       }
    
    fileprivate func regionSetup(){
         firstView.addSubview(dividerView3)
         region.topAnchor.constraint(equalTo: dividerView2.bottomAnchor, constant: 12).isActive = true
         region.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
        region.text = game.game_for_rent.region
         dividerView3.topAnchor.constraint(equalTo: region.bottomAnchor, constant: 8).isActive = true
         dividerView3.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
         dividerView3.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
         dividerView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
      }
      fileprivate func genreSetup(){
        firstView.addSubview(dividerView4)
          genre.topAnchor.constraint(equalTo: dividerView3.bottomAnchor, constant: 12).isActive = true
          genre.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
        if game.game_for_rent.game_info.genres.count != 0{
            if game.game_for_rent.game_info.genres.count > 1{
                for genree in game.game_for_rent.game_info.genres{
                    if genree.name == game.game_for_rent.game_info.genres[0].name{
                             genre.text = genree.name
                    }else{
                            genre.text = genre.text! + "," + genree.name
                           }
                           
                           }
                    }else{
                genre.text = game.game_for_rent.game_info.genres[0].name
                       }
                 }else{
                     genre.text = "ندارد !"
                 }
        dividerView4.topAnchor.constraint(equalTo: genre.bottomAnchor, constant: 8).isActive = true
        dividerView4.leftAnchor.constraint(equalTo: firstView.leftAnchor, constant: 8).isActive = true
        dividerView4.rightAnchor.constraint(equalTo: firstView.rightAnchor, constant: -8).isActive = true
        dividerView4.heightAnchor.constraint(equalToConstant: 1).isActive = true
          
      }
    
     fileprivate func setupFirstView(){
            containerView.addSubview(productLabel)
            containerView.addSubview(firstView)
            productLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 32).isActive = true
            productLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
            let top = firstView.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 8)
            let right = firstView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8)
            let left = firstView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8)
            let contentSize = CGSize(width: containerView.frame.width, height: 1000)
            contentFont = UIFont(name: "IRANSans", size: 13)
            let contentEstimatedFrame = NSString(string: gameNameLabel.text!).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
            firstView.heightAnchor.constraint(equalToConstant: (contentEstimatedFrame.height * 3) + 56).isActive = true
            NSLayoutConstraint.activate([top,right,left])
     }
    
    fileprivate func setupExitButton() {
        containerView.addSubview(exit)
        containerView.addSubview(renewalDetailesLabel)
        containerView.addSubview(dividerView)
        exit.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        exit.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        exit.widthAnchor.constraint(equalToConstant: containerView.frame.size.width/15).isActive = true
        exit.heightAnchor.constraint(equalToConstant: containerView.frame.size.width/15).isActive = true
        renewalDetailesLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        renewalDetailesLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        dividerView.topAnchor.constraint(equalTo: renewalDetailesLabel.bottomAnchor, constant: 8).isActive = true
        dividerView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        dividerView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    
    func extendWithWallet(){
        rentExtensionView.dismiss()
//        rentExtensionView.removeCoverView()
        SVProgressHUD.show(withStatus: "در حال انجام...")
//        SVProgressHUD.dismiss(withDelay: 2)
        RentGameWallet.extend(token:getToken(),gameId: game.id, rentTypeId: renewalPeriods.selectedSegmentIndex + 1) { (status, message) in
            if status == 1{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLogout"), object: nil)
                SVProgressHUD.showSuccess(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 3)
                self.dismiss(animated: true, completion: nil)
                
            }else{
                SVProgressHUD.showError(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 4)
            }
        }
    }
    
    func extrndWithEpay(){
        rentExtensionViewWithEpay.dismiss()
        SVProgressHUD.show(withStatus: "در حال انجام...")
//        SVProgressHUD.dismiss(withDelay: 2)
        RentGameEpay.extend(token:getToken(),gameId: game.id, rentTypeId: renewalPeriods.selectedSegmentIndex + 1) { (status, message, link) in
            if status == 1{
                SVProgressHUD.showSuccess(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 1)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLogout"), object: nil)
                UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                self.dismiss(animated: true, completion: nil)
            }else{
                SVProgressHUD.showSuccess(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 4)
            }
        }
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
}

