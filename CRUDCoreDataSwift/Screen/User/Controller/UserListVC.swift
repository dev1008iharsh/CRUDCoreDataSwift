//
//  UserListVC.swift
//  CRUDCoreDataSwift
//
//  Created by My Mac Mini on 09/01/24.
//

import UIKit

class UserListVC: UIViewController {
    
    //MARK: -  @IBOutlet
    
    @IBOutlet weak var tblUserList: UITableView!
    
    
    //MARK: -  Properties
    private var arrUsers: [UserModelCoreData] = []
    private let manager = DataBaseManager()
    
    
    //MARK: -  ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUserList.register(UINib(nibName: "UserTVC", bundle: nil), forCellReuseIdentifier: "UserTVC")
        onBoardMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrUsers = manager.fetchUsers()
        print("** count :",arrUsers.count)
        tblUserList.reloadData()
    }
    
     
    //MARK: -  Buttons Actions
    @IBAction func btnAddNewUser(_ sender: UIBarButtonItem) {
        pushToAddEditVC()
    }
     
    //MARK: - Helper Functions
    func onBoardMessage(){
        let alertController = UIAlertController(title: "CRUD Operations", message: "You can perform crud operations using this application, by swiping the row you can update and delete the data.By using Plus button in right top corner you can add new user.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
    
    func pushToAddEditVC(userModel: UserModelCoreData? = nil) {
        guard let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else { return }
        registerVC.userModel = userModel
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}


//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension UserListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVC") as? UserTVC else {
            return UITableViewCell()
        }
        cell.userModel = arrUsers[indexPath.row]
        
        return cell
        /*
         
         Configure Default Cell without taking XIB
        let user = arrUsers[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
        
        content.secondaryText = "Email: \(user.email ?? "")"
       
        
        let imageURL = URL.documentsDirectory.appending(components:
        user.imageName ?? "").appendingPathExtension("png")
        content.image = UIImage(contentsOfFile: imageURL.path)
        
        var imagePro = content.imageProperties
        imagePro.maximumSize = CGSize(width: 80, height: 80)
        
        content.imageProperties.preferredSymbolConfiguration =
        .init(font: content.textProperties.font, scale: .large)
        
        content.imageProperties = imagePro
        
        cell.contentConfiguration = content // MIMP
         */
       
    }

}

extension UserListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.pushToAddEditVC(userModel: self.arrUsers[indexPath.row])
        }
        updateAction.backgroundColor = .systemCyan

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteUser(userEntity: self.arrUsers[indexPath.row]) // delete from Core Data
            self.arrUsers.remove(at: indexPath.row) // delete from Array
            self.tblUserList.reloadData() // Table Reload karna hai
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToAddEditVC(userModel: self.arrUsers[indexPath.row])
    }

}
