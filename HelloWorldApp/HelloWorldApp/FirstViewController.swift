//
//  FirstViewController.swift
//  HelloWorldApp
//
//  Created by Dmytro Lavoryk on 4/1/19.
//  Copyright © 2019 dlavoryk. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func GestureRecognized(_ sender: UITapGestureRecognizer) {
        if (FBSDKAccessToken.current() != nil)
        {
            performSegue(withIdentifier: "OnTap", sender: sender)
        }
    }
    
    @IBOutlet weak var TapIcon: UIImageView!
    
    @IBOutlet weak var p: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.isUserInteractionEnabled = true
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = p.center
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
        
    }
    
    
}

