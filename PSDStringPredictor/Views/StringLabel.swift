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
    @ObservedObject var interactive: InteractiveViewModel
    @State var alignmentIconName = "alignCenter-round"
    @Binding var showFakeString: UUID
    @ObservedObject var psdsVM: PsdsVM
    

    func GetPosition() -> CGPoint{
        
        if psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: stringObject.id) != nil{
            let x = (stringObject.stringRect.origin.x) + (stringObject.stringRect.width)/2
//            let x = (stringObject.stringRect.midX)  // midX will left aligned
            let y = psdsVM.selectedNSImage.size.height - (stringObject.stringRect.origin.y)  - (stringObject.stringRect.height)/2
            return CGPoint(x: x, y: y)
        }else{
            return CGPoint.zero
        }
    }
    
    var TextLayerView: some View {
        ZStack{
            
            //Fake
            Text(psdsVM.tmpObjectForStringProperty.content)
                .tracking(psdsVM.tmpObjectForStringProperty.tracking.toCGFloat())
                .position(x: psdsVM.tmpObjectForStringProperty.posX.toCGFloat() + psdsVM.tmpObjectForStringProperty.width / 2 , y: (psdsVM.GetSelectedPsd()?.height ?? 0) - psdsVM.tmpObjectForStringProperty.posY.toCGFloat() - psdsVM.tmpObjectForStringProperty.height / 2)
                .foregroundColor( Color.gray)
                .font(.custom(psdsVM.tmpObjectForStringProperty.fontName, size: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat()))
//                .shadow(color: stringObject.colorMode == MacColorMode.dark ?  .black : .white, radius: 2, x: 0, y: 0)
                .IsHidden(condition: stringObject.id == showFakeString)
                .blendMode(.difference)
    
            Text(stringObject.content)
                .tracking(stringObject.tracking)
                .position(x: stringObject.stringRect.minX + stringObject.stringRect.width / 2 , y: (psdsVM.GetSelectedPsd()?.height ?? 0) - (stringObject.stringRect.minY + stringObject.stringRect.height / 2))
                .foregroundColor(psdsVM.stringDifferenceShow == true ? Color.red.opacity(0.5) : stringObject.color.ToColor() )
                .font(.custom(stringObject.FontName, size: stringObject.fontSize))
                .shadow(color: stringObject.colorMode == MacColorMode.dark ?  .black : .white, radius: 2, x: 0, y: 0)
                .IsHidden(condition: stringObject.id != showFakeString)
//                .blendMode(psdsVM.stringDifferenceShow == true ? .difference : .normal)
//                .onTapGesture {
//                    //Tap to select stringobject
//                    psdsVM.selectedStrIDList.removeAll()
//                    psdsVM.selectedStrIDList.append(stringObject.id)
//                    psdsVM.tmpObjectForStringProperty = stringObject.toObjectForStringProperty()
//                    FontUtils.GetStringBound(str: stringObject.content, fontName: stringObject.FontName, fontSize: stringObject.fontSize, tracking: stringObject.tracking)
//                }
                .gesture(
                    TapGesture().modifiers(.shift).onEnded ({ (loc) in
                    if psdsVM.selectedStrIDList.contains(stringObject.id){
                        psdsVM.selectedStrIDList.removeAll(where: {$0 == stringObject.id})
                        psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.toObjectForStringProperty()
                    }else {
                        psdsVM.selectedStrIDList.append(stringObject.id)
                        psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.toObjectForStringProperty()
                    }
                    })
                .exclusively(before: TapGesture().onEnded({ (loc) in
                             psdsVM.selectedStrIDList.removeAll()
                             psdsVM.selectedStrIDList.append(stringObject.id)
                             psdsVM.tmpObjectForStringProperty = stringObject.toObjectForStringProperty()
                             FontUtils.GetStringBound(str: stringObject.content, fontName: stringObject.FontName, fontSize: stringObject.fontSize, tracking: stringObject.tracking)
                            })
                        )
                )
            
                Color.red
                    .frame(width: 2, height: 2, alignment: .center)
                    .position(x: stringObject.stringRect.minX , y: (psdsVM.GetSelectedPsd()?.height ?? 0) - (stringObject.stringRect.minY ))
                    .onTapGesture {
                        print("Position: \(stringObject.stringRect.minX), \((psdsVM.GetSelectedPsd()?.height ?? 0) - psdsVM.tmpObjectForStringProperty.posY.toCGFloat())")
                    }
            
//            Color.yellow
//                .frame(width: 2, height: 2, alignment: .center)
//                .position(x: psdsVM.tmpObjectForStringProperty.posX.toCGFloat() , y: (psdsVM.GetSelectedPsd()?.height ?? 0) - (stringObject.stringRect.minY ))
//                .onTapGesture {
//                    print("Position: \(psdsVM.tmpObjectForStringProperty.posX.toCGFloat()), \( psdsVM.tmpObjectForStringProperty.posY.toCGFloat())")
//                }

    
        }
        //New aligned text
//        ZStack{
//            AlignedText(fontSize: stringObject.fontSize, fontName: stringObject.FontName, color: stringObject.color, alignment: stringObject.alignment, content: stringObject.content, isHighLight: false, pageWidth: psdsVM.GetSelectedPsd()!.width,   pageHeight: psdsVM.GetSelectedPsd()!.height)
//            AlignedText(fontSize: stringObject.fontSize, tracking: stringObject.tracking, fontName: stringObject.FontName, color: stringObject.color, posX: stringObject.stringRect.minX, posY: stringObject.stringRect.minY, width: stringObject.stringRect.width , height: stringObject.stringRect.height, alignment: stringObject.alignment, content: stringObject.content, isHighLight: false, pageWidth: psdsVM.GetSelectedPsd()!.width, pageHeight: psdsVM.GetSelectedPsd()!.height)
//                .position(x: stringObject.stringRect.midX , y: psdsVM.GetSelectedPsd()!.height - stringObject.stringRect.midY  ).IsHidden(condition: showFakeString != stringObject.id)

            
            //Fake String
            //For the position will be different depends on the alignment
//            if psdsVM.tmpObjectForStringProperty.alignment == .center{
//                AlignedText(fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: psdsVM.tmpObjectForStringProperty.tracking.toCGFloat(), fontName: stringObject.FontName, color: stringObject.color, posX: psdsVM.tmpObjectForStringProperty.posX.toCGFloat(), posY: psdsVM.tmpObjectForStringProperty.posY.toCGFloat(), width: psdsVM.tmpObjectForStringProperty.width, height: psdsVM.tmpObjectForStringProperty.height, alignment: psdsVM.tmpObjectForStringProperty.alignment, content: stringObject.content, isHighLight: true, pageWidth: psdsVM.GetSelectedPsd()!.width, pageHeight: psdsVM.GetSelectedPsd()!.height)
//                    .position(x: psdsVM.tmpObjectForStringProperty.posX.toCGFloat() + stringObject.stringRect.width / 2, y: psdsVM.GetSelectedPsd()!.height - psdsVM.tmpObjectForStringProperty.posY.toCGFloat() - psdsVM.tmpObjectForStringProperty.height / 2 ).IsHidden(condition: showFakeString == stringObject.id)
//            }else if psdsVM.tmpObjectForStringProperty.alignment == .left {
//                AlignedText(fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: psdsVM.tmpObjectForStringProperty.tracking.toCGFloat(), fontName: stringObject.FontName, color: stringObject.color, posX: psdsVM.tmpObjectForStringProperty.posX.toCGFloat(), posY: psdsVM.tmpObjectForStringProperty.posY.toCGFloat(), width: psdsVM.tmpObjectForStringProperty.width, height: psdsVM.tmpObjectForStringProperty.height, alignment: psdsVM.tmpObjectForStringProperty.alignment, content: stringObject.content, isHighLight: true, pageWidth: psdsVM.GetSelectedPsd()!.width, pageHeight: psdsVM.GetSelectedPsd()!.height)
//                    .position(x: psdsVM.tmpObjectForStringProperty.posX.toCGFloat() + psdsVM.tmpObjectForStringProperty.width / 2, y: psdsVM.GetSelectedPsd()!.height - psdsVM.tmpObjectForStringProperty.posY.toCGFloat() - psdsVM.tmpObjectForStringProperty.height / 2 ).IsHidden(condition: showFakeString == stringObject.id)
//            }else if psdsVM.tmpObjectForStringProperty.alignment == .right {
//                AlignedText(fontSize: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat(), tracking: psdsVM.tmpObjectForStringProperty.tracking.toCGFloat(), fontName: stringObject.FontName, color: stringObject.color, posX: psdsVM.tmpObjectForStringProperty.posX.toCGFloat(), posY: psdsVM.tmpObjectForStringProperty.posY.toCGFloat(), width: psdsVM.tmpObjectForStringProperty.width, height: psdsVM.tmpObjectForStringProperty.height, alignment: psdsVM.tmpObjectForStringProperty.alignment, content: stringObject.content, isHighLight: true, pageWidth: psdsVM.GetSelectedPsd()!.width, pageHeight: psdsVM.GetSelectedPsd()!.height)
//                    .position(x: psdsVM.tmpObjectForStringProperty.posX.toCGFloat() - psdsVM.tmpObjectForStringProperty.width / 2 + stringObject.stringRect.width, y: psdsVM.GetSelectedPsd()!.height - psdsVM.tmpObjectForStringProperty.posY.toCGFloat() - psdsVM.tmpObjectForStringProperty.height / 2 ).IsHidden(condition: showFakeString == stringObject.id)
//            }

//        }
    }
    
    fileprivate func StringFrameLayerView()-> some View {
        //String debug frame
        Rectangle()
            .stroke(stringObject.status == StringObjectStatus.ignored ? Color.red : Color.green.opacity(0.7), lineWidth: 1 / psdsVM.viewScale)
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
                TextLayerView
                
                //                    .IsHidden(condition: !showFakeString)
                
            }.IsHidden(condition: stringObject.status != StringObjectStatus.ignored)
            
            HStack{
                //Button for alignment
                
                Button(action: {alignmentIconName = psdsVM.alignmentTapped(stringObject.id)}){
                    CustomImage( name: stringObject.alignment.imageName())
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
                .IsHidden(condition: psdsVM.selectedStrIDList.contains(stringObject.id)==true || stringObject.status == StringObjectStatus.fixed)
                
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
