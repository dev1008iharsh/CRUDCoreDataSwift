//
//  UserTVC.swift
//  UserCoreData
//
//  Created by Yogesh Patel on 09/05/23.
//

import UIKit

class UserTVC: UITableViewCell {

    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!

    var userModel: UserModelCoreData? {
        didSet { // Property Observer
            userConfiguration()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func userConfiguration() {
        guard let userModel else { return }
        lblFullName.text = (userModel.firstName ?? "") + " " + (userModel.lastName ?? "")
        lblEmail.text = "Email: \(userModel.email ?? "")"

        let imageURL = URL.documentsDirectory.appending(components: userModel.imageName ?? "").appendingPathExtension("png")
        imgProfile.image = UIImage(contentsOfFile: imageURL.path)
    }
    
}
