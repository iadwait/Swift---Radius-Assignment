//
//  OptionsTableViewCell.swift
//  Radius_Assignment
//
//  Created by Adwait Barkale on 03/08/22.
//

import UIKit

/// This class is to control OptionsTVC
class OptionsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgViewOptions: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewStatus: UIImageView!

    // MARK: - Variable Declarations
    static let identifier = "OptionsTableViewCell"
    
    // MARK: - Initialization Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - User Defined Functions
    
    /// Function call to setup cell's UI
    func setupUI() {
        self.imgViewStatus.image = UIImage(named: UIConstants.shared.icon_SuccessCheck)
        self.imgViewStatus.isHidden = true
    }
    
}
