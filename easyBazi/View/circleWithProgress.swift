//
//  circleWithProgress.swift
//  EziBazi2
//
//  Created by AliArabgary on 3/27/19.
//  Copyright © 2019 AliArabgary. All rights reserved.
//

import UIKit

class CircleView: UIView {
    fileprivate let strokeEndTimingFunction   = CAMediaTimingFunction(controlPoints: 0.2,0.5,0.6,7.0)
    let scoreLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var width:CGFloat = 8 {
        didSet{
            scoreLayer.lineWidth = width
            trackLayer.lineWidth = width
        }
    }
    var rentPeriod:CGFloat = 0.0
    var remainDays = CGFloat(0.0) {
        didSet {
            self.remainedDaysLabel.text = convertToPersian(inputStr: "\(Int(remainDays))") + "روز"
            self.layoutIfNeeded()
        }
    }
    
    let remainedDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "IRANSans", size: 13)
        return label
    }()
    let remainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "مانده"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "IRANSans", size: 10)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() -> Void {
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(scoreLayer)
        
        addSubview(remainedDaysLabel)
        addSubview(remainLabel)
        NSLayoutConstraint.activate([
            remainedDaysLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            remainedDaysLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            remainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            remainLabel.topAnchor.constraint(equalTo: remainedDaysLabel.bottomAnchor, constant:-4)
            ])
    }
    func convertToPersian(inputStr:String)-> String {
                let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
                var str : String = inputStr
        
                for (key,value) in numbersDictionary {
                    str =  str.replacingOccurrences(of: key, with: value)
                }
                return str
            }
    //setup animation 4 circle here
    fileprivate func setuCircularAnimation(){
        let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        strokeEndAnimation.duration = 1.5
        strokeEndAnimation.values = [0.0, 1.0]
        strokeEndAnimation.keyTimes = [0.0, 1.0]
        scoreLayer.add(strokeEndAnimation, forKey: "strokeEnd")
//        trackLayer.add(strokeEndAnimation, forKey: "stroke")
        }
    
    fileprivate func configeLayers() {
        /*
         (CGFloat(remain/all) * CGFloat( 2 * CGFloat.pi)) - CGFloat.pi / 2
         
         
         */
        let percent = (rentPeriod - remainDays)/rentPeriod
        let endAngle = (CGFloat(percent) * CGFloat.pi * 2) - CGFloat.pi / 2
        trackLayer.frame = self.bounds
        scoreLayer.frame = self.bounds
//        scoreLayer.frame = CGRect(x: 10, y: 10,width: self.bounds.size.width - 10, height: self.bounds.size.height - 10)
        
        
        let centerPoint = CGPoint(x: self.bounds.size.width/2, y: self.bounds.height / 2.0)
        var radius:CGFloat = 0.0
        if self.bounds.size.width > self.bounds.size.height{
            radius = self.bounds.size.height / 2
        }else{
            radius = self.bounds.size.width / 2
        }
        // Track Layer Part
        let trackPath = UIBezierPath(arcCenter: centerPoint, radius: radius -  width, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = UIColor.easyBaziGreen.cgColor // to make different
        trackLayer.lineWidth = width
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        
        let scorePath = UIBezierPath(arcCenter: centerPoint, radius: radius  - width, startAngle: -CGFloat.pi / 2, endAngle: endAngle, clockwise: true)
        scoreLayer.path = scorePath.cgPath
        scoreLayer.strokeColor = UIColor.easyBaziTheme.cgColor
        scoreLayer.lineWidth = width
        scoreLayer.fillColor = UIColor.clear.cgColor
        scoreLayer.lineCap = kCALineCapRound
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configeLayers()
        setuCircularAnimation()
        
    }

    
}
