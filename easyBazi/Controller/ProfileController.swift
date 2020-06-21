//
//  ProfileController.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/17/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData
import SafariServices
//import Reachability
class ProfileController: UIViewController,UITextFieldDelegate,SFSafariViewControllerDelegate {
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
     var isSingedIn = false
    static var isMessageSeen:Bool = false
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var userFinance: UILabel!
    
    @IBOutlet weak var accountFinance: UIButton!
    
    @IBOutlet weak var financeImage: UIImageView!
    
    @IBOutlet weak var financeLabel: UILabel!
    
    @IBOutlet weak var backUpImage: UIImageView!
    
    @IBOutlet weak var backUpButton: UIButton!
    
    @IBOutlet weak var exitImage: UIImageView!
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var viewsMargin: NSLayoutConstraint!
    
    @IBOutlet weak var financeContainer: UIView!
    
    @IBOutlet weak var forgetButton: UIButton!
    
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var newMessage: UILabel!
    
    @IBOutlet weak var scrollView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var reckogningBtn: UIButton!
    
    var phoneNumber:String = ""
    
    @IBAction func about(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.easyBazi.ir/about")!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
        
       }
      
    @IBAction func terms(_ sender: Any) {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.easyBazi.ir/terms")!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
       }
    
    @IBAction func reckogning(_ sender: UIButton) {
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show(withStatus: "در حال ارسال کد فعالسازی... ")
        VerificationCode.sendForReckogning(getToken()) { (status, message) in
            if status == 1{
                SVProgressHUD.show(withStatus:message)
                SVProgressHUD.dismiss(withDelay: 3)
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let verificationVC = storyboard.instantiateViewController(withIdentifier: "signupVerificationVC") as? VerificationViewController
                verificationVC?.isForReckogning = true
                verificationVC?.phoneNumber = ""
                self.navigationController?.pushViewController(verificationVC!, animated: true)
                

            }else{
                SVProgressHUD.show(withStatus:message )
                SVProgressHUD.dismiss(withDelay: 3)
            }
          }
    }

    @IBAction func logOutButton(_ sender: UIButton) {
        SVProgressHUD.setFont(font)
        SVProgressHUD.show(withStatus: "در حال انجام...")
        logOut.getOut(token: getToken()) { (message, status) in
            if status == 1{
                self.eraseToken()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLogout"), object: nil)
                self.alternativeView.isHidden = false
                self.firstView.isHidden = false
                SVProgressHUD.showSuccess(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 2)
                self.userPhoneNumber1.text = ""
                self.userNameTF.text = ""
                self.userPass1.text = ""
                self.userFinance.text = ""
                self.reckogningBtn.isHidden = true
                self.forgetButton.isHidden = false
            }else{
                SVProgressHUD.showSuccess(withStatus: message)
                SVProgressHUD.dismiss(withDelay: 2)
                
            }
        }
    }
    
    @IBAction func forgetPassButton(_ sender: UIButton) {
        forgetPass.show()
    }
    
    //handle direct to instagram staff
    
    @IBAction func instagramButton(_ sender: Any) {
        _ = "instagram://user?username=easybazi.ir"
//        let instagramUrl = NSURL(string: instagramHooks)
//        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
//            UIApplication.shared.open(instagramUrl! as URL, options: [:], completionHandler: nil)
//        } else {
//            print("Opening instagram in safari")
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: "http://instagram.com/easybazi.ir")! as URL, options: [:], completionHandler: nil)
//        }
        
    }
    
// hnade telegram here
    
    @IBAction func telegramButton(_ sender: Any) {
         let telegramHooks = "https://telegram.me/easybazi"
         let telegramUrl = URL(string: telegramHooks)
        UIApplication.shared.open(telegramUrl!, options: [:], completionHandler: nil)

    }
    
    let alternativeView:UIView = {
      var view = UIView()
        view.backgroundColor = UIColor(red: 14/255, green: 22/255, blue: 33/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let userNameTF :UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.red
        tf.keyboardType = UIKeyboardType.asciiCapableNumberPad
        tf.attributedPlaceholder =
        NSAttributedString(string: "شماره موبایل", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        tf.textColor = UIColor.white
        tf.font = UIFont(name: "IRANSans", size: 15)
        return tf
    }()
    
    let userPhoneNumber1 :UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.red
        tf.font = UIFont(name: "IRANSans", size: 15)
        tf.textColor = UIColor.white
        tf.isSecureTextEntry = true
        tf.keyboardType = UIKeyboardType.default
        return tf
    }()
    
    let userPass1 :UITextField = {
        let tf = UITextField()
        tf.textAlignment = .right
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.red
        tf.attributedPlaceholder = NSAttributedString(string: "کد یکبار مصرف", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        tf.textColor = UIColor.white
        tf.keyboardType = UIKeyboardType.asciiCapableNumberPad
        tf.clipsToBounds = true
        tf.font = UIFont(name: "IRANSans", size: 14)
        return tf
    }()
    
    let seprator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.easyBaziTheme
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.85
        return view
        
    }()
    
    let seprator2:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.easyBaziTheme
        view.alpha = 0.85
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let registerButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 88/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle("دریافت کد تایید", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "IRANSans", size: 16)
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func registerButtonPressed(){
        view.endEditing(true)
        if segmentControl.selectedSegmentIndex == 0 {
            checkAndGetVerificationCode()
        }else{
            checkAndSignIn()
        }
    }
    let forgetPasswordButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 88/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle(" فراموشی رمز", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "IRANSans", size: 14)
        button.addTarget(self, action: #selector(passwordButtonTouched), for: .touchUpInside)
        return button
    }()
    @objc func passwordButtonTouched(){
        // recovery password here
    }

    var font:UIFont!
    var segmentControl:UISegmentedControl = {
        let sc = UISegmentedControl(items:["ثبت نام","ورود"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        sc.backgroundColor = UIColor(red: 18/255, green: 49/255, blue: 87/255, alpha: 1)
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        let attr:[AnyHashable:Any] = [NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.white]
        sc.setTitleTextAttributes(attr, for: UIControlState.normal)
        
        if #available(iOS 13.0, *) {
            sc.selectedSegmentTintColor = UIColor.easyBaziTheme
        } else {
            // Fallback on earlier versions
        }
        return sc
    }()
    var increaseBalance:IncreaseAccountBalance!
    var ReckoningViewContainer:ReckoningView!
    var forgetPass:ForgetPassword!
    var timer:Timer?
    let reckogningBtn1:UIButton = {
       var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.backgroundColor = UIColor.easyBaziTheme
        btn.setTitle("تسویه حساب", for: .normal)
        btn.titleLabel?.font = UIFont(name: "IRANSans", size: 13)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(handlReckoning), for: .touchDown)
        return btn
    }()
    //handle reckomimg staff here
    @objc func handlReckoning(){
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show(withStatus: "در حال ارسال کد فعالسازی... ")
        VerificationCode.sendForReckogning(getToken()) { (status, message) in
            if status == 1{
                SVProgressHUD.show(withStatus:message)
                SVProgressHUD.dismiss(withDelay: 3)
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let verificationVC = storyboard.instantiateViewController(withIdentifier: "signupVerificationVC") as? VerificationViewController
                verificationVC?.isForReckogning = true
                verificationVC?.phoneNumber = ""
                self.navigationController?.pushViewController(verificationVC!, animated: true)
                

            }else{
                SVProgressHUD.show(withStatus:message )
                SVProgressHUD.dismiss(withDelay: 3)
            }
          }
    }
    
    @objc func segmentChanged(){
        userNameTF.text = ""
        userPhoneNumber1.text = ""
        forgetButton.isHidden = segmentControl.selectedSegmentIndex == 0 ? true : false
        userNameContainerHeight?.isActive = false
        userNameContainerHeight = userNameTF.heightAnchor.constraint(equalTo: firstView.heightAnchor, multiplier: segmentControl.selectedSegmentIndex == 1 ? 1/5 : 1/5)
        userNameContainerHeight?.isActive = true
              registerButton.setTitle("", for: .normal)
        //change place holder's in pass & phone number
        if segmentControl.selectedSegmentIndex == 0 {
            registerButton.setTitle("دریافت کد تایید", for: .normal)
            userPhoneNumber1ContainerHeight?.isActive = false
            userPhoneNumber1ContainerHeight = userPhoneNumber1.heightAnchor.constraint(equalTo: alternativeView.heightAnchor, multiplier: 0)
            userPhoneNumber1ContainerHeight?.isActive = true
            
            userNameTopConstraint.isActive = false
            userNameTopConstraint = userNameTF.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16)
            userNameTopConstraint.isActive = true
            
            seperator2Height.isActive = false
        }else{
            userNameTopConstraint.isActive = false
            userNameTopConstraint = userNameTF.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8)
            userNameTopConstraint.isActive = true
            registerButton.setTitle("ورود", for: .normal)
            userPhoneNumber1ContainerHeight = userPhoneNumber1.heightAnchor.constraint(equalTo: alternativeView.heightAnchor, multiplier: 1/5)
            userPhoneNumber1ContainerHeight?.isActive = true
            seperator2Height = seprator2.heightAnchor.constraint(equalToConstant: 1)
            seperator2Height.isActive = true
            userPhoneNumber1.placeholder = "رمز عبور"
            userPhoneNumber1.attributedPlaceholder =
            NSAttributedString(string: "رمز عبور", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.6)])
            userPhoneNumber1.isSecureTextEntry = true
            userPhoneNumber1.keyboardType = .default
        }
        
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    fileprivate func addSubViewsToAltenativeView() {
        alternativeView.addSubview(segmentControl)
        alternativeView.addSubview(userNameTF)
        alternativeView.addSubview(userPhoneNumber1)
        alternativeView.addSubview(registerButton)
        alternativeView.addSubview(seprator)
        alternativeView.addSubview(seprator2)
    }
    @objc fileprivate func increaseAccountBalance(){
        increaseBalance.profileVC = self
        increaseBalance.show()
    }

    override func viewDidLoad() {
         super.viewDidLoad()
//        hidesBottomBarWhenPushed = true
        
        reckogningBtn.layer.cornerRadius = 4
        
        navigationController?.navigationBar.tintColor = UIColor.easyBaziTheme
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        userNameTF.delegate = self
        increaseBalance = IncreaseAccountBalance()
        mainButton.addTarget(self, action: #selector(increaseAccountBalance), for: .touchUpInside)
        font = UIFont(name: "IRANSans", size: 14)
        SVProgressHUD.setFont(font)
        let titleAttributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.foregroundColor : UIColor.white , NSAttributedStringKey.font:font]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        ReckoningViewContainer = ReckoningView()
        forgetPass = ForgetPassword()
        forgetPass.profileVC = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        hideKeyboardWhenTappedAround()
        forgetButton.isHidden = true
        userFinance.layer.cornerRadius = 5
        firstView.addSubview(alternativeView)
        alternativeViewSetup()
        addSubViewsToAltenativeView()
        setupSegmentControl()
        setupUN()
        setupE()
        setupP()
        setupRegister()
        setupSeprator()
        setupSeprator2()
        setupCounter()
        //setupForget()
        accountFinance.layer.cornerRadius = 4
        mainButton.layer.cornerRadius = 4
        firstView.layer.cornerRadius = 6
        secondView.layer.cornerRadius = 6
        view.backgroundColor = .gray
        print("first view \(firstView.isHidden)")
        print("alternative view \(alternativeView.isHidden)")
        if getToken() != ""{
            
            if getFullName() != ""{
                print("1")
                fullName.text = getFullName()
                alternativeView.isHidden = true
            }
        }else{
            print("2")
            alternativeView.isHidden = false
            mainButton.backgroundColor = UIColor.easyBaziGreen
            }
        print("first view 2 \(firstView.isHidden)")
        print("alternative view 2 \(alternativeView.isHidden)")
        }
    
    func setupCounter(){
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ProfileController.isMessageSeen{
            newMessage.alpha = 0
            ProfileController.isMessageSeen = !ProfileController.isMessageSeen
        }
//        ReachabilityManager.shared.addListener(listener: self)
        if getToken() != ""{
            print("here we are profile VC")
            isSingedIn = true
            forgetButton.isHidden = true
            reckogningBtn.isHidden = false
            alternativeView.isHidden = true
            firstView.isHidden = false
            getAccountFinance()
            NewMessage.Received(token: getToken()) { (count, status,message) in
                if status == 1{
           
                    if count != 0 && !ProfileController.isMessageSeen{
                            //Show New Message label
                        self.newMessage.font = UIFont(name: "IRANSans", size: 16)
                        self.newMessage.alpha = 1
                       
                    }else{
                        print("there is no new message")
                        self.newMessage.alpha = 0
                    }
                }
                else{
                    print("Error in new message & error is \(message)")
                }
            }
        }
    }
    
    @objc func keyboardWillShown(notification: NSNotification) {
        //let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        let inset = UIEdgeInsetsMake(0, 0, keyboardHeight!, 0)
        scroller.contentInset = inset
        scroller.scrollIndicatorInsets = inset
        var rect = self.view.frame
        rect.size.height  -= keyboardHeight!
    }
    @objc func keyboardWillHidden(notification: NSNotification) {
        let inset = UIEdgeInsets.zero
        scroller.contentInset = inset
        scroller.scrollIndicatorInsets = inset
    }
    var userPhoneNumber1ContainerHeight:NSLayoutConstraint?
    var userNameContainerHeight:NSLayoutConstraint?
    var passwordContainerHeight:NSLayoutConstraint?
    var registerHeight:NSLayoutConstraint?
    var forgetHeight:NSLayoutConstraint?
    var segmentHeight:NSLayoutConstraint?
    var sepratorHeight:NSLayoutConstraint?
    var oneTimebtnHeight:NSLayoutConstraint?

    var userPhoneNumber1LeftAnchor:NSLayoutConstraint?
    func setupSeprator(){
        seprator.topAnchor.constraint(equalTo: userNameTF.bottomAnchor).isActive = true
        seprator.rightAnchor.constraint(equalTo: alternativeView.rightAnchor ,constant: -15).isActive = true
        seprator.leftAnchor.constraint(equalTo: alternativeView.leftAnchor).isActive = true
        sepratorHeight = seprator.heightAnchor.constraint(equalToConstant: 1)
        sepratorHeight?.isActive = true
    }
    var seperator2Height:NSLayoutConstraint!
    func setupSeprator2(){
        seprator2.topAnchor.constraint(equalTo: userPhoneNumber1.bottomAnchor).isActive = true
        seprator2.rightAnchor.constraint(equalTo: alternativeView.rightAnchor, constant: -15).isActive = true
        seprator2.leftAnchor.constraint(equalTo: alternativeView.leftAnchor).isActive = true
        seperator2Height = seprator2.heightAnchor.constraint(equalToConstant: 1)
//        seperator2Height.isActive = true
    }
    func setupRegister(){
        registerButton.bottomAnchor.constraint(equalTo: alternativeView.bottomAnchor, constant:-8).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: alternativeView.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: alternativeView.widthAnchor, multiplier: 6/10, constant:6).isActive = true
        registerHeight = registerButton.heightAnchor.constraint(equalTo: alternativeView.heightAnchor, multiplier: 1/5)
        registerHeight?.isActive = true
    }
    func setupForget(){
        forgetPasswordButton.topAnchor.constraint(equalTo: userPass1.bottomAnchor).isActive = true
        forgetPasswordButton.leftAnchor.constraint(equalTo: registerButton.rightAnchor ).isActive = true
        forgetPasswordButton.rightAnchor.constraint(equalTo: alternativeView.rightAnchor).isActive = true
        forgetPasswordButton.widthAnchor.constraint(equalTo: alternativeView.widthAnchor, multiplier: 3/10).isActive = true
        forgetHeight = registerButton.heightAnchor.constraint(equalTo: alternativeView.heightAnchor, multiplier: 0)
        forgetHeight?.isActive = true
    }
    func setupSegmentControl(){
        segmentControl.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 2).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: firstView.widthAnchor, multiplier: 0.75).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        segmentHeight = segmentControl.heightAnchor.constraint(equalTo: firstView.heightAnchor , multiplier: 15/100)
        segmentHeight?.isActive = true
    }
    var userNameTopConstraint:NSLayoutConstraint!
    func setupUN(){
        userNameTF.leftAnchor.constraint(equalTo: alternativeView.leftAnchor).isActive = true
        userNameTopConstraint = userNameTF.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16)
        userNameTopConstraint.isActive = true
        userNameContainerHeight = userNameTF.heightAnchor.constraint(equalTo: alternativeView.heightAnchor, multiplier: 1/5)
        userNameContainerHeight?.isActive = true
        userNameTF.rightAnchor.constraint(equalTo: alternativeView.rightAnchor, constant: -15).isActive = true
    }
    func setupE(){
        
        userPhoneNumber1LeftAnchor = userPhoneNumber1.leftAnchor.constraint(equalTo: alternativeView.leftAnchor)
        userPhoneNumber1LeftAnchor?.isActive = true
        userPhoneNumber1.topAnchor.constraint(equalTo: userNameTF.bottomAnchor).isActive = true
        userPhoneNumber1.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        userPhoneNumber1ContainerHeight = userPhoneNumber1.heightAnchor.constraint(equalTo: alternativeView.heightAnchor, multiplier: 0)
//        userPhoneNumber1ContainerHeight?.isActive = true
        userPhoneNumber1.rightAnchor.constraint(equalTo: alternativeView.rightAnchor, constant: -15).isActive = true
    }
    func setupP(){
//        userPassLeftAnchor = userPass1.leftAnchor.constraint(equalTo: alternativeView.leftAnchor, constant: view.bounds.width * 1/6 + 16)
//        userPassLeftAnchor?.isActive = true
//        userPass1.topAnchor.constraint(equalTo: userPhoneNumber1.bottomAnchor).isActive = true
//        passwordContainerHeight  = userPass1.heightAnchor.constraint(equalTo: alternativeView.heightAnchor, multiplier: 1/5)
//        passwordContainerHeight?.isActive = true
//        userPass1.rightAnchor.constraint(equalTo: alternativeView.rightAnchor, constant: -15).isActive = true
    }

    
    func alternativeViewSetup(){
        alternativeView.topAnchor.constraint(equalTo: firstView.topAnchor).isActive  = true
        alternativeView.rightAnchor.constraint(equalTo: firstView.rightAnchor).isActive = true
        alternativeView.leftAnchor.constraint(equalTo: firstView.leftAnchor).isActive = true
        alternativeView.bottomAnchor.constraint(equalTo: firstView.bottomAnchor).isActive = true
    }
    //MARK : Helper Methods
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
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
           
                token = data.value(forKey: "token") as! String
            }
            print("Fetching Seccessfully")
        }catch{
            print("Fetching Error")
            
        }
        return token
    }
    func getUserPhoneNumber()->String{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        var userPhoneNumber = ""
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
           
                userPhoneNumber = data.value(forKey: "userPhoneNumber") as! String
            }
            print("Fetching Seccessfully")
        }catch{
            print("Fetching Error")
            
        }
        return userPhoneNumber
    }
    func getFullName()->String{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        var fullName = ""
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
           
                if data.value(forKey: "userName") != nil{
                    fullName = data.value(forKey: "userName") as! String
                }
            }
        }catch{
            print("Fetching Error")
            
        }
        return fullName
    }
    func eraseToken(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TokenEntity")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                context.delete(data)
                try context.save()
            }
            print("Erasing Seccessfully")
        }catch{
            print("Erasing Error")
            
        }
    }
    
    // validate sign up inputes
    func checkAndGetVerificationCode(){
        if userNameTF.text?.count != 0{
            if userNameTF.text!.count < 11 {
                let alert = UIAlertController(title: "توجه !!!", message: "شماره موبایل صحیح نمی باشد.", preferredStyle: UIAlertControllerStyle.alert)
                alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                alert.setValue(NSAttributedString(string:  "شماره موبایل صحیح نمی باشد." , attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
                alert.view.tintColor = UIColor.white
                self.present(alert, animated: true, completion: nil)
            }
            else{//inputs are OK!!!
                SVProgressHUD.setDefaultMaskType(.gradient)
                SVProgressHUD.show(withStatus: "در حال ارسال کد فعالسازی")
                VerificationCode.sendForSignup(userNameTF.text!) { (status, message) in
                    if status == 1{
                        SVProgressHUD.showSuccess(withStatus:message)
                        SVProgressHUD.dismiss(withDelay: 3)
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let signupVerificationVC = storyboard.instantiateViewController(withIdentifier: "signupVerificationVC") as?VerificationViewController
                        signupVerificationVC?.phoneNumber = self.userNameTF.text
                        signupVerificationVC?.isForReckogning = false
                        signupVerificationVC?.isForSignup = true
                        self.navigationController?.pushViewController(signupVerificationVC!, animated: true)
                        self.userNameTF.text = ""
                        
                    }else{
                        SVProgressHUD.show(withStatus:message )
                        SVProgressHUD.dismiss(withDelay: 3)
                    }
                  }
            }
        }
        else {
            let alert = UIAlertController(title: "توجه !!!", message: "لطفا تمامی .موارد را پر کنید", preferredStyle: UIAlertControllerStyle.alert)
            alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string: "لطفا تمامی موارد را پر کنید." , attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func checkAndSignIn(){
        if userPhoneNumber1.text?.count != 0 && userNameTF.text!.count != 0 {
            if userNameTF.text!.count < 11 {
                let alert = UIAlertController(title: "توجه !!!", message: "شماره موبایل صحیح نمی باشد.", preferredStyle: UIAlertControllerStyle.alert)
                alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                alert.setValue(NSAttributedString(string:  "شماره موبایل صحیح نمی باشد." , attributes: [NSAttributedStringKey.font :font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
                alert.view.tintColor = UIColor.white
                self.present(alert, animated: true, completion: nil)
            }else if (userPhoneNumber1.text?.count)! < 6  {
                let alert = UIAlertController(title: "توجه !!!", message: "پسورد حداقل .باید ۶ رقمی باشد", preferredStyle: UIAlertControllerStyle.alert)
                alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
                alert.setValue(NSAttributedString(string:  "پسورد حداقل باید ۶ رقمی باشد." , attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
                alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
                alert.view.tintColor = UIColor.white
                self.present(alert, animated: true, completion: nil)
            }
            else{
                SVProgressHUD.setFont(UIFont(name: "IRANSans", size: 12)!)
//                SVProgressHUD.setStatus("در حال انجام ...")
                SVProgressHUD.show(withStatus: "در حال انجام ...")
                
                SignIn.signInMethod(userNameTF.text!, password: userPhoneNumber1.text!, completion: { (status,message,data) in
                    if status == 1 {
                        guard let data = data else{
                            return
                        }
                        self.fullName.text = data.user.full_name
//                        self.phoneNumber = data.user.mobile
                        let message:String = message
                        let attributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : self.font])
                        SVProgressHUD.showSuccess(withStatus:attributedString.string)
                        SVProgressHUD.dismiss(withDelay: 3)
                        self.forgetButton.isHidden = true
                        self.reckogningBtn.isHidden = false
                        self.isSingedIn = true
                        self.alternativeView.isHidden = true
                        self.firstView.isHidden = false
                        self.eraseToken()
                        
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "TokenEntity", in:context)
                        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                        newEntity.setValue(data.token, forKey: "token")
                        newEntity.setValue(data.user.full_name, forKey: "userName")
                        newEntity.setValue(data.user.mobile, forKey:"userPhoneNumber")
                        do{
                            try context.save()
                        }catch{
                            print("Error While Saving Token")
                        }
                        self.getAccountFinance()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLogout"), object: nil)
                    }else{
                        SVProgressHUD.showError(withStatus: message)
                        SVProgressHUD.dismiss(withDelay: 4)
                        print("SigningIn Failed...")
                    }
                })
                
                
//                SignIn.signInMethod(userNameTF.text!, password: userPhoneNumber1.text!, completion: { (status,message,data) in
//                    if status == 1 {
//
//                        self.fullName.text = data.user.full_name
//                        let message:String = message
//                        let attributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.font : self.font])
//                        SVProgressHUD.showSuccess(withStatus:attributedString.string)
//                        SVProgressHUD.dismiss(withDelay: 3)
//                        self.forgetButton.isHidden = true
//                        self.reckogningBtn.isHidden = false
//                        self.isSingedIn = true
//                        self.alternativeView.isHidden = true
//                        self.firstView.isHidden = false
//                        self.eraseToken()
//
//                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                        let entity = NSEntityDescription.entity(forEntityName: "TokenEntity", in:context)
//                        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
//                        newEntity.setValue(data.token, forKey: "token")
//                        newEntity.setValue(data.user.full_name, forKey: "userName")
//                        do{
//                            try context.save()
//                        }catch{
//                            print("Error While Saving Token")
//                        }
//                        self.getAccountFinance()
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLogout"), object: nil)
//                    }else{
//                        SVProgressHUD.showError(withStatus: message)
//                        SVProgressHUD.dismiss(withDelay: 2)
//                        print("SigningIn Failed...")
//                    }
//                })
            }
        }
        else {
            let alert = UIAlertController(title: "توجه !!!", message: "لطفا تمامی .موارد را پر کنید", preferredStyle: UIAlertControllerStyle.alert)
            alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string: "لطفا تمامی موارد را پر کنید." , attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "باشه", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func getAccountFinance(){
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.color = UIColor.easyBaziTheme
        userFinance.text = ""
        indicator.tintColor = UIColor.easyBaziTheme
        financeContainer.addSubview(indicator)
        indicator.center = financeContainer.center
        indicator.startAnimating()
        self.userFinance.font = UIFont(name: "IRANSans", size: 13)
        UserFinance.get(getToken()) { (status, message, accountBalance) in
            if status == 1 {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                self.userFinance.font = UIFont(name: "IRANSans", size: 13)
                self.userFinance.text = self.convertToPersian(inputStr: "\(accountBalance.formattedWithSeparator)") + " تومان "
            }else{
                 indicator.stopAnimating()
                 indicator.removeFromSuperview()
                 self.userFinance.font = UIFont(name: "IRANSans", size: 13)
                 self.userFinance.text = "\(message)"
    
            }
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
    
    func convertToPersian(inputStr:String)-> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = inputStr
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
    
    //check phone and post code character count
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var temp:Bool = false
        if textField == userNameTF{
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            temp = newString.length <= maxLength
        }
        return temp
    }
    
    internal func increaseCredit(with link:String){
        let url = URL(string:link)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    func pushForgetPasswordVC(number:String){
        print("forget vc pushed!!!")
          let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let verificationVC = storyboard.instantiateViewController(withIdentifier: "signupVerificationVC") as? VerificationViewController
        verificationVC?.phoneNumber = number
        verificationVC?.isForReckogning = false
        verificationVC?.isForSignup = false
        navigationController?.pushViewController(verificationVC!, animated: true)
        self.userNameTF.text = ""
    }

}
