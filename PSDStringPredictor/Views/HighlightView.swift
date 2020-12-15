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
    let objList: [StringObject]
    var body: some View {
        ForEach(objList, id:\.id){ obj in
            ZStack{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .frame(width: obj.stringRect.width, height: obj.stringRect.height)
                    .position(x: obj.stringRect.midX, y: imageVM.targetNSImage.size.height - obj.stringRect.midY)
                    .foregroundColor(Color.green.opacity(0.3))
                    .shadow(color: .green, radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0)
                    .gesture(DragGesture()
                                .onChanged { gesture in
                                    if abs(gesture.translation.width / gesture.translation.height) > 1 {
                                        stringObjectVM.DragOffsetDict[obj] = CGSize(width: gesture.translation.width / 10, height: 0)
                                    } else {
                                        stringObjectVM.DragOffsetDict[obj] = CGSize(width: 0, height: gesture.translation.height / 10)
                                    }
                                }
                    
                    )
                    
                    
                
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width: obj.stringRect.width, height: obj.stringRect.height)
                    .position(x: obj.stringRect.midX, y: imageVM.targetNSImage.size.height - obj.stringRect.midY)
                    .blendMode(.lighten)
            }
        }

        
        
    }
}

//struct HighlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        HighlightView(rect: CGRect.init(x: 10, y: 10, width: 50, height: 20))
//    }
//}
