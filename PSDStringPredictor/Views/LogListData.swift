////
////  Log.swift
////  PSDStringPredictor
////
////  Created by ipdesign on 8/9/2020.
////  Copyright © 2020 ipdesign. All rights reserved.
////
//
//import SwiftUI
//
//struct LogList: View {
//    //var logObject: LogObject
//    @State var logObjectList: [LogObject] = []
//    //var logStrings: [String]
//    var body: some View {
//        //ScrollView([.horizontal, .vertical] , showsIndicators: true ){
//       // NavigationView{
//            List(logObjectList, id: \.id){ item in
//                LogObject(id: item.id, content: item.content, category: item.category)
//            }
//        //}
//    }
//
//    mutating func PushMsg(_ msg: LogObject){
//        logObjectList.append(msg)
//        if (logObjectList.count > 9) {
//            logObjectList.removeFirst()
//        }
//    }
//
//
//
//
//}
//
//struct Log_Previews: PreviewProvider {
//    static var previews: some View {
//        LogList(logObjectList: [
//            LogObject(id:2, content: "This is log 2", category: LogObject.Category.normal),
//            LogObject(id:3, content: "This is log 3", category: LogObject.Category.normal)
//        ])
//
//    }
//}
//
//
//

import Foundation

class LogListData: ObservableObject{
    @Published var logListData: [LogObject] = []

    func PushMsg(_ msg: LogObject){
        logListData.append(msg)
        if (logListData.count > 10) {
            logListData.removeFirst()
        }
    }
    
}
