//
//  ControlPanel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ControlPanel: View {
    var body: some View {
        HStack{
            Button(action: {CreateStringObjects()}){
                Text("Generate Strings")
            }
        }
    }
}

struct ControlPanel_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanel()
    }
}

func CreateStringObjects(){
    //LogList.PushMsg(LogObject(id:2, content: "This is log 2", time: <#String#>, category: LogObject.Category.normal))
}



