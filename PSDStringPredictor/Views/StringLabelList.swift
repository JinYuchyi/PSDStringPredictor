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
    @ObservedObject var stringObjectVM : PSDViewModel = psdViewModel
    let charFrameList: [CharFrame]
    
    @ObservedObject var psdsVM: PsdsVM
    
    var body: some View {
        ZStack{
            
            ForEach(stringObjectVM.FetchStringObjectOutputIDListOnePSD(_id: GetSelectedPsdId() ), id:\.self){ myid in
                StringLabel(id:myid, charFrameList: charFrameList, psdsVM: psdsVM )
                    .gesture(TapGesture()
                                .onEnded({ (loc) in
                                    stringObjectVM.selectedIDList.removeAll()
                                    stringObjectVM.selectedIDList.append(myid)
                                })
                )
            }
            

            
            ForEach(stringObjectVM.GetIngoreObjectIDListOnePSD(psdId: GetSelectedPsdId() ), id:\.self){ myid in
                StringLabel(id: myid, charFrameList: charFrameList, psdsVM: psdsVM)
            }
            
            ForEach(stringObjectVM.GetFixedObjectIDListForOnePSD(psdId: GetSelectedPsdId()), id:\.self){ myid in
                StringLabel(id: myid, charFrameList: charFrameList, psdsVM: psdsVM)
            }
            

        }
        
    }
    
    fileprivate func GetSelectedPsdId() -> Int{
        return stringObjectVM.selectedPSDID
    }
    

}

