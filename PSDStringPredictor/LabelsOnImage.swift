//
//  LabelsOnImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LabelsOnImage: View {
    @ObservedObject var stringObjectList: StringObjectList
    //var StringObject_List: [StringLabel]
    
    
    var body: some View {
        ForEach(stringObjectList.stringObjectListData, id: \.id){ item in
            StringLabel(
                id: item.id,
                position: item.position,
                height: item.height,
                width: item.width,
                fontsize: item.fontSize,
                tracking: item.tracking,
                content: item.content
            )
        }

        
        
    }
}

//struct LabelsOnImage_Previews: PreviewProvider {
//    static var previews: some View {
//        LabelsOnImage()
//    }
//}



//func GetLabelsList() -> [StringLabel]  {
//    var StringLabels: [StringLabel] = []
//    for i in 0...10 {
//        var l = StringLabel()
//        StringLabels.append(l)
//    }
//    //return StringLabels
//    return StringLabels
//}

