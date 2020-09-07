//
//  StringObjectListView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 7/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringObjectList: View {
    //var stringObject: StringObject
    
    var body: some View {
        List(stringObjectsData){ stringObject in
            StringObjectRow(stringObject: stringObject)
        }
    }
}

struct StringObjectList_Previews: PreviewProvider {
    static var previews: some View {
        StringObjectList()
    }
}
