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
       
       var body: some View {
           HStack{
               Text(stringObject.content)
               Spacer()
               Text((stringObject.fontSize).description)
               Spacer()
               Text((stringObject.position[0]).description + ", "+(stringObject.position[1]).description)
           }
       }
}

struct StringObjectRow_Previews: PreviewProvider {
    static var previews: some View {
        StringObjectRow(stringObject:stringObjectsData[0])
    }
}
