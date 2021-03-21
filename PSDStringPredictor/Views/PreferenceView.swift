//
//  SelectionOverlayView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 10/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    let plistM = PlistManager.shared
    var item: AppSettingsItem
    @ObservedObject var settingsVM: SettingViewModel
    @State var DPICheck: Int = 1
//    @State var debugMode: Bool = true
    @State var  PSPath: String = ""

    var body: some View {
        VStack{
            options
//            Spacer()
//            controls
        }
        .padding()

    }
    
    var options: some View {
        VStack{

            HStack{
                Text("Photoshop Path")
                    .frame(width: 100, alignment: .leading)
                TextField("Input Photoshop Path...", text: $PSPath, onCommit: { commitSetting()})
                    .fixedSize()
                .frame(width: 400, alignment: .leading)
            }
            
            HStack{
                Text("Debug Mode")
                    .frame(width: 100, alignment: .leading)
                Toggle(
                        isOn: Binding(
                            get: { settingsVM.debugMode },
                          set: { value in
                            settingsVM.debugMode = value
                            commitSetting()
                            // call function to send network request
                          }
                        ),
                        label: {
                          Text("")
                        }
                      )
                .frame(width: 400, alignment: .leading)
            }
            
        }
        .frame(alignment: .top)
    }
    
    var controls: some View{
        HStack{
            Button("Confirm", action: {
                
                
                //settingsVM.PSPath = PSPath
            })
        }
    }
    
    func CreateItem() -> AppSettingsItem{
        print("debug: \(settingsVM.debugMode)")
        let item = AppSettingsItem(Debug: settingsVM.debugMode ,
                                   DPICheck: DPICheck == 1 ? true : false,
                                   PSPath: DataStore.PSPath
                                   )
        return item
    }
    
    func commitSetting(){
        DataStore.PSPath = PSPath
        plistM.Write(settingItem: CreateItem(), plistName: "AppSettings")
        settingsVM.debugMode =  settingsVM.debugMode
        settingsVM.checkDPISelection = DPICheck
        
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
