//
//  NetworkService.swift
//  HelloWorldApp
//
//  Created by Dmytro Lavoryk on 5/5/19.
//  Copyright © 2019 dlavoryk. All rights reserved.
//

import Foundation


class NetworkService
{
    private let mClient: MSClient
    private let mTable : MSTable
    private let mAccount : AZSCloudStorageAccount
    
    init(AppURLString : String, DataTableName : String, ConnectionString : String) {
        self.mClient = MSClient(applicationURLString: AppURLString)
        self.mTable = self.mClient.table(withName: DataTableName)
        do {
            try self.mAccount = AZSCloudStorageAccount(fromConnectionString : ConnectionString)
        }
        catch{
            abort()
       }
        
      //  self.mClient.login(withProvider: "facebook", token: ["access_token":accessToken]) { (user : MSUser?, error : Error?) in
            
        //}
    }
    
    func UploadIssue(Category : String, Comment : String, ImageToSave : UIImage, ImageName : String,
                     SuccessCallback : @escaping (_ Category : String, _ Comment : String, _ ImageToSave : UIImage, _ ImageName : String, _ ItemID : String) -> Void,
                     ErrorCallback : @escaping (_ Category : String, _ Comment : String, _ ImageName : String) -> Void)
    {
        
        let item = ["Category" : Category, "Comment" : Comment, "ImageName" : ImageName] as [String : Any]
        mTable.insert(item) {
            (insertedItem, error) in
            if error != nil {
                NSLog("Error" + error.debugDescription);
                ErrorCallback(Category, Comment, ImageName)
            } else {
                NSLog("Item inserted, id: " + (insertedItem?["id"] as! String))
                
                let blobClient: AZSCloudBlobClient = self.mAccount.getBlobClient()
                let ItemID = insertedItem?["id"] as! String
                let blobContainer: AZSCloudBlobContainer = blobClient.containerReference(fromName : ItemID)
                blobContainer.createContainerIfNotExists(with: AZSContainerPublicAccessType.container, requestOptions: nil, operationContext: nil)
                {
                    (NSError, Bool) -> Void in
                    if ((NSError) != nil)
                    {
                        NSLog("Error in creating container.")
                        ErrorCallback(Category, Comment, ImageName)
                    }
                    else
                    {
                        let blob: AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: ImageName as String)
                        
                        let imageData = ImageToSave.pngData()
                        
                        blob.upload(from: imageData!, completionHandler:{
                                (NSError) -> Void in NSLog("Ok, uploaded !")
                                SuccessCallback(Category, Comment, ImageToSave, ImageName, ItemID)
                        })
                    }
                }
            }
        }
    }
    
    func LoadAllData (ElementLoadedCallback : @escaping (_ Category : String, _ Comment : String, _ Image : UIImage, _ ImageName : String) -> Void,
                      ErrorCallback : @escaping () -> Void)
    {
        mTable.read { (result, error) in
            if let err = error
            {
                print("ERROR ", err)
            }
            else if let items = result?.items
            {
                for item in items
                {
                    let blobClient: AZSCloudBlobClient = self.mAccount.getBlobClient()
                    let ItemID = item["id"] as! String
                    let blobContainer: AZSCloudBlobContainer = blobClient.containerReference(fromName : ItemID)
                    
                    
                    let blob = blobContainer.blockBlobReference(fromName: item["ImageName"] as! String)
                    print(blob)
                    blob.downloadToData(with: nil, requestOptions: nil, operationContext: nil, completionHandler:
                        { (ResError : Error?, ResData : Data?) in
                            print ("downloaded??????")
                            if ResError != nil
                            {
                                print("Error loading data")
                                ErrorCallback()
                            }
                            else if ResData != nil
                            {
                                let Img : UIImage? = UIImage(data: ResData!)
                                if (Img != nil)
                                {
                                    ElementLoadedCallback(item["Category"] as! String, item["Comment"] as! String, Img!, item["ImageName"] as! String)
                                }
                                else{
                                    print("Error creating image")
                                    ErrorCallback()
                                }
                            }
                            else
                            {
                                print("Data is null")
                                ErrorCallback()
                            }
                    })
                    print("After started downloading")
                }
            }
        }
    }
    
    
    func LoadCategories (ElementLoadedCallback : @escaping (_ Categories : [String]) -> Void,
                      ErrorCallback : @escaping () -> Void)
    {
        let query = mTable.query()
        query.selectFields = ["Category"]
        query.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                
                var Res : [String] = [String]()
                
                for item in items {
                    Res.append(item["Category"] as! String)
                }
                ElementLoadedCallback(Res)
            }
        }
    }
    
    
}
