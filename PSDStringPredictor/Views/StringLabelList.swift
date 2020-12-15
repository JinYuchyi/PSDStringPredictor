//
//  LabelsOnImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LabelsOnImage: View {
    @ObservedObject var imageProcess: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM : StringObjectViewModel = stringObjectViewModel
    let charFrameList: [CharFrame]
    
    var body: some View {
        Group{
            ForEach(stringObjectVM.updateStringObjectList, id:\.id){ item in
                StringLabel(stringLabel: item, charFrameList: charFrameList, fixed: false, ignored: false, fixedEnabled: true, ignoredEnabled: true )
                    .gesture(TapGesture()
                                .onEnded({ (loc) in
                                    print("On tapped.")
                                    stringObjectVM.selectedStringObjectList.removeAll()
                                    stringObjectVM.selectedStringObjectList.append(item)
                                })
                )
            }
            
            ForEach(stringObjectVM.ignoreStringObjectList, id:\.id){ item in
                StringLabel(stringLabel: item, charFrameList: charFrameList, fixed: false, ignored: true, fixedEnabled: false, ignoredEnabled: true  )
            }
            
            ForEach(stringObjectVM.fixedStringObjectList, id:\.id){ item in
                StringLabel(stringLabel: item, charFrameList: charFrameList, fixed: true, ignored: false, fixedEnabled: true, ignoredEnabled: false )
            }
        }
        
    }
    

}

