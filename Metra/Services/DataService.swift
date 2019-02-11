//
//  DataServices.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/6/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
class DataService {
    static let instance = DataService()
    
    private let categories = [
        Category(title: "ديكورات", imageName: "welcomeBG"),
        Category(title: "شاهد فلتك", imageName: "VR.jpg"),
        Category(title: "فلل سكنية", imageName: "villa.jpg"),
        Category(title: "استشارات هندسية", imageName: "plan.jpg")
        
    ]
    
    func getCategories() -> [Category] {
        
        
        return categories
    }
    
    private let livingRoom = [
        Product(title: "صالة", imageName: "livingRoom0.jpg"),
        Product(title: "صالة", imageName: "livingRoom1.jpg"),
        Product(title: "صالة", imageName: "livingRoom2.jpg"),
        Product(title: "صالة", imageName: "livingRoom3.jpg"),
        Product(title: "صالة", imageName: "livingRoom4.jpg"),
        Product(title: "صالة", imageName: "livingRoom5.jpg")
       
     
    ]
    
    private let bedRoom = [
        Product(title: "غرف نوم",imageName: "bedRoom0.jpg"),
        Product(title: "غرف نوم",imageName: "bedRoom1.jpg"),
        
        
    ]
    
    private let foodRoom = [
        Product(title: "غرف طعام",imageName: "foodRoom0.jpg")
    
        ]
    
    private let restaurant = [
        Product(title: "مطاعم",imageName: "restaurant0.jpg"),
        Product(title: "مطاعم",imageName: "restaurant1.jpg"),
         Product(title: "مطاعم",imageName: "restaurant2.jpg")
        
    ]
    
    private let kidRoom = [Product]()  //Empty
    private let scenes = [
        Scene(title: "AljassasVilla", imageName: "Aljassas"),
        Scene(title: "AlArdiyaRestaurant", imageName: "ardiya")
    ]
    
    func getProducts(forCategoryTitle title: String) -> [Product] {
        switch title {
        case "ديكورات":
           return  getLivingRoom()
        case "شاهد فلتك":
          return  getBedRoom()
        case "فلل سكنية":
          return getRestaurant()
        case "استشارات هندسية":
        return   getFoodRoom()
//        case "غرف أطفال":
//         return   getKidRoom()
        default:
              return  getLivingRoom()
        }
    }
    
    func getLivingRoom() -> [Product] {
        return livingRoom
    }
    
    func getBedRoom() -> [Product] {
        return bedRoom
    }
    
    func getFoodRoom() -> [Product] {
        return foodRoom
    }
    func getRestaurant() -> [Product] {
        return restaurant
    }
//    func getKidRoom() -> [Product] {
//        return kidRoom
//    }
    func getScenes() -> [Scene] {
        
        return scenes
    }
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(withSceneName sceneName: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            
        } else {
            REF_FEED.childByAutoId().updateChildValues(["sceneName": sceneName, "senderId": uid])
            sendComplete(true)
        }
    }
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
}
