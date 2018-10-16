//
//  SignInVC.swift
//  EziBazi2
//
//  Created by AliArabgary on 10/15/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
 class SignInVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userName:UITextField!
    @IBOutlet weak var email:UITextField!
    let inputContainer:UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let seprator:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ezibaziThem
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    let userNameTextField :UITextField = {
       let tf = UITextField()
        tf.textAlignment = .natural
        tf.contentHorizontalAlignment = .right
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder =
            NSAttributedString(string: "User Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.textColor = UIColor.white
        return tf
    }()
    let seprator1:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ezibaziThem
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    let emailTextField :UITextField = {
        let tf = UITextField()
        tf.contentHorizontalAlignment = .left
        tf.textColor = UIColor.white
        tf.placeholder = "Email"
        tf.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
//        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.writingDirection: NSWritingDirection.rightToLeft ] forKey: "attributedPlaceholder")
//
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.red
        return tf
    }()
    let registerButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 88/255, green: 101/255, blue: 161/255, alpha: 1)
        button.setTitle(" ثبت نام  ", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "IRAN_Sans", size: 16)
        button.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
        return button
    }()
    @objc func buttonTouched(){
        if emailTextField.text?.count != 0 && passwordTextField.text?.count != 0 && userNameTextField.text?.count != 0{
        if !isValidEmail(testStr: emailTextField.text!) {
            let alert = UIAlertController(title: "توجه !!!", message: "فرمت ایمیل وارد شده غلط است", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string:  "فرمت ایمیل وارد شده غلط است" , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.white]), forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "اوکی", style: .destructive, handler: nil))
            alert.view.tintColor = UIColor.white
            self.present(alert, animated: true, completion: nil)
        }else if (passwordTextField.text?.count)! < 7 {
            let alert = UIAlertController(title: "توجه !!!", message: "پسورد حداقل باید ۶ رقمی باشد", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string:  "پسورد حداقل باید ۶ رقمی باشد" , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.white]), forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "اوکی", style: .destructive, handler: nil))
            alert.view.tintColor = UIColor.white
            self.present(alert, animated: true, completion: nil)
        
            }
        else{
            print("Hello My Hero")
            SignUP.signUpMethod(userNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, completion: { (token,statusCode) in
                if statusCode == 1 {
                    print("Registered Successfully...Horaaa")
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }else{
                    print("Registered Failed...")
                }
                
                
            })
            }
    }
       else {
            let alert = UIAlertController(title: "توجه !!!", message: "لطفا تمامی موارد را پر کنید", preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.setValue(NSAttributedString(string: "توجه !!!", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string: "لطفا تمامی موارد را پر کنید" , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.white]), forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: "اوکی", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    let passwordTextField :UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.white
        tf.setTextIcon(icon: UIImage(named:"lock")!)
        tf.placeholder = "Password"
        tf.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tf.tintColor = UIColor.red

        
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var segmentControl:UISegmentedControl = {
        let sc = UISegmentedControl(items:["ثبت نام","ورود"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    @objc func segmentChanged(){
        let title = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        inputContainerHeight?.constant = segmentControl.selectedSegmentIndex == 1 ? 100 : 150
        emailContainerHeight?.isActive = false
        emailContainerHeight = emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: segmentControl.selectedSegmentIndex == 1 ? 0 : 1/3)
        emailContainerHeight?.isActive = true
        passwordContainerHeight?.isActive = false
        passwordContainerHeight = passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: segmentControl.selectedSegmentIndex == 1 ? 1/2 : 1/3)
        passwordContainerHeight?.isActive = true
        userNameContainerHeight?.isActive = false
        userNameContainerHeight = userNameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: segmentControl.selectedSegmentIndex == 1 ? 1/2 : 1/3)
        userNameContainerHeight?.isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inputContainer.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        view.addSubview(inputContainer)
        view.addSubview(registerButton)
        view.addSubview(segmentControl)
        containerConstrant()
        buttonConstrant()
        setupSegmentControl()
       
        
    }
    
    func setupSegmentControl(){
        segmentControl.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -12).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, multiplier: 0.75).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    var inputContainerHeight:NSLayoutConstraint?
    var emailContainerHeight:NSLayoutConstraint?
    var userNameContainerHeight:NSLayoutConstraint?
    var passwordContainerHeight:NSLayoutConstraint?
    func containerConstrant(){
        // Set X , Y , Width , Height
    inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
    inputContainerHeight = inputContainer.heightAnchor.constraint(equalToConstant: 150)
    inputContainerHeight?.isActive = true
    inputContainer.layer.cornerRadius = 5
    inputContainer.layer.masksToBounds = true
    inputContainer.addSubview(userNameTextField)
    userNameTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
    userNameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        userNameContainerHeight = userNameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        userNameContainerHeight?.isActive = true
    inputContainer.addSubview(seprator)
        seprator.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        seprator.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        seprator.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        seprator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        inputContainer.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12 ).isActive = true
        emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        emailContainerHeight =  emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        emailContainerHeight?.isActive = true
        inputContainer.addSubview(seprator1)

        inputContainer.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        passwordContainerHeight = passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        passwordContainerHeight?.isActive = true
        seprator1.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        seprator1.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
        seprator1.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        seprator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    
    }
    func buttonConstrant(){
        //Set X , Y , Width , Height
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor , constant: 8).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }


}
extension UITextField {
    
    func setTextIcon(icon: UIImage) {
        let imageView = UIImageView()
        imageView.image = icon
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        view.backgroundColor = UIColor.clear
        view.addSubview(imageView)
        self.rightViewMode = .always
        self.rightView = view
    }
    
}
