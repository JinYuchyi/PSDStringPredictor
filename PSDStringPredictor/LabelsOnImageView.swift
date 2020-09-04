//
//  LabelsOnImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LabelsOnImageView: View {

    var body: some View {
        
            StringLabel()
        
    }
}

struct LabelsOnImageView_Previews: PreviewProvider {
    static var previews: some View {
        LabelsOnImageView()
    }
}

struct ShowLabel: View {
    var body: some View {
        StringLabel()
    }
}

//func GetLabelsList() -> [StringLabel]  {
//    var StringLabels: [StringLabel] = []
//    for i in 0...10 {
//        var l = StringLabel()
//        StringLabels.append(l)
//    }
//    //return StringLabels
//    return StringLabels
//}

