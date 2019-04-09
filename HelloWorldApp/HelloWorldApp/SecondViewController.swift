//
//  SecondViewController.swift
//  HelloWorldApp
//
//  Created by Dmytro Lavoryk on 4/1/19.
//  Copyright © 2019 dlavoryk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var mTable: UITableView!
    
    @IBOutlet weak var MyImage: UIImageView!
    
    var data: [RowModel] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
/*        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
  */
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let problem = data[indexPath.row]
        cell.DescriptionLabel.text = problem.description
        cell.CommentLable.text = problem.comment
        cell.Img.image = problem.img
        //cell.textLabel?.text = data[indexPath.row].description
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mTable.delegate = self
        self.mTable.dataSource = self
        
        let fm = FileManager.default
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let pathDirectory = documentsDirectory
        
        try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
        do{
        let items = try fm.contentsOfDirectory(atPath: pathDirectory.path)
            for item in items {
                print("Image?? \(item)")
            }
        }catch{}
        
        let path = pathDirectory.appendingPathComponent("MyFilesPath_001")
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path.path)
            
            for item in items {
                print("Found \(item)")
                let ObjPath = path.appendingPathComponent(item)
                let data =
                    try Data(contentsOf: URL(fileURLWithPath: ObjPath.path), options: .mappedIfSafe)
            //    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

               guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
                
                var LoadedImg = UIImage()
                LoadedImg = LoadedImg.load(image: personArray[2])
                let Row = RowModel(img: LoadedImg, comment: personArray[1], description: personArray[0])
             
                self.data.append(Row)
            }
            
        } catch {
            // failed to read directory – bad permissions, perhaps?
            
        }
    }


}


extension UIImage {
    func load(image imageName: String) -> UIImage {
        // declare image location
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName)"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        // check if the image is stored already
        if FileManager.default.fileExists(atPath: imagePath),
            let imageData: Data = try? Data(contentsOf: imageUrl),
            let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) {
            return image
        }
        
        // image has not been created yet: create it, store it, return it
        let newImage: UIImage = UIImage()// create your UIImage here
       //     try? UIImagePNGRepresentation()?.write(to: imageUrl)
        return newImage
    }
}
