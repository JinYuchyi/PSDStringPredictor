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
    @ObservedObject var imageProcess = ImageProcess()
    @State var stringField: String = ""
    let pixelMgr = PixelProcess()
    
    fileprivate func FontSizeView(index: Int) -> some View {
        if stringObjectVM.selectedStringObject.isPredictedList[index] == 1 {
            return Text(String(stringObjectVM.selectedStringObject.charSizeList[index].description)+"􀫥").fixedSize()
        }else{
            return Text(String(stringObjectVM.selectedStringObject.charSizeList[index].description)).fixedSize()
        }
        
    }
    
    
    
    func CalcOffsetTracking() -> CGFloat{
        var offset: CGFloat = 0
        if stringObjectVM.DragOffsetDict[stringObjectVM.selectedStringObject] != nil{
            offset = stringObjectVM.DragOffsetDict[stringObjectVM.selectedStringObject]!.width
        }
        return stringObjectVM.selectedStringObject.tracking + offset
    }
    
    func CalcOffsetSize() -> CGFloat{
        var offset: CGFloat = 0
        if stringObjectVM.DragOffsetDict[stringObjectVM.selectedStringObject] != nil{
            offset = stringObjectVM.DragOffsetDict[stringObjectVM.selectedStringObject]!.height
        }
        return stringObjectVM.selectedStringObject.fontSize - offset
    }
    
    var body: some View {
        List{
            Section(header: Text("String Properties")){

                HStack{
                    Text("Content")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(stringObjectVM.selectedStringObject.content)")
                        .frame(width:200, alignment: .topLeading)
                }
                
                if stringObjectVM.selectedStringObject.content != "No content." {
                    HStack{
                        let targetImg = DataStore.targetImageProcessed.cropped(to: stringObjectVM.selectedStringObject.stringRect).ToNSImage()
                        Image(nsImage: targetImg ?? NSImage.init())
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
                    if stringObjectVM.selectedStringObject.colorMode == 1 {
                        Text("􀆮")
                            .frame(width:200, alignment: .topLeading)
                    }else if stringObjectVM.selectedStringObject.colorMode == 2 {
                        Text("􀆺")
                            .frame(width:200, alignment: .topLeading)
                    }else{}
                    
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Size")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(CalcOffsetSize())")
                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Tracking")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(CalcOffsetTracking())")
                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Font")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    VStack{
                        Text("\(stringObjectVM.selectedStringObject.CalcFontFullName())")
                            .frame(width:200, alignment: .topLeading)
                        Picker(selection: $stringObjectVM.selectedStringObject.fontWeight, label: Text("Weight")) {
                            Text("Regular")
                            Text("Semibold")
                        }
                    }
                    
                }
                
                HStack{
                    //stringObjectVM.selectedStringObject.color
                    Text("Color")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Rectangle()
                        .fill(stringObjectVM.selectedStringObject.color.ToColor())
                        .frame(width:10, height:10, alignment: .center)
                    //                    Text("\(stringObjectVM.selectedStringObject.color.ToColor())")
                    //                        .foregroundColor(Color.gray)
                    //                        .frame(width:80, alignment: .topLeading)
                    //                    Text("\(stringObjectVM.selectedStringObject.CalcFontFullName())")
                    //                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Bounds")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("X: \(Int(stringObjectVM.selectedStringObject.stringRect.minX.rounded())), Y: \(Int(stringObjectVM.selectedStringObject.stringRect.minY.rounded())), W: \(Int(stringObjectVM.selectedStringObject.stringRect.width.rounded())), H: \(Int(stringObjectVM.selectedStringObject.stringRect.height.rounded()))")
                        //Text("w: \(Int(stringObjectVM.selectedStringObject.stringRect.width.rounded())), h: \(Int(stringObjectVM.selectedStringObject.stringRect.height.rounded()))")
                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                //Spacer()
                
                VStack(alignment: .leading){
                    Text("Components")
                        .foregroundColor(Color.gray)
                    ScrollView ( .horizontal, showsIndicators: true) {
                        
                        HStack {
                            
                            ForEach(0..<stringObjectVM.selectedStringObject.charImageList.count, id: \.self){ index in
                                
                                VStack{
                                    if stringObjectVM.selectedStringObject.charColorModeList[index] == 1{

                                    Image(nsImage: stringObjectVM.selectedStringObject.charImageList[index].ToNSImage())
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                        .border(Color.yellow, width: 1)
                                    }else if  stringObjectVM.selectedStringObject.charColorModeList[index] == 2{
                                        Image(nsImage: stringObjectVM.selectedStringObject.charImageList[index].ToNSImage())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 40)
                                            .border(Color.blue, width: 1)
                                    }
                                        
                                    //.padding(.vertical, -20)
                                    
                                    TextField(String(stringObjectVM.selectedStringObject.charArray[index]), text: $stringField)
                                    
                                    Text("\(Int(stringObjectVM.selectedStringObject.charRects[index].width.rounded()))/\(Int(stringObjectVM.selectedStringObject.charRects[index].height.rounded()))")
                                    Text(String(stringObjectVM.selectedStringObject.charFontWeightList[index].ToString()))
                                    
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
        }
    }
    
    func CharSaveBtnPressed(_ index: Int){
        
        let panel = NSSavePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                //let img = stringObjectVM.selectedStringObject.charImageList[index]
                imageProcess.SaveCIIToPNG(CIImage: stringObjectVM.selectedStringObject.charImageList[index], filePath: panel.url!.path )
                let bw = SetGrayScale(stringObjectVM.selectedStringObject.charImageList[index])
                imageProcess.SaveCIIToPNG(CIImage: bw!, filePath: panel.url!.path + "_bw" )
                //let fixedRect = pixelMgr.FixBorder(image: DataStore.targetImageProcessed, rect: stringObjectVM.selectedStringObject.charRects[index])
                //let fixedImg = DataStore.targetImageProcessed.cropped(to: fixedRect)
                //imageProcess.SaveCIIToPNG(CIImage: fixedImg, filePath: panel.url!.path+"_fixed" )
                
            }
        }
    }
    
    func StringSaveBtnPressed(){
        let tergetImg = DataStore.targetImageProcessed.cropped(to: stringObjectVM.selectedStringObject.stringRect)
        let denoise = NoiseReduction(tergetImg)
        let tergetImgBW = SetGrayScale(denoise!)

        let panel = NSSavePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                imageProcess.SaveCIIToPNG(CIImage: tergetImg, filePath: panel.url!.path )
                imageProcess.SaveCIIToPNG(CIImage: tergetImgBW!, filePath: panel.url!.path + "_BW" )
                
            }
        }
    }
}

struct StringObjectPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        StringObjectPropertyView()
    }
}
