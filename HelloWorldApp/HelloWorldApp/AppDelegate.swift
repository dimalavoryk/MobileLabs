//
//  AppDelegate.swift
//  HelloWorldApp
//
//  Created by Dmytro Lavoryk on 4/1/19.
//  Copyright © 2019 dlavoryk. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public let SharedNetworkService : NetworkService
    
    var window: UIWindow?
    
    
    public let DataFolder : String
   
    private let mDataTableName : String
    private let mAppURLString : String
    private let mConnectionString_1 : String

    public let ConnectionKey_1 : String
    public let StorageAccountName : String
    public let ProblmesCategory : [String]
    
    var sharedInstance : FBSDKApplicationDelegate?
    
    
    override init() {
        // Init basic variables from PLIST to use them everywhere
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
        ConnectionKey_1 = nsDictionary!["ConnectionKey_1"] as! String

        mConnectionString_1 = nsDictionary!["ConnectionString_1"] as! String
        mAppURLString = nsDictionary!["AppURLString"] as! String
        mDataTableName = nsDictionary!["DataTableName"] as! String

        StorageAccountName = nsDictionary!["StorageAccountName"] as! String
        DataFolder = nsDictionary!["DataFolder"] as! String
        
        SharedNetworkService = NetworkService(AppURLString: mAppURLString, DataTableName : mDataTableName, ConnectionString : mConnectionString_1)
        ProblmesCategory = nsDictionary!["ProblemsCategory"] as! [String]
        super.init()
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return handled
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let fileManager = FileManager.default
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let MyFilesPath = documentsURL.appendingPathComponent(DataFolder)
        do
        {
            try FileManager.default.createDirectory(atPath: MyFilesPath.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        // Connect to Azure Service
    //    Add the following code to your AppDelegate.swift file in the application:didFinishLaunchingWithOptions function
        

        
//        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        //let FBClient = FBSDKApplicationDelegate
        
        
   /*
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let client = delegate.client!
        let item = ["text":"LOL", "complete":true] as [String : Any]
        let itemTable = client.table(withName: "todoitem")
        
        itemTable.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    print("Todo Item: ", item["text"])
                }
            }
        }
        */
/*
        itemTable.insert(item) {
            (insertedItem, error) in
            if error == nil {
                NSLog("Error" + error.debugDescription);
            } else {
                NSLog("Item inserted, id: " + (insertedItem?["id"] as! String))
            }
        }
*/
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

