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
         
            
            
            ForEach((psdsVM.GetSelectedPsd()?.stringObjects) ?? [], id:\.id){ obj in
                ZStack{
                    StringLabel( id: obj.id, interactive: interactive, showFakeString: $showFakeString, psdsVM: psdsVM )

                }
                    
                    
            }
            

            
            
    
        
    }
    
    
    
}

