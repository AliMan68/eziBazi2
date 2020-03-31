//
//  CommentsVC.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/20/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
class CommentsVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet var alertVIEW: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    var commentView:CommentView!
    var commentss = [comment]()
    
    @IBAction func sendComment(_ sender: UIButton) {
        sendComment()
    }
    
    @IBAction func cancelComment(_ sender: UIButton) {
    }
    
    var effect:UIVisualEffect!
    
    var nextPageUrl:String!
    var spinner:UIActivityIndicatorView!
    static var game:Game?
    var  activityIndicator:UIActivityIndicatorView!
    let collectionView:UICollectionView = {
        var cvLayer = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: cvLayer)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cvLayer.scrollDirection = UICollectionViewScrollDirection.vertical
        cv.backgroundColor = UIColor.backgroundThem
        return cv
    }()
    var cellId = "cellId"
    var writerFont:UIFont!
    var contentFont:UIFont!
    var addButton:UIButton!
    fileprivate func getCommentsFromServer() {
        let baseUrl = ""
        GetComments.comments(CommentsVC.game!.game_info.id,token: getToken(),urlString:baseUrl,pageInit:false) { (commentData,status) in
            if status == 1 {
                //                let receivedComments = commentData(current_page: comments.current_page, data: comments.data)
                if commentData != nil{
                    self.commentss = (commentData?.data)!
                    self.nextPageUrl = commentData?.next_page_url
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
            }else if status == -1{
                SVProgressHUD.show(withStatus: "خطایی رخ داده،مجددا امتحان کنید.")
                SVProgressHUD.dismiss(withDelay: 2)
                self.navigationController?.popViewController(animated: true)
                self.activityIndicator.stopAnimating()
                print("Error in receive comments")
            }
            else if status == 0{
                self.activityIndicator.stopAnimating()
                let label = UILabel()
                    label.text = "نظری وجود ندارد."
                    label.textAlignment = .center
                    label.font = UIFont(name: "IRANSans", size: 14)
                    label.textColor = .white
                    let button = UIButton()
                    button.setTitle("ثبت اولین نظر", for:.normal)
                    button.titleLabel?.textColor = .white
                    button.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
                    button.titleLabel?.textAlignment = .center
                    button.backgroundColor = .easyBaziTheme
                    button.layer.cornerRadius = 5
                    button.layer.masksToBounds = true
                    button.frame.size.width = self.view.frame.width*0.45
                    button.addTarget(self, action: #selector(self.fabTouched), for: .touchDown)
                    let stack = UIStackView(arrangedSubviews: [label,button])
                    stack.axis = .vertical
                    stack.spacing = 16
                    stack.distribution = .fillEqually
                    self.collectionView.addSubview(stack)
                    stack.translatesAutoresizingMaskIntoConstraints = false
                    stack.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor).isActive = true
                    stack.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor).isActive = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundThem
        configeCollectionView()
        getCommentsFromServer()
        addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(UIColor.easyBaziTheme, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        addButton.addTarget(self, action: #selector(fabTouched), for: .touchUpInside)
        let navItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = navItem
        writerFont = UIFont(name: "IRANSans", size: 14)
        contentFont = UIFont(name: "IRANSans", size: 13)
        textView.delegate = self
        textView.text = "نظر خود را وارد کنید...."
        textView.textColor = UIColor.lightGray
        textView.textAlignment = .right
        commentView = CommentView()
        alertVIEW.layer.cornerRadius = 5
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.easyBaziTheme
        activityIndicator.startAnimating()
        collectionView.backgroundView = activityIndicator
        view.endEditing(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    fileprivate func configeCollectionView(){
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        let topConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor) 
        let rightConstraint = collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        let leftConstraint = collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor )
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([topConstraint,rightConstraint,leftConstraint,bottomConstraint])
        collectionView.register(commentCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "نطر خود را وارد کنید..."
            textView.textColor = UIColor.lightGray
        }
    }
    @objc func fabTouched() {
        textView.text = ""
        commentView.show()
        commentView.game = CommentsVC.game
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
        // convert date to jalali calendar
    
    
    func getToken()->String{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        var token = ""
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                token = data.value(forKey: "token") as! String
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
        _ = UIEdgeInsetsMake(0, 0, keyboardHeight!, 0)
        var rect = self.view.frame
        rect.size.height  -= keyboardHeight!
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    @objc func keyboardWillHidden(notification: NSNotification) {
        let inset = UIEdgeInsets.zero
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
    }
    internal func sendComment(){
        if textView.text != ""{
            print(textView.text)
            print(self.getToken())
            Comment.send(CommentsVC.game!.game_info.id, text: textView.text, token: self.getToken(), completion: { (message, status) in
                let message = message
                let status = status
                if status == 1 {
                    print("comment Saved")
//                    self.animateOut()
                    SVProgressHUD.showSuccess(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 3)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("comment NotSaved")
                    SVProgressHUD.showError(withStatus: message)
                    SVProgressHUD.dismiss(withDelay: 3)
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
extension CommentsVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentss.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! commentCell
        let comment = commentss[indexPath.row]
        cell.comment = comment
        cell.layer.cornerRadius = 3
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let writerSize = CGSize(width: view.frame.width - 38, height: 1000)
        let contentSize = CGSize(width: view.frame.width - 46, height: 1000)
        let writerEstimatedheight = NSString(string: 
            commentss[indexPath.row].user.full_name).boundingRect(with: writerSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : writerFont], context: nil)
        let contentEstimatedheight = NSString(string: commentss[indexPath.row].text).boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : contentFont], context: nil)
        let estimatedHeight = (writerEstimatedheight.height) + (contentEstimatedheight.height)
        return CGSize(width: view.frame.width, height: estimatedHeight + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let lastSectionIndex = 0

                let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
                if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                        if nextPageUrl != nil {
                            spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                            spinner.startAnimating()
                            spinner.color = UIColor.easyBaziTheme
                            spinner.frame = CGRect(x: 30, y: 30, width: 100, height: 40)
                            GetComments.comments(CommentsVC.game!.game_info.id,token: getToken(),urlString:nextPageUrl,pageInit:true) { (commentData,status) in
                                        if status == 1 {
                            //                let receivedComments = commentData(current_page: comments.current_page, data: comments.data)
                                            if commentData != nil {
                                                self.commentss.append(contentsOf : (commentData?.data)!)
                                                self.nextPageUrl = commentData?.next_page_url
                                                self.collectionView.reloadData()
                                                self.activityIndicator.stopAnimating()
                                            }else{
                                                self.spinner.stopAnimating()
                                                let label = UILabel()
                                                label.text = "نظری وجود ندارد."
                                                label.textAlignment = .center
                                                label.font = UIFont(name: "IRANSans", size: 14)
                                                label.textColor = .white
                                                
                                                let button = UIButton()
                                                button.setTitle("ثبت اولین نطر", for:.normal)
                                                button.titleLabel?.textColor = .white
                                                button.titleLabel?.font = UIFont(name: "IRANSans", size: 15)
                                                button.titleLabel?.textAlignment = .center
                                                button.backgroundColor = .easyBaziTheme
                                                button.layer.cornerRadius = 5
                                                button.layer.masksToBounds = true
                                                button.addTarget(self, action: #selector(self.fabTouched), for: .touchDown)
                                                let stack = UIStackView(arrangedSubviews: [label,button])
                                                stack.axis = .vertical
                                                stack.spacing = 16
                                                stack.distribution = .fillEqually
                                                self.collectionView.addSubview(stack)
                                                stack.translatesAutoresizingMaskIntoConstraints = false
                                                stack.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor).isActive = true
                                                stack.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor).isActive = true
                                            }
                                            
                                        }else if status == -1{
                                            SVProgressHUD.show(withStatus: "خطایی رخ داده،مجددا امتحان کنید.")
                                            self.navigationController?.popViewController(animated: true)
                                            self.spinner.stopAnimating()
                                            print("Error in receive comments")
                                        }
                                    }
                        }else{
                            
        //                    self.spinner.removeFromSuperview()
                        }
        //            }
                }
    }
    

    
    
}
