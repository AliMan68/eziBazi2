//
//  Comment View.swift
//  EziBazi2
//
//  Created by AliArabgary on 3/6/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SVProgressHUD
class CommentView : NSObject , UITextViewDelegate{
    let blackView = UIView()
    var game:Game!
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
        view.layer.borderColor = UIColor.easyBaziTheme.cgColor
        return view
    }()
    
    let textView:UITextView = {
        var post = UITextView()
        post.backgroundColor = UIColor.white
        
        
        post.textColor = UIColor.black
        post.layer.cornerRadius = 5
        post.textAlignment = .right
        post.font = UIFont(name: "IRANSans", size: 13)
        post.translatesAutoresizingMaskIntoConstraints = false
        post.keyboardType = .default
        return post
    }()
    let label : UILabel = {
       var label = UILabel()
        label.textColor = .white
        label.text = "نظر خود را در کادر زیر وارد کنید:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IRANSans", size: 17)
        return label
    }()
    let sendBtn:UIButton = {
       var btn = UIButton()
        btn.setTitle("ارسال", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 14)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.easyBaziGreen
        
        
        btn.layer.cornerRadius = 4
//        btn.addTarget(self, action: #selector(sendComment), for: UIControlEvents.touchUpInside)
        return btn
    }()
    let cancelBtn:UIButton = {
        var btn = UIButton()
        btn.setTitle("انصراف", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 4
//        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    let stack:UIStackView = {
       var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    //show commentView Here
    public func show(){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.85)
            blackView.alpha = 0
            window.addSubview(blackView)
            blackView.frame = window.frame
            window.addSubview(containerView)
            containerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width - 25, height: window.frame.height/2)
            configeViews()
            let yPosition = window.frame.height/6
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.containerView.frame = CGRect(x: 0, y: yPosition, width: window.frame.width, height: window.frame.height/3)
                
            }, completion: nil)
            textView.becomeFirstResponder()
        }
    }
    
    //dismiss comment view
    @objc func dismiss() {
        textView.text = ""
        print("Dismiss clicekd")
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
        containerView.addSubview(textView)
        textView.topAnchor.constraint(equalTo: label.bottomAnchor , constant: 8).isActive = true
        textView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: containerView.frame.size.height * 0.45).isActive = true
        textView.widthAnchor.constraint(equalToConstant: containerView.frame.size.width * 9/10).isActive = true
        
        stack.addArrangedSubview(cancelBtn)
        stack.addArrangedSubview(sendBtn)
        containerView.addSubview(stack)
        stack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8).isActive = true
        stack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalToConstant: containerView.frame.size.width * 9/10).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 45).isActive = true
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        sendBtn.addTarget(self, action: #selector(sendComment), for: UIControlEvents.touchUpInside)
        
        
        
    }
    
    override init() {
        super.init()
        textView.delegate = self
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
    
    @objc internal func sendComment(){
        addCoverView()
        if textView.text != "" || textView.text.count < 4 {
            Comment.send(game.game_info.id, text: textView.text, token: self.getToken(), completion: { (message, status) in
                let message = message
//                message.attribu
                let status = status
                if status == 1 {
                    print("comment Saved")
                    self.removeCoverView()
                    self.dismiss()
                    SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 12)!)
                    SVProgressHUD.showSuccess(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 2)

                }else{
                    print("comment NotSaved")
                   
                    SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 12)!)
                    SVProgressHUD.showError(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 2)
                    self.dismiss()
                }
            })
        }else{
       
            
        }
    }
    
    fileprivate func addCoverView(){
        //coverView.backgroundColor = UIColor(white: 1, alpha: 0.6)
        coverView.alpha = 0
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.tintColor = UIColor.easyBaziTheme
        indicator.color = UIColor.easyBaziTheme
        containerView.addSubview(coverView)
        
        coverView.frame = containerView.bounds
        coverView.addSubview(indicator)
        //indicator.frame = coverView.bounds
        indicator.center = coverView.center
        indicator.startAnimating()
        UIView.animate(withDuration: 0.4, animations: {
            self.coverView.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func removeCoverView(){

        UIView.animate(withDuration: 0.4, animations: {
            self.coverView.alpha = 0
        }, completion: { finish in
            self.coverView.removeFromSuperview()
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count < 4 {
            sendBtn.isEnabled = false
        }else{
            sendBtn.isEnabled = true
            
        }
    }
    
    
    
    
    
    
    
    
    
}
