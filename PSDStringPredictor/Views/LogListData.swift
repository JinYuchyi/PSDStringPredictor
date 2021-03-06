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
import Combine

class LogListData: ObservableObject{
//    @Published var logListData = [
//        LogObject(id: 1, content: "Log 1", time: "xxx-xxx", category: LogObject.Category.normal),
//        LogObject(id: 2, content: "Log 2", time: "xxx-xxx", category: LogObject.Category.normal)
//    ]
    
    //@Published var data: DataStore = DataStore()
    
//    init(data: DataStore){
//        self.data = data
//    }
    
    func PushMsg(_ content: String, _ category: LogObject.Category){
        let id = DataStore.logListData.count + 1
        let obj = LogObject(content:content, time: GetTime(), category: category)
        DataStore.logListData.append(obj)
        if (DataStore.logListData.count > 10) {
            DataStore.logListData.removeFirst()
        }
        //print("Add log: " + String(obj.id) + ", " + obj.content)
    }
    
    func CleanMsg(){
        DataStore.logListData = []
        //print("Clean log, log length is: " + String(logListData.count))
    }
    

     func GetTime() -> String {
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dformatter.string(from: now)
        return str
    }
    

    
}
