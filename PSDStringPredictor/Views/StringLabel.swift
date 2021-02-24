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
    var stringObject: StringObject
//    var id: UUID
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
    @Binding var showFakeString: Bool
    @ObservedObject var psdsVM: PsdsVM
    

    

    
    func GetPosition() -> CGPoint{
        
        if psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: stringObject.id) != nil{
            let x = (stringObject.stringRect.origin.x) + (stringObject.stringRect.width)/2
            let y = psdsVM.selectedNSImage.size.height - (stringObject.stringRect.origin.y)  - (stringObject.stringRect.height)/2
            return CGPoint(x: x, y: y)
        }else{
            return CGPoint.zero
        }
    }
    
    func TextLayerView() -> some View {
        
//        Text(stringObject.content ?? " " )
//            .tracking(stringObject.tracking)
//            .position(x: GetPosition().x , y: GetPosition().y)
//            .foregroundColor(stringObject.color.ToColor() ?? Color.white)
//            .font(.custom(stringObject.FontName, size: stringObject.fontSize))
//            .shadow(color: stringObject.colorMode == MacColorMode.dark ?  .black : .white, radius: 2, x: 0, y: 0)
        
        //New aligned text
        AlignedText(fontSize: stringObject.fontSize, fontName: stringObject.FontName, color: stringObject.color, stringRect: stringObject.stringRect, alignment: stringObject.alignment, content: stringObject.content, isHighLight: false, pageWidth: psdsVM.GetSelectedPsd()!.width,   pageHeight: psdsVM.GetSelectedPsd()!.height)
            .position(x: GetPosition().x, y: GetPosition().y  )
    }
    
    fileprivate func StringFrameLayerView()-> some View {
        //String debug frame
        Rectangle()
            .stroke(stringObject.status == StringObjectStatus.ignored ? Color.red : Color.green.opacity(0.7), lineWidth: 1)

            .frame(width: stringObject.stringRect.width ?? 0, height: stringObject.stringRect.height ?? 0)
            .position(x: GetPosition().x, y: GetPosition().y  )
    }
    
    fileprivate func DragLayerView()-> some View {
        //Drag layer
        Rectangle()
            
            .fill( Color.yellow.opacity(0.1))
            .frame(width: stringObject.stringRect.width ?? 0, height: stringObject.stringRect.height ?? 0)
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
                
//                    .IsHidden(condition: !showFakeString)
                
            }.IsHidden(condition: stringObject.status != StringObjectStatus.ignored)
            
            HStack{
                //Button for alignment
                
                Button(action: {alignmentIconName = psdsVM.alignmentTapped(stringObject.id)}){
                    CustomImage( name: alignmentIconName)
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: psdsVM.selectedStrIDList.contains(stringObject.id)==true)
                
                //Button for fix
                Button(action: {psdsVM.FixedBtnTapped(stringObject.id)}){
                    CustomImage( name: stringObject.status == StringObjectStatus.fixed ? "tick-active" : "tick-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: psdsVM.selectedStrIDList.contains(stringObject.id)==true  || stringObject.status == StringObjectStatus.fixed)
                
                //Button for delete
                Button(action: {psdsVM.IgnoreBtnTapped(stringObject.id)}){
                    CustomImage( name: stringObject.status == StringObjectStatus.ignored ? "forbidden-active" : "forbidden-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: smallBtnSize, height: smallBtnSize)
                .padding(-4)
                .IsHidden(condition: psdsVM.selectedStrIDList.contains(stringObject.id)==true || stringObject.status == StringObjectStatus.ignored)
            }
            .frame(width: stringObject.stringRect.width ?? 0, height: stringObject.stringRect.height ?? 0, alignment: .bottomTrailing)
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
