//
//  ATBaseCurrencyTableViewCell.swift
//  ConverterProduct
//
//  Created by Omikron on 09.08.16.
//  Copyright © 2016 Omikron-Inc. All rights reserved.
//

import UIKit

class ATBaseCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        
        // Initialization code
    }
    
    func fillCell(abbr : String) {
        titleLabel.text = abbr
        flagImage.image = UIImage(named: abbr)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
