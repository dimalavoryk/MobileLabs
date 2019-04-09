//
//  TableViewCell.swift
//  HelloWorldApp
//
//  Created by Dmytro Lavoryk on 4/9/19.
//  Copyright © 2019 dlavoryk. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var CommentLable: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var Img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if Img == nil
        {
            print("Image is nil")
        }
        // Configure the view for the selected state
    }

}
