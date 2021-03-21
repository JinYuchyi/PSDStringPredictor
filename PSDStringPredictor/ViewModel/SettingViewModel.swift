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
    @Published var debugMode: Bool = true
    @Published var checkDPIItems = ["false", "true"]
    @Published var debugItemsSelection = 0
    @Published var checkDPISelection = 1
    let plistM = PlistManager.shared
    
    init(){
        appSettingItem = LoadPList(name: "AppSettings")
        debugItemsSelection = GetDebugSelectionList(appSettingItem)
        checkDPISelection = GetDPISelectionList(appSettingItem)
        DataStore.PSPath = GetPSPath(appSettingItem)
        debugMode = getDebugMode(appSettingItem)
    }
    
    func GetDebugSelectionList(_ item: AppSettingsItem) -> Int{
        if item.Debug == true{
            return 1
        }else{
            return 0
        }
    }
    
    func GetDPISelectionList(_ item: AppSettingsItem) -> Int{
        if item.DPICheck == true{
            return 1
        }else{
            return 0
        }
    }
    
    func GetPSPath(_ item: AppSettingsItem) -> String{
        DataStore.PSPath = item.PSPath
        return item.PSPath
    }

    func LoadPList(name: String) -> AppSettingsItem{
        let item = plistM.Load(plistName: name)
        return item
    }
    
    func getDebugMode(_ item: AppSettingsItem) -> Bool{
        return item.Debug
    }
}
