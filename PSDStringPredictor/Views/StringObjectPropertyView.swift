//
//  StringObjectPropertyView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringObjectPropertyView: View {
    
    //    @ObservedObject var stringObjectVM = psdViewModel
    //    @ObservedObject var imageProcess = imageProcessViewModel
    //@State var stringList: [String]
    @State var weight: String = "Regular"
    @State var fontSize: String = "0"
    @State var content: String = "No Content."
    @State var posX: String = "0"
    @State var posY: String = "0"
    
    //Constant
    var contentWidth: CGFloat = 200
    var titleWidth: CGFloat = 60
    
    @ObservedObject var psdsVM: PsdsVM
    
    func GetLastSelectObject() -> StringObject{
        guard let id = psdsVM.selectedStrIDList.last else {return zeroStringObject}
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id) ?? zeroStringObject
    }
    
    func CalcOffsetTracking(targetObj: StringObject) -> CGFloat{
        var offset: CGFloat = 0
        if psdsVM.DragOffsetDict[targetObj.id] != nil{
            offset = psdsVM.DragOffsetDict[targetObj.id]!.width
        }
        return targetObj.tracking + offset
    }
    
    func CalcOffsetSize(targetObj: StringObject) -> CGFloat{
        var offset: CGFloat = 0
        if psdsVM.DragOffsetDict[targetObj.id] != nil{
            offset = psdsVM.DragOffsetDict[targetObj.id]!.height
        }
        
        return targetObj.fontSize - offset
    }
    
    func fontSizeCommit(){
        if psdsVM.selectedPsdId != nil && psdsVM.selectedStrIDList.last != nil && fontSize.isNumeric == true  {
            let newVal = CGFloat((fontSize as NSString).floatValue) + (psdsVM.DragOffsetDict[psdsVM.selectedStrIDList.last!]?.height ?? 0)
            //Set fontSize for every selected string.
            for id in psdsVM.selectedStrIDList {
                psdsVM.psdModel.SetFontSize(psdId: psdsVM.selectedPsdId, objId: id, value: newVal, offset: false)
            }
        }
        fontSize = ""
    }
    
//    func posCommit(){
//        if psdsVM.selectedPsdId != nil && psdsVM.selectedStrIDList.last != nil && posX.isNumeric == true  {
////            let newVal = CGFloat((posX as NSString).floatValue)
//            //Set positionX for every selected string.
////            for id in psdsVM.selectedStrIDList {
////                psdsVM.psdModel.SetPosForString(psdId: psdsVM.selectedPsdId, objId: id, valueX: newVal, valueY: 0, isOnlyX: true, isOnlyY: false)
////            }
//            psdsVM.tmpObjectForStringProperty.posX =
//            psdsVM.selectedLastStringObject.stringRect = newRect
//            if psdsVM.selectedPsdId != nil && psdsVM.selectedStrIDList.last != nil && content.isEmpty == false  {
//                psdsVM.psdModel.SetLastStringObject(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, value: psdsVM.selectedLastStringObject)
//            }
//
//        }
//    }
    
//    func posYCommit(){
//        if psdsVM.selectedPsdId != nil && psdsVM.selectedStrIDList.last != nil && posY.isNumeric == true  {
//            let newVal = CGFloat((posY as NSString).floatValue)
//            //Set positionX for every selected string.
//            for id in psdsVM.selectedStrIDList {
//                psdsVM.psdModel.SetPosForString(psdId: psdsVM.selectedPsdId, objId: id, valueX: 0, valueY: newVal, isOnlyX: false, isOnlyY: true)
//            }
//        }
//        posY = ""
//    }
    
    func inputCommit(){
        if psdsVM.selectedPsdId != nil && psdsVM.selectedStrIDList.last != nil && content.isEmpty == false  {
            psdsVM.psdModel.SetLastStringObject(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, value: psdsVM.tmpObjectForStringProperty.toStringObject(strObj: GetLastSelectObject()))
        }
    }
    
    fileprivate func StringComponents() -> some View {
        VStack(alignment: .leading){
            ScrollView ( .horizontal, showsIndicators: true) {
                HStack {
                    ForEach(0..<GetLastSelectObject().charImageList.count, id: \.self){ index in
                        VStack{
                            Text("\(String(GetLastSelectObject().charArray[index]))")
                            OneCharPropertyView(index: index, psdsVM: psdsVM)
                        }
                    }
                }
                .fixedSize()
            }
        }
    }
    
    @ViewBuilder
    func FontSizeView(index: Int) -> some View {
        if psdsVM.selectedStrIDList.count == 0 {
            Text("")
        }else{
            if GetLastSelectObject().isPredictedList[index] == 1 {
                Text(String(GetLastSelectObject().charSizeList[index].description)+"􀫥").fixedSize()
            }else{
                Text(String(GetLastSelectObject().charSizeList[index].description)).fixedSize()
            }
        }
    }
    
    var contentTextField: some View {
        //        GeometryReader{ geo in
        //            HStack{
        TextField("\(GetLastSelectObject().content)", text: $psdsVM.tmpObjectForStringProperty.content, onCommit: {inputCommit()})
            
            .textFieldStyle(RoundedBorderTextFieldStyle())
            //            .background(Color.black)
//            .onTapGesture(perform: {
//                print("Focused")
//            })
        //
        //            }.frame(width:geo.size.width )
        
        //        }
    }
    
    var fontSizeFloatingTextField: some View {
//        GeometryReader{ geo in
//            HStack{
//                TextField("", text: $fontSize, onCommit: {fontSizeCommit()})
//
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                //                    .background(Color.black)
//                //
//            }.frame(width:geo.size.width * 0.9)
//        }
        TextField("\(psdsVM.tmpObjectForStringProperty.fontSize)", text: $psdsVM.tmpObjectForStringProperty.fontSize, onCommit: {inputCommit()})
            .textFieldStyle(RoundedBorderTextFieldStyle())

    }
    
    var posXFloatingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.posX)", text: $psdsVM.tmpObjectForStringProperty.posX, onCommit: {inputCommit()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
            //            .background(Color.black)
            .frame(width:80, alignment: .center)
    }
    
    var posYFloatingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.posY)", text: $psdsVM.tmpObjectForStringProperty.posY, onCommit: {inputCommit()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
            //            .background(Color.black)
            .frame(width:80, alignment: .center)
    }
    
    var body: some View {
        List{
            Section(header: Text("String Properties")){
                VStack{
                    //                    Text("Content")
                    //                        .foregroundColor(Color.gray)
                    //                        .frame(width: columnWidth, alignment: .topLeading)
                    //                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    
                    contentTextField
                }
                
                //                HStack{
                //                    Text("Color Mode")
                //                        .foregroundColor(Color.gray)
                //                        .frame(width:80, alignment: .topLeading)
                //                    if GetLastSelectObject().colorMode == MacColorMode.light {
                //                        Text("􀆮")
                //                            .frame(width:200, alignment: .topLeading)
                //                    }else if GetLastSelectObject().colorMode == MacColorMode.dark {
                //                        Text("􀆺")
                //                            .frame(width:200, alignment: .topLeading)
                //                    }else{}
                //                }
                
                HStack{
                    Text("Size")
                        .foregroundColor(Color.gray)
                        .frame(width:titleWidth, alignment: .topLeading)
                    
                    fontSizeFloatingTextField.frame(width:contentWidth )
                    
                }
                
                HStack{
                    Text("Tracking")
                        .foregroundColor(Color.gray)
                        .frame(width: titleWidth, alignment: .topLeading)
                    Text("\(CalcOffsetTracking(targetObj: GetLastSelectObject()))")
                        .frame(width:200, alignment: .topLeading)
                }
                
                HStack{
                    Text("Font")
                        .foregroundColor(Color.gray)
                        .frame(width:titleWidth, alignment: .topLeading)
                    
                    Spacer()
                    
                    if GetLastSelectObject().fontSize != 0 {
                        HStack{
                            Text("\(GetLastSelectObject().FontName)" )
                                .frame( alignment: .topLeading)
                            Spacer()
                            Button(action: {psdsVM.ToggleFontName(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)}, label: {
                                Text("􀜊")
                            }).frame(width: 20, alignment: .trailing)
                            
                        }.frame(width:contentWidth )
                        
                    }else {
                        Text("No font name." )
                            .frame(width:contentWidth, alignment: .topLeading)
                        //                                .foregroundColor(.gray)
                    }
                }
                //                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                
                HStack{
                    Text("Color")
                        .foregroundColor(Color.gray)
                        .frame(width:titleWidth, alignment: .topLeading)
                    
                    Group{
                        //Color mode icon
                        if GetLastSelectObject().colorMode == MacColorMode.light {
                            Text("􀆮")
                                .frame(width:20, alignment: .leading)
                        }else if GetLastSelectObject().colorMode == MacColorMode.dark {
                            Text("􀆺")
                                .frame(width:20, alignment: .leading)
                        }else{}
                        
                        
                        //Color numbers
                        if psdsVM.selectedStrIDList.count > 0{
                            Text("\(Int((GetLastSelectObject().color.components![0] * 255).rounded())), \(Int((GetLastSelectObject().color.components![1] * 255).rounded())), \(Int((GetLastSelectObject().color.components![2] * 255).rounded()))")
                        }else {
                            Text("0,0,0")
                        }
                        //Color block
                        Color.init(GetLastSelectObject().color).frame(width: 10, height: 10, alignment: .center)
                    }
                    
                }.onTapGesture {
                    if psdsVM.selectedStrIDList.count > 0 {
                        psdsVM.ToggleColorMode(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)
                    }
                }
                
                HStack{
                    Text("Position")
                        .foregroundColor(Color.gray)
                        .frame(width: titleWidth, alignment: .topLeading)
                    //                    Text( " \(Int(GetLastSelectObject().stringRect.minX.rounded())) " )
                    //                        .frame(width: 40).background(Color.black)
                    //                        .overlay(
                    //                            posXFloatingTextField
                    //                                .onTapGesture {
                    //                                    posX = ""
                    //                                }
                    //                                .opacity(posX == "" ? 0.6:1)
                    //                        )
                    //                    Text( " \(Int(GetLastSelectObject().stringRect.minY.rounded())) " )
                    //                        .frame(width: 40).background(Color.black)
                    //                        .overlay(
                    //                            posYFloatingTextField
                    //                                .onTapGesture {
                    //                                    posY = ""
                    //                                }
                    //                                .opacity(posY == "" ? 0.6:1)
                    //                        )
                    HStack{
                        posXFloatingTextField
                        posYFloatingTextField
                    }.frame(width: contentWidth , alignment: .topLeading)
                    
                    
                }
                
                StringComponents()
                
            }
        }
    }
    
    func CharSaveBtnPressed(_ index: Int){
        let panel = NSSavePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                GetLastSelectObject().charImageList[index].ToPNG(url: panel.url!)
                let bw = SetGrayScale(GetLastSelectObject().charImageList[index] )
                let newUrl = URL.init(fileURLWithPath: panel.url!.path + "_bw.bmp")
                bw!.ToPNG(url: newUrl)
            }
        }
    }
    
    func StringSaveBtnPressed(){
        
    }
}

//struct StringObjectPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        StringObjectPropertyView()
//    }
//}
