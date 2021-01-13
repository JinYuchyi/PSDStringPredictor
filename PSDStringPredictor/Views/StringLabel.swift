//
//  StringLabel.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringLabel: View {
    //Constant
    let smallBtnSize: CGFloat = 20
    
    var id: UUID
    var charFrameList: [CharFrame]
    //@State var status: Int
   // @State var ignored: Bool
//    @State var fixedEnabled: Bool
//    @State var ignoredEnabled: Bool
    //var psd = PSD()
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM: PSDViewModel = psdViewModel
    @State var width: CGFloat = 0
    @State var alignmentIconName = "alignLeft-round"
    
    @ObservedObject var psdsVM: PsdsVM
    
    func CalcTrackingAfterOffset() -> CGFloat {
        // var offset : CGSize = .zero
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[id] != nil{
            d = stringObjectVM.DragOffsetDict[id]!.width
            return (stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)?.tracking ?? 0) + d
        }else{
            return 0
        }
        
    }
    
    func CalcSizeAfterOffset() -> CGFloat {
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[id] != nil{
            d = stringObjectVM.DragOffsetDict[id]!.height
        }
        if stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)  == nil {
            return 0
        }else{
            return stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)!.fontSize - d
        }
    }
    
    func InfoBtnTapped(){
        stringObjectVM.FetchSelectedIDList(idList: [id])
    }
    
    func FixedBtnTapped(){
        //fixed = !fixed
        
        if stringObjectVM.stringObjectStatusDict[stringObjectVM.selectedPSDID]![id]! == 1 {
            stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 0)
            //stringObjectVM.FindStringObjectByID(id: id)!.SetStatus(status: 0)
        }else {
            stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 1)

        }

    }
    
    func IgnoreBtnTapped(){
        if stringObjectVM.stringObjectStatusDict[stringObjectVM.selectedPSDID]![id]! == 2 {
            stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 0)
        }else {
            stringObjectVM.SetStatusForStringObject(psdId: stringObjectVM.selectedPSDID, objId: id, value: 2)
        }
    }
    
    func alignmentTapped() {
        stringObjectVM.alignmentDict[id]  = (stringObjectVM.alignmentDict[id]! + 1) % 3
        switch stringObjectVM.alignmentDict[id] {
        case 0:
            alignmentIconName  = "alignLeft-round"
        case 1:
            alignmentIconName  = "alignCenter-round"
        case 2:
            alignmentIconName  = "alignRight-round"
        default:
            alignmentIconName  = "alignLeft-round"
        }
    }
    
    
    
    func GetPosition() -> CGPoint{
        if psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id) != nil{
            let x = (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.origin.x)! + (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.width)!/2
            let y = imageViewModel.GetTargetImageSize()[1] - (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.origin.y)!  - (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.height)!/2
            return CGPoint(x: x, y: y)
        }else{
            return CGPoint.zero
        }
    }
    
    func TextLayerView() -> some View {
        
        Text(psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)?.content ?? " " )
            .tracking(CalcTrackingAfterOffset())
            .position(x: GetPosition().x, y: GetPosition().y)
            .foregroundColor(psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)?.color.ToColor() ?? Color.white)
            .font(.custom(psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)?.FontName ?? "", size: CalcSizeAfterOffset()))
            .shadow(color: psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)?.colorMode == 2 ?  .black : .white, radius: 2, x: 0, y: 0)
            //.blendMode(.difference)

    }
    
    fileprivate func StringFrameLayerView()-> some View {
        //String debug frame
        Rectangle()
        
            .stroke(stringObjectVM.stringObjectStatusDict[stringObjectVM.selectedPSDID]?[id] == 2 ? Color.red : Color.green, lineWidth: 2)
            .frame(width: stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)?.stringRect.width ?? 0, height: stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)?.stringRect.height ?? 0)
            .position(x: GetPosition().x, y: GetPosition().y  )
        
            //.shadow(color: stringObjectVM.FindStringObjectByID(id: id)?.colorMode == 1 ?  .black : .white, radius: 2, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            //.blendMode(.difference)
    }
    
    fileprivate func DragLayerView()-> some View {
        //Drag layer
        Rectangle()
            .fill( Color.yellow.opacity(0.1))
            .frame(width: stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)?.stringRect.width ?? 0, height: stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)?.stringRect.height ?? 0)
            .position(x: GetPosition().x, y: GetPosition().y)
    }
    
    var body: some View {
        ZStack {
            ZStack { //Debug
                //Text(stringObjectVM.FindStringObjectByID(id: id)!.content)
                Group{
                    //Frames
                    StringFrameLayerView()

                    //DragLayerView()
                }
                //.IsHidden(condition: stringObjectVM.stringObjectStatusDict[id] == 0)
                
                //Text content
                TextLayerView()

            }
            
            HStack{
                //Button for show detail
//                Button(action: {self.InfoBtnTapped()}){
//                    CustomImage( name: "detail-round")
//                        .scaledToFit()
//                }
//                .buttonStyle(RoundButtonStyle())
//                .frame(width: 20, height: 20)
//                .padding(-4)
                
                //Button for alignment
                
                Button(action: {alignmentTapped()}){
                    CustomImage( name: alignmentIconName)
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                
                //Button for fix
                Button(action: {self.FixedBtnTapped()}){
                    CustomImage( name: stringObjectVM.stringObjectStatusDict[stringObjectVM.selectedPSDID]?[id] == 1 ? "tick-active" : "tick-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                //.IsHidden(condition: fixedEnabled)
                
                //Button for delete
                Button(action: {self.IgnoreBtnTapped()}){
                    CustomImage( name: stringObjectVM.stringObjectStatusDict[stringObjectVM.selectedPSDID]?[id] == 2 ? "forbidden-active" : "forbidden-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                //.IsHidden(condition: ignoredEnabled)
            }
            .frame(width: stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)?.stringRect.width ?? 0, height: stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)?.stringRect.height ?? 0, alignment: .bottomTrailing)
            .position(x: GetPosition().x , y: GetPosition().y + smallBtnSize )
            .IsHidden(condition: stringObjectVM.selectedIDList.contains(id)==true)
        }
    }
}

//struct StringLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        Button(action: {}){
//            //            Text("􀍢")
//            //
//            //                //.background(Color.black)
//            //                .foregroundColor(Color.white)
//            //                //.border(Color.black, width: 1)
//            //                //.shadow(radius: 0.1)
//            //                .cornerRadius(10)
//        }
//        .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//        .shadow(radius: 10)
//    }
//}
