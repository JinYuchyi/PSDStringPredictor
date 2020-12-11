//
//  SettingsViewModel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 11/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class SettingsViewModel: ObservableObject{
    
    func saveSettingItem() {
        // 1\. Create a concrete archiver
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        // 2\. Serialize object into archiver
        archiver.encodeObject(AppSettingsItem, forKey: "AppSettingsItem")
        archiver.finishEncoding()
        
        // 3\. Create the file
        data.writeToURL(fileUrl("EpisodeList.plist"), atomically: true)
    }
    
}
