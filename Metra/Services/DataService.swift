//
//  DataServices.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/6/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    //Variables
    var window: UIWindow?
    static let instance = DataService()

    
    private let categories = [
        Category(title: "ديكورات", imageName: "welcomeBG"),
        Category(title: "فلل افتراضية", imageName: "VR.jpg"),
        Category(title: "واجهات", imageName: "villa.jpg"),
       // Category(title: "استشارات هندسية", imageName: "plan.jpg"),
        Category(title: "صمم بيتك بنفسك", imageName: "draw-your-home.png"),
       
    ]
    func getCategories() -> [Category] {
        return categories
    }
 
    
    private let decores = [
        Product(username: "Zelal", commentTxt: "This is ", numLikes: 7, numComments: 0, timeStamp: Date(), productImage: "livingRoom0.jpg", documentId: "00", userId: Auth.auth().currentUser?.uid ?? ""),

        Product(username: "Aheen", commentTxt: "this is just beautiful..", numLikes: 3, numComments: 0,  timeStamp: Date(), productImage: "livingRoom1.jpg", documentId: "2", userId: Auth.auth().currentUser?.uid ?? "")

    ]
 
    private let designs = [
        Product(username: "Hanan", commentTxt: "T##String", numLikes: 3, numComments: 0,  timeStamp: Date(), productImage: "design0.jpg", documentId: "", userId: Auth.auth().currentUser?.uid ?? ""),

        ]
    
    private let plans = [
//        Product(title: "مخططات",imageName: "plan0.jpg", commentTxt: "yyy"),
//        Product(title: "مخططات",imageName: "plan1.jpg"),
//        Product(title: "مخططات",imageName: "plan2.jpg"),
//        Product(title: "مخططات",imageName: "plan3.jpg", commentTxt: "ggg")
        Product(username: "Belal", commentTxt: "T##String", numLikes: 1, numComments: 0, timeStamp: Date(), productImage: "plan0.jpg", documentId: "", userId: Auth.auth().currentUser?.uid ?? "")
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
