//
//  RegisterVC.swift
//  CRUDCoreDataSwift
//
//  Created by My Mac Mini on 09/01/24.
//

import UIKit
import PhotosUI

class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    
    
    private let manager =  DBHelper()
    private var isImageSelected: Bool = false
    
    var user: UserModelCoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setDataForUpdateScreen()
    }
   
    func setDataForUpdateScreen() {
        if let user {
            btnRegister.setTitle("Update", for: .normal)
            navigationItem.title = "Add New User"
            txtFirstName.text = user.firstName
            txtLastName.text = user.lastName
            txtEmail.text = user.email
            txtPass.text = user.password

            let imageURL = URL.documentsDirectory.appending(components: user.imageName ?? "").appendingPathExtension("png")
            imgUser.image = UIImage(contentsOfFile: imageURL.path)

            isImageSelected = true
        }else {
            btnRegister.setTitle("Register", for: .normal)
            navigationItem.title = "Update existing User"
            
        }
    }
     
    
   
  
    func setUpUI(){
       
        
         //adding gesture to image so that we can tap it
        let imageTap = UITapGestureRecognizer(target: self, action:  #selector(openGallery))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(imageTap)
        
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
    }
    
    
    @objc func openGallery(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // 0 - Unlimited

        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        
        guard let firstName = txtFirstName.text, !firstName.isEmpty else {
            openValidationAlert(message: "Please enter your first name")
            return
        }
        guard let lastName = txtLastName.text, !lastName.isEmpty else {
            openValidationAlert(message: "Please enter your last name")
            return
        }
        guard let email = txtEmail.text, !email.isEmpty else {
            openValidationAlert(message: "Please enter your email address")
            return
        }

        guard let password = txtPass.text, !password.isEmpty else {
            openValidationAlert(message: "Please enter your password")
            return
        }

        if !isImageSelected {
            openValidationAlert(message: "Please choose your profile image.")
            return
        }
        
        
        if let user {
          // Update User

            let newUser = UserModelSwift(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                imageName: user.imageName ?? ""
            )

            manager.updateUser(user: newUser, userEntity: user)
            saveImageToDocumentDirectory(imageName: newUser.imageName)
        }else {
            
            // Add User

            let imageName = UUID().uuidString
            let newUser = UserModelSwift(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                imageName: imageName
            )

            saveImageToDocumentDirectory(imageName: imageName)
            manager.addUser(newUser)
        }

        navigationController?.popViewController(animated: true)

        
    }
    
    func openValidationAlert(message: String){
        let alertController = UIAlertController(title: "Required", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
    
    func saveImageToDocumentDirectory(imageName: String) {
        let fileURL = URL.documentsDirectory.appending(components: imageName).appendingPathExtension("png")
        if let data = imgUser.image?.pngData() {
            do {
                try data.write(to: fileURL) // Save
            }catch {
                print("** Error Save image document:", error)
            }
        }
    }
    
   

 
}


// selecting image from gallary
extension RegisterVC: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            // Background Thread
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    // Main - UI related work
                    self.imgUser.image = image
                    self.isImageSelected = true
                }
            }
        }
    }
}
