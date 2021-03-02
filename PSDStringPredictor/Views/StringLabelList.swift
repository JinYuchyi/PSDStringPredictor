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
    @ObservedObject var interactive: InteractiveViewModel
    @Binding var showFakeString: UUID
    
    var body: some View {
        ZStack{
            
            
            ForEach((psdsVM.GetSelectedPsd()?.stringObjects) ?? [], id:\.id){ obj in
                StringLabel( stringObject: obj, interactive: interactive, showFakeString: $showFakeString, psdsVM: psdsVM )
                    
                    .gesture(TapGesture().modifiers(.shift).onEnded ({ (loc) in
                        if psdsVM.selectedStrIDList.contains(obj.id){
                            psdsVM.selectedStrIDList.removeAll(where: {$0 == obj.id})
                            psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.toObjectForStringProperty()
                        }else {
                            psdsVM.selectedStrIDList.append(obj.id)
                            psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.toObjectForStringProperty()
                        }
                    })
                    )
                    
                    
            }
            

            
            
        }
        
    }
    
    
    
}

