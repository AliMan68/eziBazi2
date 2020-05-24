//
//  AppDelegate.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/13/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    var url:String = "http://ittiktak.ir/public"
    var url:String = "https://www.easyBazi.ir"
    var window: UIWindow?
    var rentTypes:[rentType] = [
    rentType(id: 1, day_count: 7, price_percent: 8),
    rentType(id: 2, day_count: 10, price_percent: 10),
    rentType(id: 3, day_count: 15, price_percent: 13),
    rentType(id: 4, day_count: 30, price_percent: 20),
    ]
    internal func makeCircular(_ view:UIView){
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/5
        view.clipsToBounds = true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //getRentTypes()
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 16)!,NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.baselineOffset:NSNumber(1)],
                                    for: .normal)
//        UIBarButtonItem.appearance()
//            .setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 16)!,NSAttributedStringKey.foregroundColor:UIColor.white],
//                                    for: .selected)
        UITabBar.appearance().tintColor = UIColor.easyBaziTheme
        UITabBar.appearance().backgroundColor = UIColor.navAndTabColor
        
//      let attr = NSDictionary(object: UIFont(name: "IRANSans", size: 14)!, forKey: NSAttributedStringKey.font as NSCopying)
//      UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        UISearchBar.appearance().tintColor = UIColor.easyBaziTheme
        UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
        UITextField.appearance().semanticContentAttribute = .forceRightToLeft
        UITextField.appearance().makeTextWritingDirectionLeftToRight(nil)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 11) as Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "IRANSans", size: 13) as Any], for    : .selected)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 8, vertical: -1)
        
        //add intro pages to app here
//
//        let defaults = UserDefaults.standard
//        if defaults.object(forKey: "isFirstTime") == nil {
//            print("Intro vc showing now...")
//            defaults.set("No", forKey:"isFirstTime")
//                window = UIWindow()
//                window?.makeKeyAndVisible()
//                let layout = UICollectionViewFlowLayout()
//                layout.scrollDirection = .horizontal
//                window?.rootViewController = SwipingController(collectionViewLayout:layout)
//          }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//         ReachabilityManager.shared.stopMonitoring()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  
    }
    //get all 0types and percents
     fileprivate func getRentTypes(){

         let rentTypesUrl = "\(url)/api/rent-type"
         RentTypes.get(rentTypesUrl) { (typesArray, status, message) in
             if status == 1{
                 self.rentTypes = typesArray
             }else{
                 print("Err in Home VC")
             }
         }
     }

    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//         ReachabilityManager.shared.startMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
     func dateConvertor(from string:String )->String{
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
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
//    MARK : -loading html first
    
    func loadHtmls(){
        
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}


