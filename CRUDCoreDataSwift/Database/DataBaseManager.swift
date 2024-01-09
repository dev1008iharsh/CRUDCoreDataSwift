//
//  DBHelper.swift
//  CRUDCoreDataSwift
//
//  Created by My Mac Mini on 09/01/24.
//

import Foundation
import CoreData
import UIKit

class DataBaseManager{
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private func addUpdateUser(userEntity: UserModelCoreData, user: UserModelSwift) {
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.password = user.password
        userEntity.imageName = user.imageName
        saveContext()
    }

    func addUser(_ user: UserModelSwift) {
        let userEntity = UserModelCoreData(context: context) // navo user create kare
        addUpdateUser(userEntity: userEntity, user: user)
    }

    func updateUser(user: UserModelSwift, userEntity: UserModelCoreData) {
        addUpdateUser(userEntity: userEntity, user: user)
    }

 
    
    func fetchUsers() -> [UserModelCoreData] {
        var users: [UserModelCoreData] = []

        do {
            users = try context.fetch(UserModelCoreData.fetchRequest())
        }catch {
            print("*** Fetch user error", error)
        }

        return users
    }

    func saveContext() {
        do {
            try context.save() // aa karya vafar database ma save na thay
        }catch {
            print("*** User saving error", error)
        }
    }

    func deleteUser(userEntity: UserModelCoreData) {
        let imageURL = URL.documentsDirectory.appending(components: userEntity.imageName ?? "").appendingPathExtension("png")
        do {
            try FileManager.default.removeItem(at: imageURL)
        }catch {
            print("remove image from Document Directory", error)
        }
        context.delete(userEntity)
        saveContext()
    }

}
 
