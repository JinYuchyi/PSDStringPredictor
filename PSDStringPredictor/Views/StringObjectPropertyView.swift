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
    @State private var textColor =
            Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    //Constant
    var panelWidth: CGFloat
//    var contentWidth: CGFloat = 300 - 60 - 15
    var titleWidth: CGFloat = 60
    
    @ObservedObject var psdsVM: PsdsVM
    
    func GetLastSelectObject() -> StringObject{
        guard let id = psdsVM.selectedStrIDList.last else {return zeroStringObject}
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id) ?? zeroStringObject
    }
    
//    func CalcOffsetTracking(targetObj: StringObject) -> CGFloat{
//        var offset: CGFloat = 0
//        if psdsVM.DragOffsetDict[targetObj.id] != nil{
//            offset = psdsVM.DragOffsetDict[targetObj.id]!.width
//        }
//        return targetObj.tracking + offset
//    }
//
//    func CalcOffsetSize(targetObj: StringObject) -> CGFloat{
//        var offset: CGFloat = 0
//        if psdsVM.DragOffsetDict[targetObj.id] != nil{
//            offset = psdsVM.DragOffsetDict[targetObj.id]!.height
//        }
//
//        return targetObj.fontSize - offset
//    }
    
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
        TextField("\(GetLastSelectObject().content)", text: $psdsVM.tmpObjectForStringProperty.content, onCommit: {psdsVM.commitTempStringObject()})
            
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
        TextField("\(psdsVM.tmpObjectForStringProperty.fontSize)", text: $psdsVM.tmpObjectForStringProperty.fontSize, onCommit: {psdsVM.commitFontSize()})
            .textFieldStyle(RoundedBorderTextFieldStyle())

    }
    
    var posXFloatingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.posX)", text: $psdsVM.tmpObjectForStringProperty.posX, onCommit: {psdsVM.commitPosX()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
            //            .background(Color.black)
            .frame(width:95, alignment: .center)
    }
    
    var posYFloatingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.posY)", text: $psdsVM.tmpObjectForStringProperty.posY, onCommit: {psdsVM.commitPosY()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
            //            .background(Color.black)
            .frame(width:95, alignment: .center)
    }
    
    var body: some View {
        List{
            Text("String Infomation").frame(width: 300, alignment: .leading).foregroundColor(.gray)
            Divider()
                VStack{
                    contentTextField
                }
                

                
                HStack{
                    Text("Size")
                        .foregroundColor(Color.gray)
                        .frame(width:titleWidth, alignment: .topLeading)
                    
                    fontSizeFloatingTextField.frame(width: panelWidth - titleWidth )
                    
                }
                
                HStack{
                    Text("Tracking")
                        .foregroundColor(Color.gray)
                        .frame(width: titleWidth, alignment: .topLeading)
                    Text("\(GetLastSelectObject().tracking)")
                        .frame(width:200, alignment: .topLeading)
                }
                
                HStack{
                    Text("Font")
                        .foregroundColor(Color.gray)
                        .frame(width:titleWidth, alignment: .topLeading)
                    
                    if GetLastSelectObject().fontSize != 0 {
                            Text("\(GetLastSelectObject().FontName)" )
                                .frame( alignment: .topLeading)
                    }
                    
                    Spacer()
                    
                    Button(action: {psdsVM.ToggleFontName(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)}, label: {
                        Text("􀅈")
                    })
                    .frame(width: 15, alignment: .trailing)
                    
                }
//                .frame(width: panelWidth)
                HStack{
                    Text("Color")
                        .foregroundColor(Color.gray)
                        .frame(width:titleWidth, alignment: .topLeading)
                    
                    Group{
                        //Color mode icon
                        if GetLastSelectObject().colorMode == MacColorMode.light {
                            Text("􀆮")
                                .frame(width:15, alignment: .leading)
                        }else if GetLastSelectObject().colorMode == MacColorMode.dark {
                            Text("􀆺")
                                .frame(width:15, alignment: .leading)
                        }else{}
                        
                        
                        //Color numbers
                        if psdsVM.selectedStrIDList.count > 0{
                            Text("\(Int(((psdsVM.tmpObjectForStringProperty.color.components?[0] ?? 0) * 255).rounded()))|\(Int(((psdsVM.tmpObjectForStringProperty.color.components?[1] ?? 0) * 255).rounded()))|\(Int(((psdsVM.tmpObjectForStringProperty.color.components?[2] ?? 0) * 255).rounded()))")
                        }else {
                            Text("No Color Infomation")
                        }
                        //Color block
                        ColorPicker("", selection: $psdsVM.tmpObjectForStringProperty.color)
                            .frame(width: 10, height: 10, alignment: .center)
                            .mask(RoundedRectangle(cornerRadius: 2))
//                            .padding(.horizontal)
                            
//                        Color.init(GetLastSelectObject().color).frame(width: 10, height: 10, alignment: .center)
//                            .onTapGesture {
//
//                            }
                        
                        //Toggle button
                        Spacer()
                        Button(action: {psdsVM.commitTempStringObject(); }, label: {
                            Text("􀈄")
                        })
                        .frame(width: 15, alignment: .trailing)
                        .padding(.horizontal)
                        Button(action: {toggleColor()}, label: {
                            Text("􀅈")
                        }).frame(width: 15, alignment: .trailing)
                    }
                    
                }
                
                HStack{
                    Text("Position")
                        .foregroundColor(Color.gray)
                        .frame(width: titleWidth, alignment: .topLeading)

                    HStack{
                        posXFloatingTextField
                        posYFloatingTextField
                    }.frame(width: panelWidth - titleWidth  , alignment: .topLeading)
                    
                    
                }
                
                StringComponents()
                
            }
        
    }
    
    func toggleColor() {
            if psdsVM.selectedStrIDList.count > 0 {
                psdsVM.ToggleColorMode(psdId: psdsVM.selectedPsdId)
                
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
