//
//  LabelsOnImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct LabelsOnImage: View {
//    @ObservedObject var imageProcess: ImageProcess = imageProcessViewModel
//    @ObservedObject var stringObjectVM : PSDViewModel = psdViewModel
//    let charFrameList: [CharFrame]
    @ObservedObject var psdsVM: PsdsVM
    @Binding var showFakeString: Bool
    
    var body: some View {
        ZStack{
            
            ForEach((psdsVM.GetSelectedPsd()?.stringObjects) ?? [], id:\.id){ obj in
                StringLabel( stringObject: obj, showFakeString: $showFakeString, psdsVM: psdsVM )
                    .gesture(TapGesture()
                                .onEnded({ (loc) in
                                    psdsVM.selectedStrIDList.append(obj.id)
                                    psdsVM.selectedStrIDList.removeAll(where: {$0 != obj.id})
                                    psdsVM.tmpObjectForStringProperty = obj.toObjectForStringProperty()
                                })
                )
            }
            
//            ForEach((psdsVM.GetSelectedPsd()?.stringObjects.filter{$0.status == StringObjectStatus.ignored}) ?? [], id:\.id){ obj in
//                StringLabel(id:obj.id, psdsVM: psdsVM )
//                    .gesture(TapGesture()
//                                .onEnded({ (loc) in
//                                    psdsVM.selectedStrIDList.removeAll()
//                                    psdsVM.selectedStrIDList.append(obj.id)
//                                })
//                    )
//            }

//            ForEach(psdsVM.GetSelectedPsd()?.stringObjects.filter{$0.status != StringObjectStatus.ignored}, id:\.id){ myid in
//                StringLabel(id: myid, charFrameList: charFrameList, psdsVM: psdsVM)
//            }
//
//            ForEach(stringObjectVM.GetFixedObjectIDListForOnePSD(psdId: GetSelectedPsdId()), id:\.self){ myid in
//                StringLabel(id: myid, charFrameList: charFrameList, psdsVM: psdsVM)
//            }
            

        }
        
    }

    

}

