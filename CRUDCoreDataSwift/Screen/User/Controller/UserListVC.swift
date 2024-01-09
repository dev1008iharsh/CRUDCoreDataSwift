//
//  UserListVC.swift
//  CRUDCoreDataSwift
//
//  Created by My Mac Mini on 09/01/24.
//

import UIKit

class UserListVC: UIViewController {
    
    @IBOutlet weak var tblUserList: UITableView!
    private var users: [UserModelCoreData] = []
    private let manager = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUserList.register(UINib(nibName: "UserTVC", bundle: nil), forCellReuseIdentifier: "UserTVC")
        onBoardMessage()
    }
    
    func onBoardMessage(){
        let alertController = UIAlertController(title: "CRUD Operations", message: "You can perform crud operations using this application, by swiping the row you can update and delete the data.By using PLus button in right top corner you can add new user.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = manager.fetchUsers()
        print("** count :",users.count)
        tblUserList.reloadData()
    }
    
    @IBAction func btnAddNewUser(_ sender: UIBarButtonItem) {
        addUpdateUserNavigation()
    }
     
    func addUpdateUserNavigation(user: UserModelCoreData? = nil) {
        guard let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else { return }
        registerVC.user = user
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}

extension UserListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVC") as? UserTVC else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }

}

extension UserListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.addUpdateUserNavigation(user: self.users[indexPath.row])
        }
        update.backgroundColor = .systemIndigo

        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteUser(userEntity: self.users[indexPath.row]) // Core Data
            self.users.remove(at: indexPath.row) // Array
            self.tblUserList.reloadData() // Table Reload karna hai
        }

        return UISwipeActionsConfiguration(actions: [delete, update])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addUpdateUserNavigation(user: self.users[indexPath.row])
    }

}
