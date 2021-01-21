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
//    var name: String
//    var thumb: NSImage
    
    @ObservedObject var psdVM: PsdsVM
    
    var body: some View {
        ZStack{
            IDView()
            Image(nsImage: ((psdVM.psdModel.GetPSDObject(psdId: id)?.thumbnail ?? NSImage.init(contentsOfFile: Bundle.main.path(forResource: "defaultImage", ofType: "png")!))!))
//                .onTapGesture {
//                    psdListVM.ThumbnailClicked(psdId: id)
//                    //psdvm.PsdSelected(psdId: id)
//                }
            StatusView()
                
                
                
        }
        .frame(width: 300, height: CGFloat(sizeOfThumbnail), alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    func StatusView()-> some View{
        LabelView()
            .frame(width: 300, height: CGFloat(sizeOfThumbnail), alignment: .topTrailing)
            .onTapGesture {
                psdVM.psdStatusTapped(psdId: id)
            }.padding(.trailing, 50)
        
        
    }
    
    func IDView() -> some View{
        Text("ID:\(id)")
            .frame(width: 300, height: CGFloat(sizeOfThumbnail), alignment: .topLeading)
            .padding(.leading, 50)
    }
    
    func LabelView() -> some View {
        if psdVM.psdModel.GetPSDObject(psdId: id)?.status == PsdStatus.normal{
            return Text("􀁢")
                .font(.system(size: 20, weight: .light, design: .serif))
                .foregroundColor(Color.gray)
        }
        else if psdVM.psdModel.GetPSDObject(psdId: id)?.status == PsdStatus.commited{
            return Text("􀁢")
                .font(.system(size: 20, weight: .light, design: .serif))
                .foregroundColor(Color.green)
        }else {
            return Text("􀁞")
                .font(.system(size: 20, weight: .light, design: .serif))
                .foregroundColor(Color.orange)
        }
    }
    
}

//struct PsdThumbnail_Previews: PreviewProvider {
//    static var previews: some View {
//        PsdThumbnail()
//    }
//}
