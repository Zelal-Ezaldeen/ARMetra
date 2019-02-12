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
    var window: UIWindow?
    
    static let instance = DataService()
    private let categories = [
        Category(title: "ديكورات", imageName: "welcomeBG"),
        Category(title: "فلل افتراضية", imageName: "VR.jpg"),
        Category(title: "واجهات", imageName: "villa.jpg"),
        Category(title: "استشارات هندسية", imageName: "plan.jpg")
        
    ]
    
    func getCategories() -> [Category] {
        return categories
    }
    
    private let decores = [
        Product(title: "صالة", imageName: "livingRoom0.jpg"),
        Product(title: "صالة", imageName: "livingRoom1.jpg"),
        Product(title: "صالة", imageName: "livingRoom2.jpg"),
        Product(title: "صالة", imageName: "livingRoom3.jpg"),
        Product(title: "صالة", imageName: "livingRoom4.jpg"),
        Product(title: "صالة", imageName: "livingRoom5.jpg"),
        Product(title: "غرف نوم",imageName: "bedRoom0.jpg"),
        Product(title: "غرف نوم",imageName: "bedRoom1.jpg"),
        Product(title: "غرف طعام",imageName: "foodRoom.jpg"),
        Product(title: "مطاعم",imageName: "restaurant0.jpg"),
        Product(title: "مطاعم",imageName: "restaurant1.jpg"),
        Product(title: "مطاعم",imageName: "restaurant2.jpg"),
        Product(title: "مكاتب تجارية",imageName: "office0.jpg"),
        Product(title: "مكاتب تجارية",imageName: "office1.jpg"),
        Product(title: "مكاتب تجارية",imageName: "office2.jpg"),
        Product(title: "مكاتب تجارية",imageName: "office3.jpg"),
        Product(title: "مكاتب تجارية",imageName: "office4.jpg"),
        Product(title: "مكاتب تجارية",imageName: "office5.jpg")
        
     
    ]
 
    private let designs = [
        Product(title: "واجهات",imageName: "design0.jpg"),
        Product(title: "واجهات",imageName: "design1.jpg"),
        Product(title: "واجهات",imageName: "design2.jpg"),
        Product(title: "واجهات",imageName: "design3.jpg"),
        Product(title: "واجهات",imageName: "design4.jpg"),
        Product(title: "واجهات",imageName: "design5.jpg"),
        Product(title: "واجهات",imageName: "design6.jpg"),
        Product(title: "واجهات",imageName: "design7.jpg"),
        Product(title: "واجهات",imageName: "design8.jpg"),
        Product(title: "واجهات",imageName: "design9.jpg"),
        Product(title: "واجهات",imageName: "design10.jpg"),
        Product(title: "واجهات",imageName: "design11.jpg"),
        Product(title: "واجهات",imageName: "design12.jpg"),
        Product(title: "واجهات",imageName: "design13.jpg"),
        Product(title: "واجهات",imageName: "design14.jpg"),
        Product(title: "واجهات",imageName: "design15.jpg")
        ]
    
    private let plans = [
        Product(title: "مخططات",imageName: "plan0.jpg"),
        Product(title: "مخططات",imageName: "plan1.jpg"),
        Product(title: "مخططات",imageName: "plan2.jpg"),
        Product(title: "مخططات",imageName: "plan3.jpg")
    ]
    
    private let kidRoom = [Product]()  //Empty
    private let scenes = [
        Scene(title: "AljassasVilla", imageName: "Aljassas"),
        Scene(title: "AlArdiyaRestaurant", imageName: "ardiya")
    ]
    
    func getProducts(forCategoryTitle title: String) -> [Product] {
        switch title {
        case "ديكورات":
           return  getDecores()
      
        case "واجهات":
          return getDesigns()
        case "استشارات هندسية":
        return   getPlans()
//        case "غرف أطفال":
//         return   getKidRoom()
        default:
              return  getDecores()
        }
    }
    
    func getDecores() -> [Product] {
        return decores
    }
    
    func getDesigns() -> [Product] {
        return designs
    }
    func getPlans() -> [Product] {
        return plans
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
