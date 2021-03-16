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
    @ObservedObject var settingsVM: SettingViewModel
    @State var DPICheck: Int = 1
    @State var debugMode: Int = 0
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
                TextField("Input Photoshop Path...", text: $PSPath, onCommit: { commitPSPath()})
                    .fixedSize()
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
        //print("PSPath: \(PSPath)")
        let item = AppSettingsItem(Debug: debugMode == 1 ? true : false,
                                   DPICheck: DPICheck == 1 ? true : false,
                                   PSPath: DataStore.PSPath
                                   )
        return item
    }
    
    func commitPSPath(){
        DataStore.PSPath = PSPath;
        plistM.Write(settingItem: CreateItem(), plistName: "AppSettings")
        settingsVM.debugItemsSelection = debugMode
        settingsVM.checkDPISelection = DPICheck
        print(DataStore.PSPath)
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
