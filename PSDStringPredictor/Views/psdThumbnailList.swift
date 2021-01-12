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
    @ObservedObject var psdListVM: PsdListVM
    @ObservedObject var imageVM: ImageVM

    var body: some View {
        VStack{
            Text("\(psdListVM.psdObjectList.count)")
            
            GeometryReader{geo in
                List(psdListVM.psdObjectList, id:\.id) { psd in
                    VStack{
                        PsdThumbnail(id: psd.id, name: psd.imageURL.lastPathComponent, thumb: psd.thumbnail)
                        .frame(width: geo.size.width, height: CGFloat(sizeOfThumbnail), alignment: .center)
                            .onTapGesture {
                                print("tapped \(psd.id)")
                                psdListVM.ThumbnailClicked(psdId: psd.id)
                                imageVM.FetchInfo()
                                //psdvm.PsdSelected(psdId: id)
                            }
                        
                    Divider()
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
