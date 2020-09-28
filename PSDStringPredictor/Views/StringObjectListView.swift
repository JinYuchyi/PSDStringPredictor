//
//  StringObjectListView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringObjectListView: View {
    @ObservedObject var stringObjectList = stringObjectViewModel
    //let listData = stringObjectList.stringObjectListData
    var body: some View {
        List(stringObjectList.stringObjectListData, id: \.id){ item in
            
            //init(_ content: String, _ stringRect: CGRect, _ observation: VNRecognizedTextObservation, _ charArray: [Character], _ charRacts: [CGRect])
            StringObjectRow(stringObject: item)
        }
    }
}
//
//struct StringObjectListView_Previews: PreviewProvider {
//    static var previews: some View {
//        StringObjectListView()
//    }
//}
