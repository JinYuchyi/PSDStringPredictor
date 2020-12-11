//
//  SettingViewModel.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 11/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class SettingViewModel: ObservableObject {
    @Published var appSettingItem: AppSettingsItem =  AppSettingsItem()
    @Published var debugItems = ["true", "false"]
    @Published var debugItemsSelection = 0
    let plistM = PlistManager()
    
    init(){
        appSettingItem = LoadPList(name: "AppSettings")
        debugItemsSelection = GetDebugSelectionList(appSettingItem)
    }
    
    func GetDebugSelectionList(_ item: AppSettingsItem) -> Int{
        if item.Debug == true{
            return 0
        }else{
            return 1
        }
    }

    func LoadPList(name: String) -> AppSettingsItem{
        let item = plistM.Load(plistName: name)
        return item
    }
}
