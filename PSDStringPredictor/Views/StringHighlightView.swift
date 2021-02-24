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
        ZStack{
            fakeString
            ForEach(psdsVM.selectedStrIDList, id:\.self){ theid in
                //if (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid) != nil) {
                ZStack{
                    //                fakeString
                    //                    .IsHidden(condition: showFakeString)
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
                                            dragX = gesture.translation.width / 20 // DragX is temp value
                                            psdsVM.tmpObjectForStringProperty.tracking = calcTracking().toString()
                                            //                                psdsVM.psdModel.SetTracking(psdId: psdsVM.selectedPsdId, objId: theid, value: calcTracking())
                                        } else {
                                            dragY = gesture.translation.height / 40
                                            psdsVM.tmpObjectForStringProperty.fontSize = calcFontSize().toString()
                                            //                                psdsVM.psdModel.SetFontSize(psdId: psdsVM.selectedPsdId, objId: theid, value: calcFontSize())
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
        
    }
    
    var fakeString: some View {
        //TODO: 
        AlignedText(fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(),  fontName: psdsVM.tmpObjectForStringProperty.fontName, color: psdsVM.tmpObjectForStringProperty.color, stringRect: psdsVM.tmpObjectForStringProperty.stringRect, alignment: psdsVM.tmpObjectForStringProperty.alignment, content: psdsVM.tmpObjectForStringProperty.content, isHighLight: true, pageWidth: psdsVM.GetSelectedPsd()?.width ?? 0, pageHeight: psdsVM.GetSelectedPsd()?.height ?? 0)
            .font(.custom(fontName(), size: calcFontSize()))
                    .position(
                        x: -psdsVM.tmpObjectForStringProperty.stringRect.minX,
                        y: -psdsVM.tmpObjectForStringProperty.stringRect.minY
                    )
        ////                x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)!.stringRect.midX.keepDecimalPlaces(num: 2) ?? zeroRect.minX,
        ////                y: psdsVM.selectedNSImage.size.height - (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.stringRect.midY.keepDecimalPlaces(num: 2)  ?? zeroRect.minY)
        //            )
        
        //        Text(psdsVM.tmpObjectForStringProperty.content )
        //            .tracking(calcTracking()  )
        //            .position(
        //                x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.stringRect.midX.keepDecimalPlaces(num: 2) ?? zeroRect.minX,
        //                y: psdsVM.selectedNSImage.size.height - (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.stringRect.midY.keepDecimalPlaces(num: 2)  ?? zeroRect.minY)
        //            )
        //            .foregroundColor(psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)?.color.ToColor() ?? Color.red  )
        //            .font(.custom(fontName(), size: calcFontSize()))
    }
    
    func fontName()-> String {
        guard let id = psdsVM.selectedStrIDList.last else {return ""}
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.FontName ?? "SF Pro Text Regular"
    }
    
    func fontSize() -> CGFloat {
        guard let id = psdsVM.selectedStrIDList.last else {return 0}
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.fontSize ?? 0
    }
    
    func fontTracking() -> CGFloat {
        guard let id = psdsVM.selectedStrIDList.last else {return 0}
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.tracking ?? 0
    }
    
    func calcFontSize() -> CGFloat {
        return fontSize() - dragY
    }
    
    func calcTracking() -> CGFloat {
        return fontTracking() + dragX
    }
    
    
    
}
