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
    @ObservedObject var settingsVM = settingViewModel
    @State var DPICheck: Int = 1
    @State var debugMode: Int = 0
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
                
                Text("Debug Mode \(DPICheck)")
                    .frame(width: 100, alignment: .leading)
                Picker(selection: $debugMode, label: Text("")){
                    ForEach(0..<settingsVM.debugItems.count, id: \.self) {
                        Text(settingsVM.debugItems[$0])
                    }
                }
                .frame(width: 200, alignment: .leading)
            }
            
            HStack{
                Text("Check Load Image DPI")
                    .frame(width: 100, alignment: .leading)
                Picker(selection: $DPICheck, label: Text("")){
                    ForEach(0..<settingsVM.checkDPIItems.count, id: \.self) {
                        Text(settingsVM.checkDPIItems[$0])
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
                settingsVM.debugItemsSelection = debugMode
                settingsVM.checkDPISelection = DPICheck
            })
        }
    }
    
    func CreateItem() -> AppSettingsItem{
        var item = AppSettingsItem(Debug: debugMode == 1 ? true : false,
                                   DPICheck: DPICheck == 1 ? true : false
                                   )
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
