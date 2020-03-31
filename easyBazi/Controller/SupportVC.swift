//
//  ChatTB.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/30/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//


import UIKit
import CoreData
class SupportVC: UIViewController,UITextFieldDelegate {
     let cellId = "id123"
    @IBOutlet weak var noMessage: UILabel!
    @IBOutlet weak var textFieldBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var indicator:UIActivityIndicatorView!
    var backgroundImage:UIImageView!
    var coverView:UIView!
//    var label:UILabel!
    @IBOutlet weak var sendButtonBottomConstraint: NSLayoutConstraint!
    var tableViewBackgroundImage: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named:"logo-1")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    @IBAction func sendButton(_ sender: Any) {
        
        if !inputTxt.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            print("HEre Wee Are 0.0") 
            self.addCoverView()
            Ticket.send(inputTxt.text!, token: getToken()) { (status, message,createAt) in
                        if status == 1{
                            self.removeCoverView()
                            self.tableView.isHidden = false
                            self.noMessage.isHidden = true
                            let messageContent = Messagee(text: self.inputTxt.text!, is_user_sent: 1, is_seen: 1, created_at:createAt)
                
                            let indexpath = IndexPath(row: self.chatMessages[self.chatMessages.count - 1].count - 1, section:  self.chatMessages.count - 1  )
                            self.chatMessages[self.chatMessages.count - 1].insert(messageContent, at: 0)
                            self.tableView.beginUpdates()
                            self.tableView.insertRows(at: [indexpath], with: .top)
                            self.tableView.endUpdates()
                            self.scrollToBottom()
                            
                            self.inputTxt.text = ""
                            UIView.animate(withDuration: 0.5) {
                                self.inputTxt.transform = .identity
                                self.inputTxt.leftViewMode = .never
                                self.sendButton.alpha = 0
                            }
                        }else{
                            if !self.noMessage.isHidden {
                                self.noMessage.isHidden = false
                            }
                            self.removeCoverView()
                            let alert = UIAlertController(title: "توجه ", message: "خطایی رخ داده.پیام خود را مجددا ارسال کنید",
                                                          preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "اوکی", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @IBOutlet weak var sendButton: UIButton!
    
    var chatMessages = [[Messagee]]()
    var messageCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        noMessage.textColor = .white
        self.inputTxt.delegate = self
        tableView.backgroundColor = UIColor.backgroundThem
        //cell space
        backgroundImage = UIImageView(image: UIImage(named:"logo-1"))
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.alpha = 0.7
        backgroundImage.frame.size = CGSize(width: view.frame.size.width - 100, height: view.frame.size.height * 0.4 )
        inputTxt.isUserInteractionEnabled = false
       
        inputTxt.layer.cornerRadius = 5
        inputTxt.keyboardType = UIKeyboardType.default
        let image = UIImageView(image: UIImage(named: "support.png"))
        image.contentMode = .scaleAspectFit
        var height:CGFloat?
        if (self.navigationController?.navigationBar.frame.height) != nil {
            height = (self.navigationController?.navigationBar.frame.height)
        }else{
            height = 44
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: height ?? 44))
        view.backgroundColor = .clear
        image.frame = CGRect(x: view.frame.origin.x + 2, y: view.frame.origin.y + 2, width: view.frame.width - 4 , height: view.frame.height - 4)
        view.addSubview(image)
//        image.frame.size = CGSize(width: 50 , height: 50 )
//        let label = UILabel()
//        label.font = UIFont(name: "IRANSans", size: 14)
//        label.text = "پشتیبانی"
//        label.textColor = .white
//        let stack = UIStackView(arrangedSubviews: [image,label])
//        stack.distribution = .fillEqually
//        stack.axis = .horizontal
//        stack.spacing = 8
        self.navigationItem.titleView = view
//        stack.center = self.navigationItem.titleView!.center
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        navigationController?.navigationBar.tintColor = UIColor.easyBaziTheme
        indicator.color = UIColor.easyBaziTheme
        tableView.backgroundView = indicator
        indicator.center = tableView.center
        indicator.startAnimating()
        Message.Get(token: getToken()) { (messages,status) in
            if status == 1{
                
                self.inputTxt.isUserInteractionEnabled = true
                if messages.count != 0{
                    self.noMessage.isHidden = true
                    self.indicator.stopAnimating()
                    self.groupMessages(from: messages)
                    self.indicator.removeFromSuperview()
                    self.messageCount = messages.count

                }else{
                    self.noMessage.isHidden = false
                    self.indicator.stopAnimating()
                    self.messageCount = 0
//                    self.tableView.isHidden = true
                }
            }else{
                print("Error in getting messages Api")
            }
            
        }
        Message.Seen(token: getToken()) { (status) in
            if status == 1{
                ProfileController.isMessageSeen = true
            }else{
                print("Error in Seeing message in supportVC")
            }
        }
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        sendButton.alpha = 0
        sendButton.backgroundColor = UIColor.black
        navigationItem.title = "Messages"
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        if inputTxt.text != "" {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "GOW"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            button.titleLabel?.text = "send message"
            button.titleLabel?.textColor = UIColor.black
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
            button.frame = CGRect(x:
                10, y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(sendmessage), for: .touchUpInside)
            view.addSubview(button)
            view.backgroundColor = UIColor.easyBaziTheme
            inputTxt.rightView = view
            inputTxt.rightViewMode = .always
            
        }
        
        inputTxt.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        
    }

//scroll to table view bottom 
    func scrollToBottom(){

        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (succeed) in
            if self.messageCount != 0 {
                let indexPath = IndexPath(row: self.chatMessages.last!.count-1, section: self.chatMessages.count - 1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    @objc func textFieldDidChanged(){
        //define offset in textField to fix UI bug(input overflow in screen)
        let rightView = UIView(frame: CGRect(
            x: 0, y: 0, // keep this as 0, 0
            width: sendButton.frame.size.width + 4, // add the padding
            height: sendButton.frame.size.height))
            
        
        if inputTxt.text == "" {
            UIView.animate(withDuration: 0.5) {
                self.inputTxt.transform = .identity
                self.inputTxt.leftViewMode = .never
                self.sendButton.alpha = 0
            }
            return
        }
        UIView.animate(withDuration: 0.5) {
//            self.inputTxt.transform = CGAffineTransform(translationX: -(self.sendButton.frame.size.width), y: 0)
            self.sendButton.alpha = 1
            self.inputTxt.leftViewMode = .always
            self.inputTxt.leftView = rightView
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputTxt {
            view.endEditing(true)
        }
        return true
    }
    
    @objc func sendmessage(){
  
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
                if data.value(forKey: "token") != nil{
                    token = data.value(forKey: "token") as! String
                }
            }
            print("Fetching Seccessfully")
        }catch{
            print("Fetching Error")
            
        }
        return token
    }
     @objc func keyboardWillShown(notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        self.textFieldBottom.constant = -(keyboardHeight!)
        self.sendButtonBottomConstraint.constant = -(keyboardHeight!)
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (succeed) in
            if self.messageCount != 0 {
                let indexPath = IndexPath(row: self.chatMessages.last!.count-1, section: self.chatMessages.count - 1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    @objc func keyboardWillHidden(notification: NSNotification) {
            self.textFieldBottom.constant = 0
            self.sendButtonBottomConstraint.constant = 0
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
        }
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //group all messages by date here
      fileprivate func groupMessages(from messages:[Messagee]){
          let groupedMessages = Dictionary(grouping: messages) { (message) -> Date in
              let date = message.created_at
              let idx = date.index(date.startIndex, offsetBy: 10)
              return Date.dateFromString(string: String(date[...idx]))
          }
        let sortedKeys = groupedMessages.keys.sorted()
          sortedKeys.forEach { (key) in
            let value = groupedMessages[key]
            chatMessages.append(value ?? [])
          }
        tableView.reloadData()
        self.tableView.backgroundView = self.backgroundImage
        self.scrollToBottom()
        self.inputTxt.becomeFirstResponder()
        self.indicator.stopAnimating()
//        tableView.isHidden = false
          
      }
}
//custom UILabel
class dateLabelHeader:UILabel{
         override var intrinsicContentSize: CGSize{
             layer.cornerRadius = super.intrinsicContentSize.height / 2
             layer.masksToBounds = true
             alpha = 0.75
             return CGSize(width: super.intrinsicContentSize.width + 16, height: super.intrinsicContentSize.height + 16)
      
         }
     }


extension Date {
    static func dateFromString(string: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: string)
        return date ?? Date()
    }
}


extension SupportVC:UITableViewDataSource,UITableViewDelegate{
        
     func numberOfSections(in tableView: UITableView) -> Int {
            return chatMessages.count
        }
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages[section].count
    }
        
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.selectionStyle = .none
        let messageInsection = Array(chatMessages[indexPath.section].reversed())
        let chatMessage = messageInsection[indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }

     
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let date = dateLabelHeader()
            date.font = UIFont(name: "IRANSans", size: 13)
            date.textAlignment = .center
            date.textColor = .white
            date.text = dateConvertor(from: chatMessages[section].first?.created_at ?? "نامعلوم")
            date.translatesAutoresizingMaskIntoConstraints = false
            date.backgroundColor = .black
            let containerView = UIView()
            containerView.addSubview(date)
            containerView.backgroundColor = .clear
            date.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            date.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            return containerView
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
        
        fileprivate func dateConvertor(from string:String )->String{
            let date = String(string)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let dateInGrogrian = dateFormatter.date(from: date)
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.persian)
            let components = calendar?.components(NSCalendar.Unit(rawValue: UInt.max), from: dateInGrogrian!)
            let year =  convertToPersian(inputStr: String(describing: components!.year!))
            let month =  convertToPersian(inputStr: String(describing: components!.month!))
            let day =  convertToPersian(inputStr: String(describing: components!.day!))
            dateFormatter.calendar = Calendar(identifier: .persian)
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let dateInPersian = "\(year)/\(month)/\(day)"
            return dateInPersian
        }
        func convertToPersian(inputStr:String)-> String {
            let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
            var str : String = inputStr
            
            for (key,value) in numbersDictionary {
                str =  str.replacingOccurrences(of: key, with: value)
            }
            
            return str
        }
        
        //Helper method
        
        fileprivate func addCoverView(){
        
            coverView = UIView()
            coverView.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
            coverView.alpha = 0
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            indicator.tintColor = UIColor.easyBaziTheme
            indicator.color = UIColor.easyBaziTheme
            view.addSubview(coverView)
            coverView.frame = view.bounds
            coverView.addSubview(indicator)
            indicator.frame = coverView.bounds
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
}

