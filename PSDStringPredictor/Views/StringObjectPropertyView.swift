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
    @State private var textColor: CGColor = CGColor.init(srgbRed: 1, green: 1, blue: 1, alpha: 1)
         
    
    //Constant
    var panelWidth: CGFloat
    //    var contentWidth: CGFloat = 300 - 60 - 15
    var titleWidth: CGFloat = 70
    
    @ObservedObject var psdsVM: PsdsVM
    @ObservedObject var settingVM: SettingViewModel
    
    func GetLastSelectObject() -> StringObject{
        psdsVM.fetchLastStringObjectFromSelectedPsd()
    }

    
    func fontSizeCommit(){
        if psdsVM.selectedPsdId != nil && psdsVM.selectedStrIDList.last != nil && fontSize.isNumeric == true  {
            let newVal = CGFloat((fontSize as NSString).floatValue) + (psdsVM.DragOffsetDict[psdsVM.selectedStrIDList.last!]?.height ?? 0)
            //Set fontSize for every selected string.
            for id in psdsVM.selectedStrIDList {
                psdsVM.stringObjectDict[id]!.fontSize = newVal
            }
        }
        fontSize = ""
    }
    
    fileprivate func StringComponents() -> some View {
        VStack(alignment: .leading){
            ScrollView ( .horizontal, showsIndicators: true) {
                HStack {
                    ForEach(0..<psdsVM.fetchLastStringObjectFromSelectedPsd().charImageList.count, id: \.self){ index in
                        VStack{
                            Text("\(String(psdsVM.fetchLastStringObjectFromSelectedPsd().charArray[index]))")
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
        TextField("\(GetLastSelectObject().content)", text: $psdsVM.tmpObjectForStringProperty.content, onCommit: {psdsVM.commitTempStringObject()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var fontSizeFloatingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.fontSize)", text: $psdsVM.tmpObjectForStringProperty.fontSize, onCommit: {psdsVM.commitFontSize()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var fontTrackingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.tracking)", text: $psdsVM.tmpObjectForStringProperty.tracking, onCommit: {psdsVM.commitFontTracking()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var posXFloatingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.posX)", text: $psdsVM.tmpObjectForStringProperty.posX, onCommit: {psdsVM.commitPosX()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width:102, alignment: .center)
    }
    
    var posYFloatingTextField: some View {
        TextField("\(psdsVM.tmpObjectForStringProperty.posY)", text: $psdsVM.tmpObjectForStringProperty.posY, onCommit: {psdsVM.commitPosY()})
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width:102, alignment: .center)
    }
    
    var body: some View {
        VStack{
            Group{
                Text("String Infomation")
                    .padding(.horizontal)
                    .frame(width: panelWidth, alignment: .leading)
                    .foregroundColor(.gray)
                    
                Divider()
                
                contentTextField
                    .padding(.horizontal)
                    .frame(width: panelWidth)
            }

            HStack(spacing: 0){
                Text("Size")
                    .foregroundColor(Color.gray)
                    .padding(.leading)
                    .frame(width: titleWidth, alignment: .leading)
                
                fontSizeFloatingTextField
                    .padding(.trailing)
                    .frame(width: panelWidth - titleWidth)
            }
            
            HStack(spacing: 0){
                Text("Tracking")
                    .padding(.leading)
                    .foregroundColor(Color.gray)
                    .frame(width: titleWidth, alignment: .leading)
                HStack{
                    fontTrackingTextField
                        .padding(.trailing)
                    Toggle(isOn: $psdsVM.linkSizeAndTracking) {
                        Text("Link with size")
                            .fixedSize()
                    }
                }
                .padding(.trailing)
                .frame(width: panelWidth - titleWidth)
            }
            .frame(width: panelWidth)
            
            HStack(spacing: 0){
                Text("Font")
                    .foregroundColor(Color.gray)
                    .padding(.leading)
                    .frame(width:titleWidth, alignment: .leading)
                
                HStack{
                    if GetLastSelectObject().fontSize != 0 {
                        Text("\(GetLastSelectObject().fontName)" )
                    }else{
                        Text("-" )
                    }
                    
                    Spacer()
                    
                    Button(action: {psdsVM.ToggleFontName(objId: psdsVM.selectedStrIDList.last)}, label: {
                        Text("􀅈")
                    })
                    .frame(width: 15, alignment: .trailing)
                    
                }
                .padding(.trailing)
                .frame(width: panelWidth - titleWidth, alignment: .leading)

                
            }
            .frame(width: panelWidth)

            HStack(spacing: 0){
                Text("Color")
                    .foregroundColor(Color.gray)
                    .padding(.leading)
                    .frame(width: titleWidth, alignment: .leading)
                
                HStack{
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
                        if psdsVM.tmpObjectForStringProperty.color.components!.count >= 3{
                            Text("\(Int(((psdsVM.tmpObjectForStringProperty.color.components?[0] ?? 0) * 255).rounded()))|\(Int(((psdsVM.tmpObjectForStringProperty.color.components?[1] ?? 0) * 255).rounded()))|\(Int(((psdsVM.tmpObjectForStringProperty.color.components?[2] ?? 0) * 255).rounded()))")
                        }else if psdsVM.tmpObjectForStringProperty.color.components?.count == 1{
                            Text("\(Int(((psdsVM.tmpObjectForStringProperty.color.components?[0] ?? 0) * 255).rounded()))")
                        }else {
                            Text("\(psdsVM.tmpObjectForStringProperty.color.ToString())")
                        }
                    }else {
                        Text("-")
                    }
                    //Color block
                    ColorPicker("", selection: $textColor)
                        .frame(width: 15, height: 15, alignment: .center)
                        .mask(RoundedRectangle(cornerRadius: 2))
                    
                    Spacer()
                    
                    Button(action: {saveColor() }, label: {
                        Text("􀈄")
                    })
                    .frame(width: 15, alignment: .trailing)
                    .padding(.horizontal)
                    
                    Button(action: {toggleColor()}, label: {
                        Text("􀅈")
                    }).frame(width: 15, alignment: .trailing)
                }
                .padding(.trailing)
                .frame(width: panelWidth - titleWidth, alignment: .leading)
            }
            .frame(width: panelWidth)
            
            HStack(spacing: 0){
                Text("Position")
                    .foregroundColor(Color.gray)
                    .padding(.leading)
                    .frame(width: titleWidth, alignment: .leading)
                
                HStack{
                    posXFloatingTextField
                    posYFloatingTextField
                }.frame(width: panelWidth - titleWidth  , alignment: .leading)
                
                
            }
            .frame(width: panelWidth)

            if settingVM.debugMode == true {
                StringComponents()
            }
            
                
        }
        
    }
    
    func saveColor(){
        guard let lastID = psdsVM.selectedStrIDList.last else {return }
        psdsVM.tmpObjectForStringProperty.color = textColor
        psdsVM.commitTempStringObject()
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
