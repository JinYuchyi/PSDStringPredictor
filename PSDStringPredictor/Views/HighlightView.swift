//
//  HighlightView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 13/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct HighlightView: View {
    @ObservedObject var imageVM = imageProcessViewModel
    @ObservedObject var stringObjectVM = stringObjectViewModel
    //imageProcessViewModel.targetNSImage.size.height - obj.stringRect.origin.y
    //let ids: [UUID]
    var body: some View {
        ForEach(stringObjectVM.selectedIDList, id:\.self){ theid in
            ZStack{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .frame(width:  GetStringObject(theid).stringRect.width, height: GetStringObject(theid).stringRect.height)
                    .position(x: GetStringObject(theid).stringRect.midX, y: imageVM.targetNSImage.size.height - GetStringObject(theid).stringRect.midY)
                    .foregroundColor(Color.green.opacity(0.3))
                    .shadow(color: .green, radius: 5, x: 0, y: 0)
                    .gesture(DragGesture()
                                .onChanged { gesture in
                                    if abs(gesture.translation.width / gesture.translation.height) > 1 {
                                        stringObjectVM.DragOffsetDict[theid] = CGSize(width: gesture.translation.width / 10, height: 0)
                                    } else {
                                        stringObjectVM.DragOffsetDict[theid] = CGSize(width: 0, height: gesture.translation.height / 10)
                                    }
                                }
                    
                    )
                    
                    
                
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width: GetStringObject(theid).stringRect.width, height: GetStringObject(theid).stringRect.height)
                    .position(x: GetStringObject(theid).stringRect.midX, y: imageVM.targetNSImage.size.height - GetStringObject(theid).stringRect.midY)
                    .blendMode(.lighten)
            }
        }

        
        
    }
    
    func GetStringObject(_ id: UUID) -> StringObject{
        return stringObjectVM.stringObjectListData.FindByID(id) ?? StringObject()
    }
}

//struct HighlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        HighlightView(rect: CGRect.init(x: 10, y: 10, width: 50, height: 20))
//    }
//}
