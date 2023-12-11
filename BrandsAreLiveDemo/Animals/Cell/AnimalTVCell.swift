//
//  AnimalTVCell.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 07/12/23.
//

import UIKit

class AnimalTVCell: UITableViewCell {

    @IBOutlet weak var animalNameTxt: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
