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
    @State var originTracking: CGFloat =  -100
    @State var originSize: CGFloat = -100
    
    //Replace for tmpStruct
    @State var tmpTracking: CGFloat = 0
    @State var tmpSize: CGFloat = 0
    @State var tmpWidth: CGFloat = 0
    @State var tmpHeight: CGFloat = 0
    
    fileprivate func CalcRealBound() -> CGRect {
        let rect = FontUtils.GetStringBound(str: getLastObj().content, fontName: getLastObj().fontName, fontSize: getLastObj().fontSize, tracking: getLastObj().tracking)
        return rect
    }
    
    var body: some View {
        ZStack{
            
            ForEach(psdsVM.selectedStrIDList, id:\.self){ theid in
                ZStack{
                    
                    
                    Rectangle()
                        .frame(width: psdsVM.fetchStringObject(strId: theid).stringRect.width, height: psdsVM.fetchStringObject(strId: theid).stringRect.height)
                        .position(
                            //                            x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)?.stringRect.midX ?? zeroRect.minX.keepDecimalPlaces(num: 1),
                            x: psdsVM.calcStringPositionOnImage(psdId: psdsVM.selectedPsdId, objId: theid)[0],
                            y: psdsVM.calcStringPositionOnImage(psdId: psdsVM.selectedPsdId, objId: theid)[1]
                        )
                        .foregroundColor(Color.green.opacity(0.2))
                        
                        .gesture(TapGesture().modifiers(.shift).onEnded ({ (loc) in
                            if psdsVM.selectedStrIDList.contains( psdsVM.fetchStringObject(strId: theid).id){
                                psdsVM.selectedStrIDList.removeAll(where: {$0 == psdsVM.fetchStringObject(strId: theid).id})
                                if psdsVM.selectedStrIDList.count > 0 {
                                    psdsVM.fetchLastStringObjectFromSelectedPsd().toObjectForStringProperty()
                                }
                            }else {
                                psdsVM.selectedStrIDList.append(theid)
                                psdsVM.fetchLastStringObjectFromSelectedPsd().toObjectForStringProperty()
                            }
                        })
                        
                        .exclusively(before: DragGesture()
                                        .onChanged { gesture in
                                            if originTracking == -100 {
                                                originTracking = psdsVM.fetchLastStringObjectFromSelectedPsd().tracking
                                            }
                                            if originSize == -100 {
                                                originSize = psdsVM.fetchLastStringObjectFromSelectedPsd().fontSize
                                            }
                                            // Drag to change size and tracking
                                            showFakeString = psdsVM.selectedStrIDList.last!
                                            
                                            // Change tracking
                                            // We use two boundary lines (1.2 and 0.8), to make the users' interaction more clear
                                            if abs(gesture.translation.width / gesture.translation.height) > 1.2 {
                                                // Disable the link between size and tracking first
                                                psdsVM.linkSizeAndTracking = false
                                                
                                                interactive.dragX = gesture.translation.width / 40 // DragX is temp value
                                                
                                                // Re-Calc the bound
                                                psdsVM.tmpObjectForStringProperty.tracking = (originTracking + interactive.dragX).toString() //
                                                let tmp = FontUtils.GetStringBound(
                                                    str: psdsVM.tmpObjectForStringProperty.content,
                                                    fontName: psdsVM.tmpObjectForStringProperty.fontName,
                                                    fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(),
                                                    tracking: psdsVM.tmpObjectForStringProperty.tracking.toCGFloat()
                                                )
                                                psdsVM.tmpObjectForStringProperty.width = tmp.width
                                                psdsVM.tmpObjectForStringProperty.height = tmp.height - FontUtils.FetchTailOffset(content: psdsVM.tmpObjectForStringProperty.content, fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat())
                                                
                                                
                                            } else if abs(gesture.translation.width / gesture.translation.height) < 0.8 {
                                                // Change size
                                                interactive.dragY = gesture.translation.height / 20
                                                psdsVM.tmpObjectForStringProperty.fontSize = ((originSize - interactive.dragY).rounded()).toString()
                                                if psdsVM.linkSizeAndTracking == true {
                                                    psdsVM.tmpObjectForStringProperty.tracking = String(TrackingDataManager.FetchNearestOne(viewContext, fontSize: Int16((originSize - interactive.dragY).rounded())).fontTrackingPoints)
                                                }
                                                
                                                // Re-Calc the bound
                                                let tmp  = FontUtils.GetStringBound(str: psdsVM.tmpObjectForStringProperty.content, fontName: psdsVM.tmpObjectForStringProperty.fontName, fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: psdsVM.tmpObjectForStringProperty.tracking.toCGFloat())
                                                
                                                psdsVM.tmpObjectForStringProperty.width = tmp.width
                                                psdsVM.tmpObjectForStringProperty.height = tmp.height - FontUtils.FetchTailOffset(content: psdsVM.tmpObjectForStringProperty.content, fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat())
                                                
                                                let dif = originTracking - psdsVM.tmpObjectForStringProperty.tracking.toCGFloat()
                                                psdsVM.tmpObjectForStringProperty.posX = (psdsVM.tmpObjectForStringProperty.posX.toCGFloat() ).toString()
                                                
                                            }
                                        }
                                        .onEnded({ gesture in
                                            showFakeString = zeroUUID
                                            psdsVM.commitTempStringObject()
                                            
                                            interactive.dragX = 0
                                            interactive.dragY = 0
                                            originTracking = -100
                                            originSize = -100
                                        })
                        )
                        
                        
                        )
                    
                    Rectangle()
                        .stroke(Color.green, lineWidth: 1)
                        .frame(width: psdsVM.fetchStringObject(strId: theid).stringRect.width, height: psdsVM.fetchStringObject(strId: theid).stringRect.height)
                        .position(
                            x: psdsVM.fetchStringObject(strId: theid).stringRect.midX ?? zeroRect.minX,
                            y: (psdsVM.fetchSelectedPsd().height) - (psdsVM.fetchStringObject(strId: theid).stringRect.midY.keepDecimalPlaces(num: 2)  ?? zeroRect.minY)
                        )
                        
                        .blendMode(.lighten)
                    
                }
                
            }
        }
        
    }
    
    func getLastObj() -> StringObject {
        //        guard let lastId = psdsVM.selectedStrIDList.last else {return StringObject()}
        return psdsVM.fetchLastStringObjectFromSelectedPsd()
    }
    
    var fakeString: some View {
        
        
        AlignedText(fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(),
                    tracking: psdsVM.tmpObjectForStringProperty.tracking.toCGFloat(),
                    fontName: psdsVM.tmpObjectForStringProperty.fontName,
                    color: psdsVM.tmpObjectForStringProperty.color,
                    posX: psdsVM.tmpObjectForStringProperty.posX.toCGFloat(),
                    posY: psdsVM.tmpObjectForStringProperty.posY.toCGFloat(),
                    width: psdsVM.tmpObjectForStringProperty.width,
                    height: psdsVM.tmpObjectForStringProperty.height,
                    alignment: psdsVM.tmpObjectForStringProperty.alignment,
                    content: psdsVM.tmpObjectForStringProperty.content,
                    isHighLight: true,
                    pageWidth: psdsVM.fetchSelectedPsd().width,
                    pageHeight: psdsVM.fetchSelectedPsd().height)
        
    }
    
    func fontName()-> String {
        //        guard let id = psdsVM.selectedStrIDList.last else {return ""}
        return getLastObj().fontName ?? "SF Pro Text Regular"
    }
    
    func fontSize() -> CGFloat {
        //        guard let id = psdsVM.selectedStrIDList.last else {return 0}
        return getLastObj().fontSize ?? 0
    }
    
    func fontTracking() -> CGFloat {
        //        guard let id = psdsVM.selectedStrIDList.last else {return 0}
        return getLastObj().tracking ?? 0
    }
    
    func calcFontSize() -> CGFloat {
        return fontSize() - interactive.dragY
    }
    
    func calcTracking() -> CGFloat {
        return fontTracking() + interactive.dragX
    }
    
    
    
}
