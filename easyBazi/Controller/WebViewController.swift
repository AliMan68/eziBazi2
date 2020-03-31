//
//  WebViewController.swift
//  EziBazi2
//
//  Created by Ali Arabgary on 6/10/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import UIKit
import SafariServices

class WebViewController: UIViewController,SFSafariViewControllerDelegate {
    var url:URL!
    let webView:UIWebView = {
        var view = UIWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    var indicator:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//        indicator.backgroundColor = .red
//        indicator.color = .blue
        configeViews()

    }
    fileprivate func configeViews(){
        let url = URL(string: "https://www.varzesh3.com/")
        let safariBrowser  = SFSafariViewController(url: url!)
        self.present(safariBrowser, animated: true, completion: nil)
        safariBrowser.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {

        controller.dismiss(animated: true, completion: nil)
    }

}
