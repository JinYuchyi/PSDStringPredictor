//
//  psdThumbnailList.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 8/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct psdThumbnailList: View {
    //@ObservedObject var psdvm = psdViewModel
    @ObservedObject var psdsVM: PsdsVM
    @Binding var showPatchLayer: Bool
    //@ObservedObject var ControlVM: ControlVM
    //@ObservedObject var imageVM: ImageVM
    

    var body: some View {
        VStack{
            
            
            GeometryReader{geo in
                List(psdsVM.psdModel.psdObjects, id:\.id) { psd in
                    VStack(alignment: .center){
                        PsdThumbnail(id: psd.id, psdVM: psdsVM)
                            .frame(width: geo.size.width*0.85, height: CGFloat(sizeOfThumbnail))
                            .onTapGesture {
                                psdsVM.ThumbnailClicked(psdId: psd.id)
                                showPatchLayer = false
                            }
                            .border(psdsVM.selectedPsdId == psd.id ? Color.green : Color.gray.opacity(0.2), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)

                    //Divider()
                    }
                }
            }
        }
        
        
    }
}
//
//struct psdThumbnailList_Previews: PreviewProvider {
//    static var previews: some View {
//        psdThumbnailList()
//    }
//}
