//
//  SelectionOverlayView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 10/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    let plistM = PlistManager()
    var item: AppSettingsItem
    @ObservedObject var settingsVM = SettingViewModel()
    //@State private var selectedFrameworkIndex = 0
    
    

    var body: some View {
        VStack{
            options
            Spacer()
            controls
                
        }
        .padding()

    }
    
    var options: some View {
        VStack{
            HStack{
                Text("Debug Mode")
                    .frame(width: 100, alignment: .leading)
                
                
                
                Picker(selection: $settingsVM.debugItemsSelection, label: Text("")){
                    ForEach(0..<settingsVM.debugItems.count) {
                        Text(settingsVM.debugItems[$0])
                    }
                }
                .frame(width: 200, alignment: .leading)
            }
        }
        .frame(width: 600, height: 800, alignment: .top)
    }
    
    var controls: some View{
        HStack{
            Button("Confirm", action: {
                
                plistM.Write(settingItem: CreateItem(), plistName: "AppSettings")
            })
        }
    }
    
    func CreateItem() -> AppSettingsItem{
        var item = AppSettingsItem(Debug: settingsVM.debugItemsSelection == 0 ? true : false)
        return item
    }
//
//    func LoadPList(name: String) -> AppSettingsItem{
//        let item = plistM.Load(plistName: name)
//        return item
//    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
