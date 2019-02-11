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
        Category(title: "فلل افتراضية", imageName: "VR.jpg"),
        Category(title: "فلل سكنية", imageName: "villa.jpg"),
        Category(title: "استشارات هندسية", imageName: "plan.jpg")
        
    ]
    
    func getCategories() -> [Category] {
        
        
        return categories
    }
    
    private let scenes = [
        Scene(title: "AljassasVilla", imageName: "Aljassas"),
        Scene(title: "AlArdiyaRestaurant", imageName: "ardiya")
    ]
    
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
