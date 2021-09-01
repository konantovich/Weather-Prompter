//
//  UserSettings.swift
//  Weather prompter
//
//  Created by Antbook on 31.08.2021.
//

import Foundation



final class UserSettings {
    
    private enum SettingsKeys: String {
        case userName
       
    }
    
   
        
    
    
    
    static var userName: String! {

        
        get {//get - поведение свойства при получение значения
            return UserDefaults.standard.string(forKey: SettingsKeys.userName.rawValue)
        } set {// set - поведение свойства когда мы запрашиваем
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userName.rawValue // получим от .rawValue  "userName"
            if let name = newValue { //newValue это то что мы получим обратно
                print("value: \(name) was add for key \(key)")
                defaults.set(name, forKey: key)
               
            } else { //если не выйдет добавить то удалим по ключу
                defaults.removeObject(forKey: key)
                
            }
        }
    }
    
    
    
}
