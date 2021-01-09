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
    @ObservedObject var psdvm = psdViewModel
    var id: Int
    var name: String
    var thumb: NSImage
    
    
    var body: some View {
        ZStack{
            
            Image(nsImage: thumb)
                .onTapGesture {
                    psdvm.PsdSelected(psdId: id)
                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12)
//                        .strokeBorder(Color.init(red: 0.3 , green: 0.3, blue: 0.3),lineWidth: 4)
//                )
            CheckView()
            //Text("\(name)")
        }
        
        
    }
    
    func CheckView()-> some View{
        //GeometryReader{geo in
        Text("􀁢")
            .font(.system(size: 20, weight: .light, design: .serif))
            .frame(width: CGFloat(sizeOfThumbnail), height: CGFloat(sizeOfThumbnail), alignment: .topTrailing)
        //}
        
    }
    
}

//struct PsdThumbnail_Previews: PreviewProvider {
//    static var previews: some View {
//        PsdThumbnail()
//    }
//}
