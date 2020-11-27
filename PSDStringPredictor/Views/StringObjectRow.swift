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
                .frame(width: 100, height: 30, alignment: .leading)
               Spacer()
               Text((stringObject.fontSize).description)
                .frame(width: 100, height: 30, alignment: .leading)
               Spacer()
            Text((stringObject.tracking).description)
                 .frame(width: 100, height: 30, alignment: .leading)
                Spacer()
            Text((stringObject.confidence).description)
                 .frame(width: 50, height: 30, alignment: .leading)
           }
       }
}


