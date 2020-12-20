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
    @State var fixed: Bool
    @State var ignored: Bool
    @State var fixedEnabled: Bool
    @State var ignoredEnabled: Bool
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    @State var width: CGFloat = 0
    @State var alignmentIconName = "alignLeft-round"
    
    func CalcTrackingAfterOffset() -> CGFloat {
        // var offset : CGSize = .zero
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[id] != nil{
            d = stringObjectVM.DragOffsetDict[id]!.width
            return stringObjectVM.FindStringObjectByID(id: id)!.tracking + d
        }else{
            return 0
        }
        
    }
    
    func CalcSizeAfterOffset() -> CGFloat {
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[id] != nil{
            d = stringObjectVM.DragOffsetDict[id]!.height
        }
        if stringObjectVM.FindStringObjectByID(id: id) == nil {
            return 0
        }else{
            return stringObjectVM.FindStringObjectByID(id: id)!.fontSize - d
        }
    }
    
    func InfoBtnTapped(){
        //print("stringLabel.id: \(stringLabel.content)")
        stringObjectVM.UpdateSelectedIDList(idList: [id])
        imageProcessViewModel.FindNearestStandardRGB(stringObjectVM.FindStringObjectByID(id: id)?.color ?? CGColor.white)
    }
    
    func FixedBtnTapped(){
        fixed = !fixed
        stringObjectVM.stringObjectFixedDict[id] = fixed
        ignoredEnabled = !fixed
//        if fixedEnabled == true {
//            if stringObjectVM.fixedStringObjectList.contains(where: {$0.id == id}){
//                stringObjectVM.fixedStringObjectList.append(stringObjectVM.FindStringObjectByID(id: id)!)
//            }
//        }else{
//            stringObjectVM.fixedStringObjectList.removeAll(where: {$0.id == id})
//        }
    }
    
    func IgnoreBtnTapped(){
        ignored = !ignored
        stringObjectVM.stringObjectIgnoreDict[id] = ignored
        fixedEnabled = !ignored
//        if ignoredEnabled == true {
//            if stringObjectVM.ignoreStringObjectList.contains(where: {$0.id == id}){
//                stringObjectVM.ignoreStringObjectList.append(stringObjectVM.FindStringObjectByID(id: id)!)
//            }
//        }else{
//            stringObjectVM.ignoreStringObjectList.removeAll(where: {$0.id == id})
//        }
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
        if stringObjectVM.FindStringObjectByID(id: id) != nil{
            let x = stringObjectVM.FindStringObjectByID(id: id)!.stringRect.origin.x + stringObjectVM.FindStringObjectByID(id: id)!.stringRect.width/2
            let y = imageViewModel.GetTargetImageSize()[1] - stringObjectVM.FindStringObjectByID(id: id)!.stringRect.origin.y  - stringObjectVM.FindStringObjectByID(id: id)!.stringRect.height/2
            return CGPoint(x: x, y: y)
        }else{
            return CGPoint.zero
        }
    }
    
    func TextLayerView() -> some View {
        Text(stringObjectVM.FindStringObjectByID(id: id)?.content ?? " ")
            .tracking(CalcTrackingAfterOffset())
            .position(x: GetPosition().x, y: GetPosition().y)
            .foregroundColor(stringObjectVM.FindStringObjectByID(id: id)?.color.ToColor() ?? Color.white)
            .font(.custom(stringObjectVM.StringObjectNameDict[id]!, size: CalcSizeAfterOffset()))
    }
    
    fileprivate func StringFrameLayerView()-> some View {
        //String debug frame
        Rectangle()
            .stroke(Color.red, lineWidth: 1)
            .frame(width: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.width ?? 0, height: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.height ?? 0)
            .position(x: GetPosition().x, y: GetPosition().y  )
    }
    
    fileprivate func DragLayerView()-> some View {
        //Drag layer
        Rectangle()
            .fill( Color.yellow.opacity(0.1))
            .frame(width: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.width ?? 0, height: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.height ?? 0)
            .position(x: GetPosition().x, y: GetPosition().y)
    }
    
    var body: some View {
        ZStack {
            ZStack { //Debug
                
                Group{
                    //Frames
                    StringFrameLayerView()
                    DragLayerView()
                }
                .IsHidden(condition: fixedEnabled && ignoredEnabled)
                
                //Text content
                Text(stringObjectVM.FindStringObjectByID(id: id)?.content ?? " ")
                    .foregroundColor(stringObjectVM.FindStringObjectByID(id: id)?.color.ToColor())
                    .font(.custom(stringObjectVM.StringObjectNameDict[id] ?? " ", size: CalcSizeAfterOffset()))
                    .tracking(CalcTrackingAfterOffset())
                    .position(x: GetPosition().x, y: GetPosition().y  )
                    //.blendMode(.difference)
                    //.lineLimit(nil)
                    //.frame(width: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.width, height: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.height, alignment: .center)
                    //
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
                    CustomImage( name: fixed ? "tick-active" : "tick-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: fixedEnabled)
                
                //Button for delete
                Button(action: {self.IgnoreBtnTapped()}){
                    CustomImage( name: ignored ? "forbidden-active" : "forbidden-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: ignoredEnabled)
            }
            .frame(width: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.width ?? 0, height: stringObjectVM.FindStringObjectByID(id: id)?.stringRect.height ?? 0, alignment: .bottomTrailing)
            .position(x: GetPosition().x , y: GetPosition().y + smallBtnSize )
        }
    }
}

struct StringLabel_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}){
            //            Text("􀍢")
            //
            //                //.background(Color.black)
            //                .foregroundColor(Color.white)
            //                //.border(Color.black, width: 1)
            //                //.shadow(radius: 0.1)
            //                .cornerRadius(10)
        }
        .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .shadow(radius: 10)
    }
}
