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
    //var charFrameList: [CharFrame]
    //@State var status: Int
    // @State var ignored: Bool
    //    @State var fixedEnabled: Bool
    //    @State var ignoredEnabled: Bool
    //var psd = PSD()
    //@ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    //@ObservedObject var stringObjectVM: PSDViewModel = psdViewModel
    //@State var width: CGFloat = 0
    @State var alignmentIconName = "alignLeft-round"
    
    @ObservedObject var psdsVM: PsdsVM
    
    func CalcTrackingAfterOffset() -> CGFloat {
        // var offset : CGSize = .zero
        var d : CGFloat = 0
        if psdsVM.DragOffsetDict[id] != nil{
            d = psdsVM.DragOffsetDict[id]!.width
            
            return (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.tracking ?? 0) + d
        }else{
            return 0
        }
    }
    
    func CalcSizeAfterOffset() -> CGFloat {
        var d : CGFloat = 0
        if psdsVM.DragOffsetDict[id] != nil{
            d = psdsVM.DragOffsetDict[id]!.height
        }
        if psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)  == nil {
            return 0
        }else{
            return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)!.fontSize - d
        }
    }
    
    //Obsolete
    func InfoBtnTapped(){
        //stringObjectVM.FetchSelectedIDList(idList: [id])
    }
    
    func GetPosition() -> CGPoint{
        
        if psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id) != nil{
            let x = (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.origin.x)! + (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.width)!/2
            let y = psdsVM.selectedNSImage.size.height - (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.origin.y)!  - (psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)!.stringRect.height)!/2
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
            .shadow(color: psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id)?.colorMode == MacColorMode.dark ?  .black : .white, radius: 2, x: 0, y: 0)
            
        //.blendMode(.difference)
        
    }
    
    fileprivate func StringFrameLayerView()-> some View {
        //String debug frame
        Rectangle()
            .stroke(psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.status == StringObjectStatus.ignored ? Color.red : Color.green, lineWidth: 2)
            .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.stringRect.width ?? 0, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.stringRect.height ?? 0)
            .position(x: GetPosition().x, y: GetPosition().y  )
    }
    
    fileprivate func DragLayerView()-> some View {
        //Drag layer
        Rectangle()
            .fill( Color.yellow.opacity(0.1))
            .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.stringRect.width ?? 0, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.stringRect.height ?? 0)
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
                
            }.IsHidden(condition: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.status != StringObjectStatus.ignored)
            
            HStack{

                
                //Button for alignment
                
                Button(action: {alignmentIconName = psdsVM.alignmentTapped(id)}){
                    CustomImage( name: alignmentIconName)
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: psdsVM.selectedStrIDList.contains(id)==true)
                
                //Button for fix
                Button(action: {psdsVM.FixedBtnTapped(id)}){
                    CustomImage( name: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.status == StringObjectStatus.fixed ? "tick-active" : "tick-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: psdsVM.selectedStrIDList.contains(id)==true  || psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.status == StringObjectStatus.fixed)
                
                //Button for delete
                Button(action: {psdsVM.IgnoreBtnTapped(id)}){
                    CustomImage( name: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.status == StringObjectStatus.ignored ? "forbidden-active" : "forbidden-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: psdsVM.selectedStrIDList.contains(id)==true || psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.status == StringObjectStatus.ignored)
            }
            .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.stringRect.width ?? 0, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id)?.stringRect.height ?? 0, alignment: .bottomTrailing)
            .position(x: GetPosition().x , y: GetPosition().y + smallBtnSize )
            
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
