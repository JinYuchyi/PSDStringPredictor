//
//  LogListView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 9/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LogListView: View {
    //@ObservedObject var logList: LogListData
    //@EnvironmentObject var data: DataStore

    var body: some View {

        List(DataStore.logListData, id: \.id){ item in
            LogObjectView(logObject: LogObject(id: item.id, content: item.content, time: "xxx_xxx", category: item.category ))
        }
    }
    

}

//struct LogListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogListView()
//    }
//}
