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
        tf.placeholder = "نام کاربری"
        tf.translatesAutoresizingMaskIntoConstraints = false
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
        tf.placeholder = "ایمیل"
        tf.translatesAutoresizingMaskIntoConstraints = false
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
        return button
    }()
    let passwordTextField :UITextField = {
        let tf = UITextField()
        tf.placeholder = " پسورد "
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
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
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
        seprator1.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        seprator1.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        seprator1.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        seprator1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        inputContainer.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        passwordContainerHeight = passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        passwordContainerHeight?.isActive = true
        
    
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
