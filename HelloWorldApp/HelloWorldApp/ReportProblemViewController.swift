//
//  ReportProblemViewController.swift
//  HelloWorldApp
//
//  Created by Dmytro Lavoryk on 4/8/19.
//  Copyright © 2019 dlavoryk. All rights reserved.
//

import UIKit

class ReportProblemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    enum ImageSource {
        case photoLibrary
        case camera
    }

    
    @IBOutlet weak var mProblemPicker: UIPickerView!
    @IBOutlet weak var mCommentSection: UITextField!
    @IBOutlet weak var mTakePhotoButton: UIButton!
    @IBOutlet weak var mPreviewImg: UIImageView!
    
    @IBOutlet var mSwipeToSend: UISwipeGestureRecognizer!
    
    // @todo: get data from AppDelegate
    var pickerData: [String] = [String]()
    
    // @todo: read documentation
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        self.mProblemPicker.delegate = self
        self.mProblemPicker.dataSource = self
     
        let CurApp = UIApplication.shared.delegate as! AppDelegate
        pickerData = CurApp.ProblmesCategory
        
        // Do any additional setup after loading the view.
    }
    @IBAction func OnTakePhotoClicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System", size: 20)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerData[row]
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        guard let selectedImage = mPreviewImg.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    @IBAction func OnSwiped(_ sender: UISwipeGestureRecognizer) {
    
        
/*        let currentDateTime = Date()
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        // get the date time String from the date object
        let fileName = formatter.string(from: currentDateTime)
       
        let selectedDescription = pickerData[mProblemPicker.selectedRow(inComponent: 0)]
        let comment = mCommentSection.text
        let jsonArray = [selectedDescription, comment, fileName]

        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let pathDirectory = documentsDirectory
        
        try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)

        /// Use path from AppDelegate
        let CurApp = UIApplication.shared.delegate as! AppDelegate
        let fileDirectory = pathDirectory.appendingPathComponent(CurApp.DataFolder)
        
        let filePath = fileDirectory.appendingPathComponent(fileName)
        
        let json = try? JSONEncoder().encode(jsonArray)
        
        do {
            try json!.write(to: filePath)
        } catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
        }
        
        mPreviewImg.image?.saveToDocuments(filename: fileName)
*/
        /// Use path from AppDelegate
        let CurApp = UIApplication.shared.delegate as! AppDelegate
        CurApp.SharedNetworkService.UploadIssue(Category: pickerData[mProblemPicker.selectedRow(inComponent: 0)], Comment: mCommentSection.text ?? "DefaultComment", ImageToSave: mPreviewImg.image!, ImageName: "TestName", SuccessCallback: { (Category : String, Comment : String, Img : UIImage, ImgName : String, ID : String) in
            print("Successfully saved")
        }) { (Category : String, Comment : String, ImgName : String) in
            print("Failed to upload")
        }
        
        performSegue(withIdentifier: "GoToStart", sender: nil)
    }
}

extension ReportProblemViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        mPreviewImg.image = selectedImage
    }
}

extension UIImage {
    
    func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.pngData(){
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
}
