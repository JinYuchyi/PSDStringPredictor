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
//    var stringObject: StringObject
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
    @ObservedObject var interactive: InteractiveViewModel
    @State var alignmentIconName = "alignCenter-round"
    @Binding var showFakeString: UUID
    @ObservedObject var psdsVM: PsdsVM
    

//    func getObject() -> StringObject{
//        return psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: id) ?? StringObject.init()
//    }
    
   
    
    func GetPosition() -> CGPoint{
        guard let obj = psdsVM.stringObjectDict[id] else {return CGPoint.zero}
//        if psdsVM.stringObjectDict[id] != nil{
        let x = (obj.stringRect.origin.x) + (obj.stringRect.width)/2
//            let x = (stringObject.stringRect.midX)  // midX will left aligned
        let y = psdsVM.GetSelectedPsd()!.height - (obj.stringRect.origin.y)  - (obj.stringRect.height)/2
        return CGPoint(x: x, y: y)
//        }else{
//            return CGPoint.zero
//        }
    }
    
    func getAlignLabelPos() -> CGFloat{
        if psdsVM.fetchStringObject(strId: id).alignment == .left{
            return psdsVM.fetchStringObject(strId: id).stringRect.minX
        }else if psdsVM.fetchStringObject(strId: id).alignment == .center {
            return psdsVM.fetchStringObject(strId: id).stringRect.midX
        }else{
            return psdsVM.fetchStringObject(strId: id).stringRect.maxX
        }
        
    }
    
    var TextLayerView: some View {
        ZStack{
            
            //Fake
            if id == showFakeString {
            Text(psdsVM.tmpObjectForStringProperty.content)
                .tracking(psdsVM.tmpObjectForStringProperty.tracking.toCGFloat())
//                .tracking(psdsVM.tmpTracking)

                .position(
                    x: psdsVM.tmpObjectForStringProperty.posX.toCGFloat() + psdsVM.tmpObjectForStringProperty.width / 2  + psdsVM.tmpObjectForStringProperty.tracking.toCGFloat() / 2 - FontUtils.GetCharFrontOffset(content: psdsVM.fetchStringObject(strId: id).content, fontSize: psdsVM.fetchStringObject(strId: id).fontSize),
                    y: (psdsVM.GetSelectedPsd()!.height) - psdsVM.tmpObjectForStringProperty.posY.toCGFloat() - psdsVM.tmpObjectForStringProperty.height / 2
                )
                
                .foregroundColor( Color.gray)
                .font(.custom(psdsVM.tmpObjectForStringProperty.fontName, size: psdsVM.tmpObjectForStringProperty.fontSize.toCGFloat()))
                .blendMode(.difference)
            }
            
            if showFakeString == zeroUUID{
            Text(psdsVM.fetchStringObject(strId: id).content)
                .tracking(psdsVM.fetchStringObject(strId: id).tracking)
                .position(x: psdsVM.calcStringPositionOnImage(psdId: psdsVM.selectedPsdId, objId: id)[0], y: psdsVM.calcStringPositionOnImage(psdId: psdsVM.selectedPsdId, objId: id)[1])
                .foregroundColor(getColor())
                .font(.custom(psdsVM.fetchStringObject(strId: id).fontName, size: psdsVM.fetchStringObject(strId: id).fontSize))
//                .shadow(color: getObject().colorMode == MacColorMode.dark ?  .black : .white, radius: 2, x: 0, y: 0)
                .IsHidden(condition: psdsVM.fetchStringObject(strId: id).id != showFakeString)
//                .blendMode(psdsVM.stringDifferenceShow == true ? .difference : .normal)
//                .onTapGesture {
//                    //  select stringobject
//                    psdsVM.selectedStrIDList.removeAll()
//                    psdsVM.selectedStrIDList.append(stringObject.id)
//                    psdsVM.tmpObjectForStringProperty = stringObject.toObjectForStringProperty()
//                    FontUtils.GetStringBound(str: stringObject.content, fontName: stringObject.FontName, fontSize: stringObject.fontSize, tracking: stringObject.tracking)
//                }
                .gesture(
                    TapGesture().modifiers(.shift).onEnded ({ (loc) in
                    if psdsVM.selectedStrIDList.contains( id){
                        psdsVM.selectedStrIDList.removeAll(where: {$0 == id})
                        psdsVM.fetchLastStringObjectFromSelectedPsd().toObjectForStringProperty()
                    }else {
                        psdsVM.selectedStrIDList.append(id)
                        psdsVM.fetchLastStringObjectFromSelectedPsd().toObjectForStringProperty()
                    }
                    })
                .exclusively(before: TapGesture().onEnded({ (loc) in
//                    print(FontUtils.GetCharFrontOffset(content: getObject().content, fontSize: getObject().fontSize))
                     psdsVM.selectedStrIDList.removeAll()
                     psdsVM.selectedStrIDList.append(id)
                     psdsVM.tmpObjectForStringProperty = psdsVM.fetchStringObject(strId: id).toObjectForStringProperty()
//                    print("psdsVM.tmpObjectForStringProperty Color: \(psdsVM.tmpObjectForStringProperty.color), obj: \(psdsVM.GetSelectedPsd()!.GetStringObjectFromOnePsd(objId: psdsVM.selectedStrIDList.last!)!.color)")
//                             FontUtils.GetStringBound(str: stringObject.content, fontName: stringObject.FontName, fontSize: stringObject.fontSize, tracking: stringObject.tracking)
                            })
                        )
                )
            }
               
            
               Text("􀆇")
                .font(.custom("SF Pro Text Regular", size: 8))
                .fontWeight(.black)
                .foregroundColor(Color.green)
                    .position(x: getAlignLabelPos() , y: (psdsVM.GetSelectedPsd()!.height) - (psdsVM.fetchStringObject(strId: id).stringRect.minY ))
                .offset(x: 0, y: 3)
                .frame(alignment: .top)
            

    
        }

    }
    
    func getColor() -> Color {
        var _color: Color = psdsVM.fetchStringObject(strId: id).color.ToColor()
        guard let lastId = psdsVM.selectedStrIDList.last else {return _color}
        if psdsVM.stringDifferenceShow == true {
            _color = Color.red.opacity(0.7)
        }else{
//            _color = psdsVM.fetchStringObject(strId: id).color.ToColor()
        }
        return _color
    }
    
    fileprivate func StringFrameLayerView()-> some View {
        //String debug frame
        Rectangle()
            .stroke(psdsVM.fetchStringObject(strId: id).status == StringObjectStatus.ignored ? Color.red : Color.green.opacity(0.7), lineWidth: 1 / psdsVM.viewScale)
            .frame(width: psdsVM.fetchStringObject(strId: id).stringRect.width ?? 0, height: psdsVM.fetchStringObject(strId: id).stringRect.height ?? 0)
            .position(x: GetPosition().x, y:  GetPosition().y  )
            .blendMode(psdsVM.stringDifferenceShow == true ? .difference : .normal )
            
    }
    
    fileprivate func DragLayerView()-> some View {
        //Drag layer
        Rectangle()
            
            .fill( Color.yellow.opacity(0.1))
            .frame(width: psdsVM.fetchStringObject(strId: id).stringRect.width ?? 0, height: psdsVM.fetchStringObject(strId: id).stringRect.height ?? 0)
            .position(x: GetPosition().x, y: GetPosition().y)
    }
    
    var body: some View {
//        ZStack {
            ZStack { //Debug
                //Text(stringObjectVM.FindStringObjectByID(id: id)!.content)
//                Group{
                    //Frames
                    StringFrameLayerView()
                    
                    //DragLayerView()
//                }
                //.IsHidden(condition: stringObjectVM.stringObjectStatusDict[id] == 0)
                
                //Text content
                TextLayerView
                
                //                    .IsHidden(condition: !showFakeString)
                
            }
//            .IsHidden(condition: getObject().status != StringObjectStatus.ignored)
            
//            HStack{
//                //Button for alignment
//
//                Button(action: {alignmentIconName = psdsVM.alignmentTapped(stringObject.id)}){
//                    CustomImage( name: stringObject.alignment.imageName())
//                        .scaledToFit()
//                }
//                .buttonStyle(RoundButtonStyle())
//                .frame(width: smallBtnSize, height: smallBtnSize)
//                .padding(-4)
//                .IsHidden(condition: psdsVM.selectedStrIDList.contains(stringObject.id)==true)
//
//                //Button for fix
//                Button(action: {psdsVM.FixedBtnTapped(stringObject.id)}){
//                    CustomImage( name: stringObject.status == StringObjectStatus.fixed ? "tick-active" : "tick-round")
//                        .scaledToFit()
//                }
//                .buttonStyle(RoundButtonStyle())
//                .frame(width: smallBtnSize, height: smallBtnSize)
//                .padding(-4)
//                .IsHidden(condition: psdsVM.selectedStrIDList.contains(stringObject.id)==true || stringObject.status == StringObjectStatus.fixed)
//
//                //Button for delete
//                Button(action: {psdsVM.IgnoreBtnTapped(stringObject.id)}){
//                    CustomImage( name: stringObject.status == StringObjectStatus.ignored ? "forbidden-active" : "forbidden-round")
//                        .scaledToFit()
//                }
//                .buttonStyle(RoundButtonStyle())
//                .frame(width: smallBtnSize, height: smallBtnSize)
//                .padding(-4)
//                .IsHidden(condition: psdsVM.selectedStrIDList.contains(stringObject.id)==true || stringObject.status == StringObjectStatus.ignored)
//            }
//            .frame(width: stringObject.stringRect.width ?? 0, height: stringObject.stringRect.height ?? 0, alignment: .bottomTrailing)
//            .position(x: GetPosition().x , y: GetPosition().y + smallBtnSize )
            
//        }
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
