//
//  ObjectTableViewCell.swift
//  The Museum
//
//  Created by Muhamad Septian Nugraha on 28/10/24.
//

import UIKit

class ObjectTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleList: UILabel!
    @IBOutlet weak var titleList: UILabel!
    @IBOutlet weak var imageList: UIImageView!
    @IBOutlet weak var homeBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        openingCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: - Set default object on Object Table View Cell
    func openingCell() {
        
        self.homeBackground.layer.cornerRadius = 10
        self.homeBackground.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = homeBackground.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        homeBackground.addSubview(blurEffectView)
        
        self.subtitleList.textColor = .white
        
        self.titleList.textColor = .white
        
        self.imageList.layer.cornerRadius = 5
        self.imageList.layer.masksToBounds = true
    }
    
}
