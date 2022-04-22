//
//  UserPrefs.swift
//  CellarPass Table App
//
//  Created by Diana Petrea on 30/01/2017.
//  Copyright © 2017 CellarPass. All rights reserved.
//

import UIKit

class UserPrefs {
    
    static func saveToDisk(key : String, value : Any?)
    {
        if value != nil {
            UserDefaults.standard.set(value, forKey: key)
        }
        else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    static func saveCGFloatToDisk(key: String, value: CGFloat?)
    {
        if let value = value {
            UserDefaults.standard.set(Float(value), forKey: key)
        }
        else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    static func loadFromDisk(key : String) -> String?
    {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func loadFromDisk(key : String) -> Int?
    {
        if hasKey(key: key) {
            return UserDefaults.standard.integer(forKey: key)
        }
        
        return nil
    }
    
    static func loadFromDisk(key: String) -> [Int]
    {
        if hasKey(key: key){
            return UserDefaults.standard.array(forKey: key) as! [Int]
        }
        
        return [Int]()
    }
    
    static func loadFromDisk(key : String) -> Bool?
    {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func loadFromDisk(key : String) -> CGFloat?
    {
        return CGFloat(UserDefaults.standard.float(forKey: key))
    }
    
    static func clearFromDisk(key : String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func hasKey(key : String) -> Bool
    {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    static func clearAllFromDisk()
    {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
    }
}
