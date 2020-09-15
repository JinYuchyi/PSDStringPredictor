//
//  LogObject.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 9/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LogObjectView: View {
    var logObject: LogObject
    
    var body: some View {
        HStack(alignment: .top){
            Text(logObject.category.rawValue+":")
                .multilineTextAlignment(.leading)
            
            Text(logObject.content)
                .multilineTextAlignment(.leading)
                .frame(width: 250)
            //Spacer()
            Text(logObject.time)
                .multilineTextAlignment(.trailing)
            
        }
    }
    
//    enum Category: String, CaseIterable, Codable, Hashable {
//        case normal = "Normal"
//        case warning = "Warning"
//        case error = "Error"
//    }
    

    
}

struct LogObjectView_Previews: PreviewProvider {
    static var previews: some View {
        LogObjectView(logObject: LogObject(id: 1, content: "This is a new log. This is a new log. This is a new log. This is a new log.", time: "xxx-xxx-xxx", category: LogObject.Category.normal))
            .frame(width: 400.0)
    }
}

 func GetTime() -> String {
    let now = Date()
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let str = dformatter.string(from: now)
    return str
}

