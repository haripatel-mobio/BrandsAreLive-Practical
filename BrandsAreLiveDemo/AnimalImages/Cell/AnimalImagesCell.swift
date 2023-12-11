//
//  AnimalImagesCell.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 10/12/23.
//

import UIKit
import Lottie

class AnimalImagesCell: UITableViewCell {

    @IBOutlet weak var animalNameView: UIView!
    @IBOutlet weak var animalNameTxt: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var likeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeAnimationView: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likeView.layer.cornerRadius = likeViewHeight.constant / 2
        likeView.isHidden = true
        
        animalNameView.layer.cornerRadius = animalNameView.frame.height / 2
        animalNameView.isHidden = true
        
        likeAnimationView.layer.cornerRadius = likeAnimationView.frame.height / 2
        likeAnimationView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)
        likeAnimationView.loopMode = .playOnce
        likeAnimationView.animationSpeed = 1
        likeAnimationView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}
