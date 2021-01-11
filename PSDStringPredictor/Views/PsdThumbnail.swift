//
//  PsdThumbnail.swift
//  PSDStringGenerator
//
//  Created by Yuqi Jin on 8/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

let sizeOfThumbnail: Int = 180

struct PsdThumbnail: View {
    var id: Int
    var name: String
    var thumb: NSImage
    
    var body: some View {
        ZStack{
            Image(nsImage: thumb)
//                .onTapGesture {
//                    psdListVM.ThumbnailClicked(psdId: id)
//                    //psdvm.PsdSelected(psdId: id)
//                }
            CheckView()
        }
    }
    
    func CheckView()-> some View{
        Text("􀁢")
            .font(.system(size: 20, weight: .light, design: .serif))
            .frame(width: CGFloat(sizeOfThumbnail), height: CGFloat(sizeOfThumbnail), alignment: .topTrailing)
        
    }
    
}

//struct PsdThumbnail_Previews: PreviewProvider {
//    static var previews: some View {
//        PsdThumbnail()
//    }
//}
