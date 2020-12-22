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
        ZStack{
            ForEach(stringObjectVM.FetchStringObjectOutputList(), id:\.id){ obj in
                StringLabel(id: obj.id , charFrameList: charFrameList, fixed: false, ignored: false, fixedEnabled: true, ignoredEnabled: true )
                    .gesture(TapGesture()
                                .onEnded({ (loc) in
                                    stringObjectVM.selectedIDList.removeAll()
                                    stringObjectVM.selectedIDList.append(obj.id)
                                })
                )
            }
            
            ForEach(stringObjectVM.ignoreStringObjectList, id:\.self){ _id in
                StringLabel(id: _id, charFrameList: charFrameList, fixed: false, ignored: true, fixedEnabled: false, ignoredEnabled: true  )
            }
            
            ForEach(stringObjectVM.fixedStringObjectList, id:\.self){ _id in
                StringLabel(id: _id, charFrameList: charFrameList, fixed: true, ignored: false, fixedEnabled: true, ignoredEnabled: false )
            }
            

        }
        
    }
    

}

