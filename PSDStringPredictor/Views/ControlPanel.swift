//
//  ControlPanel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ControlPanel: View {
    @ObservedObject var loglist: LogListData 
    
    func CreateStringObjects(){
        //loglist.PushMsg("Hi, This is the new log", LogObject.Category.normal)
        
    }
    
    var body: some View {
        Button(action: CreateStringObjects){
            Text("Predict")
        }
    }

}

//struct ControlPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPanel()
//    }
//}





