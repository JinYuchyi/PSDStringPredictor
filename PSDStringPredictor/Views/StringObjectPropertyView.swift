//
//  StringObjectPropertyView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/10/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringObjectPropertyView: View {
    
    @ObservedObject var stringObjectVM = stringObjectViewModel
    @ObservedObject var imageProcess = imageProcessViewModel
    @State var stringField: String = ""
    @State var weight: String = "Regular"
    let pixelMgr = PixelProcess()
    
    func GetLastSelectObject() -> StringObject{
        return stringObjectVM.stringObjectListData.FindByID(stringObjectVM.selectedIDList.last!)!
    }

    func CalcOffsetTracking(targetObj: StringObject) -> CGFloat{
        var offset: CGFloat = 0
        if stringObjectVM.DragOffsetDict[targetObj.id] != nil{
            offset = stringObjectVM.DragOffsetDict[targetObj.id]!.width
        }
        return targetObj.tracking + offset
    }
    
    func CalcOffsetSize(targetObj: StringObject) -> CGFloat{
        var offset: CGFloat = 0
        if stringObjectVM.DragOffsetDict[targetObj.id] != nil{
            offset = stringObjectVM.DragOffsetDict[targetObj.id]!.height
        }
        return targetObj.fontSize - offset
    }
    
    fileprivate func StringComponents() -> some View {
        VStack(alignment: .leading){
            Text("Components")
                .foregroundColor(Color.gray)
            ScrollView ( .horizontal, showsIndicators: true) {
                
                HStack {
                    
                    ForEach(0..<GetLastSelectObject().charImageList.count, id: \.self){ index in
                        
                        VStack{
                            if GetLastSelectObject().charColorModeList[index] == 1{
                                
                                Image(nsImage: GetLastSelectObject().charImageList[index].ToNSImage())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                                    .border(Color.yellow, width: 1)
                            }else if  GetLastSelectObject().charColorModeList[index] == 2{
                                Image(nsImage: GetLastSelectObject().charImageList[index].ToNSImage())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                                    .border(Color.blue, width: 1)
                            }

                            TextField(String(GetLastSelectObject().charArray[index]), text: $stringField)
                            
                            Text("\(Int(GetLastSelectObject().charRects[index].width.rounded()))/\(Int(GetLastSelectObject().charRects[index].height.rounded()))")
                            Text(String(GetLastSelectObject().charFontWeightList[index]))
                            
                            FontSizeView(index: index)
                            
                            Button(action: {CharSaveBtnPressed(index)}){
                                Text("􀈄")
                            }
                            
                        }
                        
                    }
                }
                .fixedSize()
            }
        }
    }
    
    func FontSizeView(index: Int) -> some View {
        if stringObjectVM.selectedIDList.count == 0 {
             Text(" ")
        }else{
            if GetLastSelectObject().isPredictedList[index] == 1 {
                 Text(String(GetLastSelectObject().charSizeList[index].description)+"􀫥").fixedSize()
            }else{
                 Text(String(GetLastSelectObject().charSizeList[index].description)).fixedSize()
            }
        }
    }
    
    var body: some View {
        List{
            Section(header: Text("String Properties")){

                HStack{
                    Text("Content")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(stringObjectVM.selectedStringObjectList.LastValidItem().content)")
                        .frame(width:200, alignment: .topLeading)
                }
                
                if stringObjectVM.selectedStringObjectList.LastValidItem().content != "No content." {
                    HStack{
                        let targetImg = imageProcess.targetCIImage.cropped(to: stringObjectVM.selectedStringObjectList.LastValidItem().stringRect).ToNSImage()
                        Image(nsImage: targetImg )
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        Spacer()
                        Button(action: {StringSaveBtnPressed()}){
                            Text("􀈄")
                                //.frame(minWidth: 250,  maxWidth: .infinity)
                        }
                        //.frame( maxWidth: .infinity)
                    }
                }
                
                HStack{
                    Text("Color Mode")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    if stringObjectVM.selectedStringObjectList.LastValidItem().colorMode == 1 {
                        Text("􀆮")
                            .frame(width:200, alignment: .topLeading)
                    }else if stringObjectVM.selectedStringObjectList.LastValidItem().colorMode == 2 {
                        Text("􀆺")
                            .frame(width:200, alignment: .topLeading)
                    }else{}
                    
                }

                
                HStack{
                    Text("Size")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(CalcOffsetSize(targetObj: stringObjectVM.selectedStringObjectList.LastValidItem()))")
                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Tracking")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(CalcOffsetTracking(targetObj: stringObjectVM.selectedStringObjectList.LastValidItem()))")
                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Font")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    
                    VStack{
                        if stringObjectVM.selectedStringObjectList.LastValidItem().fontSize != 0 {
                            Text("\(stringObjectVM.selectedStringObjectList.LastValidItem().FontName)" )
                                .frame(width:200, alignment: .topLeading)
                                .onTapGesture {
                                    //if stringObjectVM.selectedStringObject.fontSize != 0 {
                                        //print("Tapped")

                                    let id = stringObjectVM.selectedStringObjectList.LastValidItem().id
                                        let fName = stringObjectVM.StringObjectNameDict[id]
                                        let endIndex = fName!.lastIndex(of: " ")
                                        let startIndex = fName!.startIndex
                                        let particialName = fName![startIndex..<endIndex!]
                                        let weightName = fName![endIndex!..<fName!.endIndex]
                                        
                                        if weightName == " Regular"  {
                                            stringObjectVM.StringObjectNameDict[id] = particialName + " Semibold"
                                            //print("\(stringObjectVM.StringObjectNameDict[id])")
                                        }else {
                                            stringObjectVM.StringObjectNameDict[id] = particialName + " Regular"
                                            //print("\(stringObjectVM.StringObjectNameDict[id])")
                                        }
                                    //}
                                }
//                        Picker(selection: $weight, label: Text("")) {
//                            Text("Regular").tag("Regular")
//                            Text("Semibold").tag("Semibold")
                        }

                    }
                    
                }
                
                HStack{
                    //stringObjectVM.selectedStringObject.color
                    Text("Color")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Rectangle()
                        .fill(Color.white)
                        .frame(width:10, height:10, alignment: .center)
                    
                    Text("\(String(format: "%.2f", stringObjectVM.selectedStringObjectList.LastValidItem().color.components![0] * 255)), \(String(format: "%.2f", stringObjectVM.selectedStringObjectList.LastValidItem().color.components![1] * 255)), \(String(format: "%.2f", stringObjectVM.selectedStringObjectList.LastValidItem().color.components![2] * 255))")
                    //                    Text("\(stringObjectVM.selectedStringObject.color.ToColor())")
                    //                        .foregroundColor(Color.gray)
                    //                        .frame(width:80, alignment: .topLeading)
                    //                    Text("\(stringObjectVM.selectedStringObject.CalcFontFullName())")
                    //                        .frame(width:200, alignment: .topLeading)
                }
                
                
                HStack{
                    Text("Bounds")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("X: \(Int(stringObjectVM.selectedStringObjectList.LastValidItem().stringRect.minX.rounded() )), Y: \(Int(stringObjectVM.selectedStringObjectList.LastValidItem().stringRect.minY.rounded())), W: \(Int(stringObjectVM.selectedStringObjectList.LastValidItem().stringRect.width.rounded() )), H: \(Int(stringObjectVM.selectedStringObjectList.LastValidItem().stringRect.height.rounded()))")
                        //Text("w: \(Int(stringObjectVM.selectedStringObject.stringRect.width.rounded())), h: \(Int(stringObjectVM.selectedStringObject.stringRect.height.rounded()))")
                        .frame(width:200, alignment: .topLeading)
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
                //let img = stringObjectVM.selectedStringObject.charImageList[index]
                imageProcess.SaveCIIToPNG(CIImage: stringObjectVM.selectedStringObjectList.LastValidItem().charImageList[index], filePath: panel.url!.path )
                let bw = SetGrayScale(stringObjectVM.selectedStringObjectList.LastValidItem().charImageList[index] )
                imageProcess.SaveCIIToPNG(CIImage: bw!, filePath: panel.url!.path + "_bw" )
                //let fixedRect = pixelMgr.FixBorder(image: DataStore.targetImageProcessed, rect: stringObjectVM.selectedStringObject.charRects[index])
                //let fixedImg = DataStore.targetImageProcessed.cropped(to: fixedRect)
                //imageProcess.SaveCIIToPNG(CIImage: fixedImg, filePath: panel.url!.path+"_fixed" )
                
            }
        }
    }
    
    func StringSaveBtnPressed(){
        let tergetImg = imageProcessViewModel.targetImageProcessed.cropped(to: stringObjectVM.selectedStringObjectList.LastValidItem().stringRect)
        let denoise = NoiseReduction(tergetImg)
        let tergetImgBW = SetGrayScale(denoise!)

        let panel = NSSavePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                imageProcess.SaveCIIToPNG(CIImage: tergetImg, filePath: panel.url!.path )
                imageProcess.SaveCIIToPNG(CIImage: tergetImgBW!, filePath: panel.url!.path + "_BW.bmp" )
                
            }
        }
    }
}

struct StringObjectPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        StringObjectPropertyView()
    }
}
