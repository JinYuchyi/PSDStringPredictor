//
//  PlistManager.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 11/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class PlistManager{
    
    static let shared = PlistManager()
    
    private init(){}
    
    func Load(plistName: String) -> AppSettingsItem {
//        var plistURL: URL
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        plistURL = documents.appendingPathComponent("\(plistName).plist")
        let decoder = PropertyListDecoder()

        let plistPath:String? = Bundle.main.path(forResource: plistName, ofType: "plist")!
        guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: plistPath!)),
              let settingItem = try? decoder.decode(AppSettingsItem.self, from: data)
        else {
            print("Decode problem from plist.")
            return AppSettingsItem()}
        
        return settingItem
    }
    
    func Write(settingItem: AppSettingsItem, plistName: String) {
//        var plistURL: URL
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        plistURL = documents.appendingPathComponent("\(plistName).plist")
        let plistPath:String? = Bundle.main.path(forResource: plistName, ofType: "plist")!
        let encoder = PropertyListEncoder()

        if let data = try? encoder.encode(settingItem) {
            if FileManager.default.fileExists(atPath: plistPath!) {
            // Update an existing plist
            try? data.write(to: URL.init(fileURLWithPath: plistPath!))
          } else {
            // Create a new plist
            FileManager.default.createFile(atPath: plistPath!, contents: data, attributes: nil)
          }
        }
      }
}
