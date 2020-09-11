//
//  StringObjectView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringObjectRow: View {
    var stringObject: StringObject
       //init(_ content: String, _ stringRect: CGRect, _ observation: VNRecognizedTextObservation, _ charArray: [Character], _ charRacts: [CGRect])
       var body: some View {
           HStack{
               Text(stringObject.content)
               Spacer()
               Text((stringObject.fontSize).description)
               Spacer()
            Text((stringObject.position[0]).rounded(.toNearestOrAwayFromZero).description + ", "+(stringObject.position[1]).rounded(.toNearestOrAwayFromZero).description)
           }
       }
}

//struct StringObjectRow_Previews: PreviewProvider {
//    static var previews: some View {
//        StringObjectRow(stringObject:stringObjectsData[0])
//    }
//}
