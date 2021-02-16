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
    @Published var debugItems = ["false", "true"]
    @Published var checkDPIItems = ["false", "true"]
    @Published var debugItemsSelection = 0
    @Published var checkDPISelection = 1
    @Published var PSPath = "/Applications/Adobe Photoshop 2020/Adobe Photoshop 2020.app"
    let plistM = PlistManager()
    
    init(){
        appSettingItem = LoadPList(name: "AppSettings")
        debugItemsSelection = GetDebugSelectionList(appSettingItem)
        checkDPISelection = GetDPISelectionList(appSettingItem)
        PSPath = GetPSPath(appSettingItem)
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
}
