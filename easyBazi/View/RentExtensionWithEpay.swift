//
//  RentExtensionWithEpay.swift
//  easyBazi
//
//  Created by Ali Arabgary on 3/9/20.
//  Copyright © 2020 AliArabgary. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import SafariServices
import SVProgressHUD
class RentExtensionWithEpay : NSObject , UITextViewDelegate,SFSafariViewControllerDelegate{
    init(stateId:Int,cityId:Int,postCode:Int,content:String,phoneNumber:Int) {
        self.stateId = stateId
        self.cityId = cityId
        self.postCode = postCode
        self.addressDetailes = content
        self.PhoneNumber = phoneNumber
    }
    var renewalVC:RenewalViewController!
    var stateId:Int!
    var cityId:Int!
    var postCode:Int!
    var PhoneNumber:Int!
    var addressDetailes:String!
    var latitude:Int = 0
    var longitude:Int = 0
    let blackView = UIView()
    var game:Game!
    var addressId:Int!
    let containerView:UIView = {
        var view = UIView(frame: CGRect.zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.easyBaziTheme.cgColor
        return view
    }()
    let coverView:UIView = {
        var view = UIView(frame: CGRect.zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.easyBaziTheme.cgColor
        return view
    }()
    let label : UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.text = "آیا از پرداخت خود مطمئنید؟"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 17)
        return label
    }()
    let connectionToWebPageLabel : UILabel = {
          var label = UILabel()
           label.textColor = .white
           label.text = "در حال اتصال به صفحه پرداخت ..."
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textAlignment = .center
           label.font = UIFont(name: "IRANSans", size: 12)
           return label
       }()
    let indicator:UIActivityIndicatorView = {
        var ind = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ind.translatesAutoresizingMaskIntoConstraints = false
        ind.color = .easyBaziTheme
        ind.startAnimating()
        return ind
    }()
    let sendBtn:UIButton = {
       var btn = UIButton()
        btn.setTitle("بله،اطمینان دارم", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.easyBaziGreen
        btn.layer.borderWidth = 0
        btn.layer.borderColor = UIColor.easyBaziTheme.cgColor
        btn.layer.cornerRadius = 4
        return btn
    }()
    let cancelBtn:UIButton = {
        var btn = UIButton()
        btn.setTitle("خیر", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.gray
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = UIColor.easyBaziTheme.cgColor
//        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    let stack:UIStackView = {
       var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    //show EpayAlert Here
    public func show(){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.91)
            blackView.alpha = 0
            window.addSubview(blackView)
            blackView.frame = window.frame
            window.addSubview(containerView)
            containerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width - 25, height: window.frame.height/2)
            configeViews()
            let yPosition = window.frame.height/3
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.containerView.frame = CGRect(x: 0, y: yPosition, width: window.frame.width, height: window.frame.height/3)
                
            }, completion: nil)
        }
    }
    
    //dismiss comment view
    @objc func dismiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                 self.containerView.frame = CGRect(x: 0, y:window.frame.height, width: self.containerView.frame.width, height: self.containerView.frame.height)
                window.endEditing(true)
            }
        }, completion: nil)
    }
    
    //config container view's
    fileprivate func configeViews(){
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: containerView.topAnchor , constant: 8).isActive = true
        stack.addArrangedSubview(cancelBtn)
        stack.addArrangedSubview(sendBtn)
        containerView.addSubview(stack)
        stack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24).isActive = true
        stack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalToConstant: containerView.frame.size.width * 8/10).isActive = true
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        sendBtn.addTarget(self, action: #selector(sendInfoToServer), for: UIControlEvents.touchUpInside)
        
        
        
    }
    
    override init() {
        super.init()
    }
    
    //check if user is loggedIn
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
                token = data.value(forKey: "token") as! String
            }
            print("Fetching Seccessfully")
        }catch{
            print("Fetching Error")
            
        }
        return token
    }
    
    @objc  func sendInfoToServer(){
        self.renewalVC.extrndWithEpay()
    }

    fileprivate func addCoverView(){
        guard let window = UIApplication.shared.keyWindow else {
                return
            }
            window.addSubview(coverView)
//            coverView.widthAnchor.constraint(equalToConstant: window.frame.size.width - 25).isActive = true
//            coverView.heightAnchor.constraint(equalToConstant: window.frame.size.height).isActive = true
            coverView.topAnchor.constraint(equalTo: window.topAnchor, constant: 0).isActive = true
            coverView.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 13).isActive = true

            coverView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0).isActive = true
            coverView.rightAnchor.constraint(equalTo: window.rightAnchor, constant: -13).isActive = true
            coverView.addSubview(indicator)
            indicator.centerXAnchor.constraint(equalTo: coverView.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: coverView.centerYAnchor).isActive = true
            coverView.addSubview(connectionToWebPageLabel)
            connectionToWebPageLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 8).isActive = true
            connectionToWebPageLabel.centerXAnchor.constraint(equalTo: coverView.centerXAnchor).isActive = true

        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 0
//            self.coverView.alpha = 1
        }, completion: nil)
    }
    
     func removeCoverView(){

        UIView.animate(withDuration: 0.4, animations: {
            self.coverView.alpha = 0
        }, completion: { finish in
            self.coverView.removeFromSuperview()
        })
    }
    
}
