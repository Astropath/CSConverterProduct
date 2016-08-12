//
//  ARConvertTableViewCell.swift
//  ConverterProduct
//
//  Created by Omikron on 09.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import UIKit

class ARConvertTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        // Initialization code
    }
    
    func fillCell(value : Double, imageName: String) {
        titleLabel?.text = String(format:"%.2f", value)
        flagImage.image = UIImage(named: imageName)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
