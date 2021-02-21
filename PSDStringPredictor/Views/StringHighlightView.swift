////
////  HighlightView.swift
////  PSDStringGenerator
////
////  Created by ipdesign on 13/12/2020.
////  Copyright © 2020 ipdesign. All rights reserved.
////
//
import SwiftUI

//Constant
let zeroRect = CGRect(x: -1000, y: -1000, width: 0, height: 0)

struct StringHighlightView: View {
    
    @ObservedObject var psdsVM: PsdsVM
    @Binding var showFakeString: Bool  
    @State var dragX: CGFloat = 0
    @State var dragY: CGFloat = 0
    
    var body: some View {
        
        ForEach(psdsVM.selectedStrIDList, id:\.self){ theid in
            //if (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid) != nil) {
            ZStack{
                fakeString.IsHidden(condition: showFakeString)
                Rectangle()
                    .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.width, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.height)
                    .position(
                        x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.midX ?? zeroRect.minX.keepDecimalPlaces(num: 1),
                        y: psdsVM.selectedNSImage.size.height - (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.midY.keepDecimalPlaces(num: 1) ?? zeroRect.minY)
                    )
                    .foregroundColor(Color.green.opacity(0.2))
                    .shadow(color: .green, radius: 5, x: 0, y: 0)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            showFakeString = true
                            if abs(gesture.translation.width / gesture.translation.height) > 1 {
                                dragX = gesture.translation.width / 20
                            } else {
                                dragY = gesture.translation.height / 40
                            }
                        }
                        .onEnded({ gesture in
                            showFakeString = false
                            psdsVM.tmpObjectForStringProperty.tracking = calcTracking().toString()
                            psdsVM.tmpObjectForStringProperty.fontSize = calcFontSize().toString()
                            
                            psdsVM.psdModel.SetFontSize(psdId: psdsVM.selectedPsdId, objId: theid, value: calcFontSize())
                            psdsVM.psdModel.SetTracking(psdId: psdsVM.selectedPsdId, objId: theid, value: calcTracking())
                            dragX = 0
                            dragY = 0
                        })
                    )
                
                Rectangle()
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.width, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.height)
                    .position(
                        x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.midX.keepDecimalPlaces(num: 2) ?? zeroRect.minX,
                        y: psdsVM.selectedNSImage.size.height - (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.midY.keepDecimalPlaces(num: 2)  ?? zeroRect.minY)
                    )
                    .blendMode(.lighten)
                
            }
            
        }
        
    }
    
    var fakeString: some View {
        Text(psdsVM.tmpObjectForStringProperty.content )
            .tracking(calcTracking()  )
            .position(
                x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.stringRect.midX.keepDecimalPlaces(num: 2) ?? zeroRect.minX,
                y: psdsVM.selectedNSImage.size.height - (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.stringRect.midY.keepDecimalPlaces(num: 2)  ?? zeroRect.minY)
            )
            .foregroundColor(psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.color.ToColor() ?? Color.red  )
            .font(.custom(fontName(), size: calcFontSize()))
        //            .shadow(color: stringObject.colorMode == MacColorMode.dark ?  .black : .white, radius: 2, x: 0, y: 0)
    }
    
    func fontName()-> String {
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.FontName ?? "SF Pro Text Regular"
    }
    
    func fontSize() -> CGFloat {
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.fontSize ?? 0
    }
    
    func fontTracking() -> CGFloat {
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.tracking ?? 0
    }
    
    func calcFontSize() -> CGFloat {
        return fontSize() - dragY
    }
    
    func calcTracking() -> CGFloat {
        return fontTracking() + dragX
    }
    
    
    
}
