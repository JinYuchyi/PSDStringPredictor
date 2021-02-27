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
    @ObservedObject var interactive: InteractiveViewModel
    @ObservedObject var psdsVM: PsdsVM
    @Binding var showFakeString: UUID
    
    var body: some View {
        ZStack{
            
            
            ForEach(psdsVM.selectedStrIDList, id:\.self){ theid in
                ZStack{
                    Rectangle()
                        .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.width, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.height)
                        .position(
                            x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.midX ?? zeroRect.minX.keepDecimalPlaces(num: 1),
                            y: psdsVM.selectedNSImage.size.height - (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.midY.keepDecimalPlaces(num: 1) ?? zeroRect.minY)
                        )
                        .foregroundColor(Color.green.opacity(0.2))
                        .shadow(color: .green, radius: 5, x: 0, y: 0)
                        .gesture(TapGesture().modifiers(.shift).onEnded ({ (loc) in
                            if psdsVM.selectedStrIDList.contains(psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.id){
                                psdsVM.selectedStrIDList.removeAll(where: {$0 == psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.id})
                                if psdsVM.selectedStrIDList.count > 0 {
                                    psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.toObjectForStringProperty()
                                }
                            }else {
                                psdsVM.selectedStrIDList.append(psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.id)
                                psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.toObjectForStringProperty()
                            }
                        })
                        )
                        .gesture(DragGesture()
                            .onChanged { gesture in
                                showFakeString = psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.id ?? UUID.init()
                                if abs(gesture.translation.width / gesture.translation.height) > 1 {
                                    interactive.dragX = gesture.translation.width / 20 // DragX is temp value
                                    
                                    let tmp = FontUtils.GetStringBound(
                                        str: psdsVM.tmpObjectForStringProperty.content,
                                        fontName: psdsVM.tmpObjectForStringProperty.fontName,
                                        fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat()
                                    )
                                    psdsVM.tmpObjectForStringProperty.tracking = calcTracking().toString()
                                    psdsVM.tmpObjectForStringProperty.width = tmp.width
                                    psdsVM.tmpObjectForStringProperty.height = tmp.height - FontUtils.FetchFontOffset(content: psdsVM.tmpObjectForStringProperty.content, fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat())
                                    
                                } else {
                                    interactive.dragY = gesture.translation.height / 40
                                    psdsVM.tmpObjectForStringProperty.fontSize = (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.fontSize - interactive.dragY).toString()
                                    let tmp  = FontUtils.GetStringBound(str: psdsVM.tmpObjectForStringProperty.content, fontName: psdsVM.tmpObjectForStringProperty.fontName, fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat())
                                   
                                    psdsVM.tmpObjectForStringProperty.width = tmp.width
                                    psdsVM.tmpObjectForStringProperty.height = tmp.height - FontUtils.FetchFontOffset(content: psdsVM.tmpObjectForStringProperty.content, fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat())
                                    
                                }
                            }
                            .onEnded({ gesture in
                                
                                showFakeString = UUID.init()
                             
                                if psdsVM.tmpObjectForStringProperty.alignment == .center {
                                    psdsVM.tmpObjectForStringProperty.posX = ( psdsVM.tmpObjectForStringProperty.posX.toCGFloat() + (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.width - psdsVM.tmpObjectForStringProperty.width ) / 2 ).toString()
                                }else if psdsVM.tmpObjectForStringProperty.alignment == .right {
                                    psdsVM.tmpObjectForStringProperty.posX = ( psdsVM.tmpObjectForStringProperty.posX.toCGFloat() - ( psdsVM.tmpObjectForStringProperty.width - psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.width ) ).toString()
                                }
                                
                                psdsVM.commitTempStringObject()
                                
                                interactive.dragX = 0
                                interactive.dragY = 0
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
        //        AlignedText(fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(),  fontName: psdsVM.tmpObjectForStringProperty.fontName, color: psdsVM.tmpObjectForStringProperty.color, stringRect: psdsVM.tmpObjectForStringProperty.stringRect, alignment: psdsVM.tmpObjectForStringProperty.alignment, content: psdsVM.tmpObjectForStringProperty.content, isHighLight: true, pageWidth: psdsVM.GetSelectedPsd()?.width ?? 0, pageHeight: psdsVM.GetSelectedPsd()?.height ?? 0)
        //            .font(.custom(fontName(), size: calcFontSize()))
        
        AlignedText(fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(),
                    fontName: psdsVM.tmpObjectForStringProperty.fontName,
                    color: psdsVM.tmpObjectForStringProperty.color,
                    posX: psdsVM.tmpObjectForStringProperty.posX.toCGFloat(),
                    posY: psdsVM.tmpObjectForStringProperty.posY.toCGFloat(),
                    width: psdsVM.tmpObjectForStringProperty.width,
                    height: psdsVM.tmpObjectForStringProperty.height,
                    alignment: psdsVM.tmpObjectForStringProperty.alignment,
                    content: psdsVM.tmpObjectForStringProperty.content,
                    isHighLight: true,
                    pageWidth: psdsVM.GetSelectedPsd()?.width ?? 0,
                    pageHeight: psdsVM.GetSelectedPsd()?.height ?? 0)
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
        return fontSize() - interactive.dragY
    }
    
    func calcTracking() -> CGFloat {
        return fontTracking() + interactive.dragX
    }
    
    
    
}
