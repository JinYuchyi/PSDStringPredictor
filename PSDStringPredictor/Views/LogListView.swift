//
//  LogListView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 9/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LogListView: View {
     @ObservedObject var logList = LogListData()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LogListView_Previews: PreviewProvider {
    static var previews: some View {
        LogListView()
    }
}
