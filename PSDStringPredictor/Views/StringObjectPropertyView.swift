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
    @State var stringField: String = ""
    @State var weight: String = "Regular"
    let pixelMgr = PixelProcess()
    
    @ObservedObject var psdsVM: PsdsVM
    
    func GetLastSelectObject() -> StringObject{
        
        guard let id = psdsVM.selectedStrIDList.last else {return StringObject.init()}
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id) ?? StringObject.init()
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
    

    
    fileprivate func StringComponents() -> some View {
        VStack(alignment: .leading){
//            Text("Components")
//                .foregroundColor(Color.gray)
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
    
    var body: some View {
        List{
            Section(header: Text("String Properties")){
                //Text("id:\(stringObjectVM.selectedIDList.last ?? UUID.init())")
                HStack{
                    Text("Content")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(GetLastSelectObject().content)")
                        .frame(width:200, alignment: .topLeading)
                }
                
//                if GetLastSelectObject().content != "No content." {
//                    HStack{
//                        let targetImg = imageProcess.targetNSImage.ToCIImage()!.cropped(to: GetLastSelectObject().stringRect).ToNSImage()
//                        Image(nsImage: targetImg )
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 200)
//                        Spacer()
//                        Button(action: {StringSaveBtnPressed()}){
//                            Text("􀈄")
//                        }
//                    }
//                }
                
                HStack{
                    Text("Color Mode")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    if GetLastSelectObject().colorMode == MacColorMode.light {
                        Text("􀆮")
                            .frame(width:200, alignment: .topLeading)
                    }else if GetLastSelectObject().colorMode == MacColorMode.dark {
                        Text("􀆺")
                            .frame(width:200, alignment: .topLeading)
                        
                    }else{}
                    
                }

                
                HStack{
                    Text("Size")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(CalcOffsetSize(targetObj: GetLastSelectObject()))")
                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Tracking")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(CalcOffsetTracking(targetObj: GetLastSelectObject()))")
                        .frame(width:200, alignment: .topLeading)
                }
                
                //Spacer().frame(height: 10)
                
                HStack{
                    Text("Font")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    
                    VStack{
                        if GetLastSelectObject().fontSize != 0 {
                            Text("\(GetLastSelectObject().FontName)" )
                                .frame(width:200, alignment: .topLeading)
                                .onTapGesture {
                                    psdsVM.ToggleColorMode(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)
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
                        .fill(Color.init(red: Double(GetLastSelectObject().color.components![0]), green: Double(GetLastSelectObject().color.components![1]), blue: Double(GetLastSelectObject().color.components![2])))
                        .frame(width:10, height:10, alignment: .center)
                    
                    Text("\(String(format: "%.2f", GetLastSelectObject().color.components![0] * 255)), \(String(format: "%.2f", GetLastSelectObject().color.components![1] * 255)), \(String(format: "%.2f", GetLastSelectObject().color.components![2] * 255))")
                    //                    Text("\(stringObjectVM.selectedStringObject.color.ToColor())")
                    //                        .foregroundColor(Color.gray)
                    //                        .frame(width:80, alignment: .topLeading)
                    //                    Text("\(stringObjectVM.selectedStringObject.CalcFontFullName())")
                    //                        .frame(width:200, alignment: .topLeading)
                }.onTapGesture {
                    psdsVM.ToggleColorMode(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)
                }
                
                
                HStack{
                    Text("Bounds")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("X: \(Int(GetLastSelectObject().stringRect.minX.rounded() )), Y: \(Int(GetLastSelectObject().stringRect.minY.rounded())), W: \(Int(GetLastSelectObject().stringRect.width.rounded() )), H: \(Int(GetLastSelectObject().stringRect.height.rounded()))")
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
                GetLastSelectObject().charImageList[index].ToPNG(url: panel.url!)
                //imageProcess.SaveCIIToPNG(CIImage: GetLastSelectObject().charImageList[index], filePath: panel.url!.path )
                let bw = SetGrayScale(GetLastSelectObject().charImageList[index] )
                let newUrl = URL.init(fileURLWithPath: panel.url!.path + "_bw.bmp")
                bw!.ToPNG(url: newUrl)
                //imageProcess.SaveCIIToPNG(CIImage: bw!, filePath: panel.url!.path + "_bw" )
                //let fixedRect = pixelMgr.FixBorder(image: DataStore.targetImageProcessed, rect: stringObjectVM.selectedStringObject.charRects[index])
                //let fixedImg = DataStore.targetImageProcessed.cropped(to: fixedRect)
                //imageProcess.SaveCIIToPNG(CIImage: fixedImg, filePath: panel.url!.path+"_fixed" )
                
            }
        }
    }
    
    func StringSaveBtnPressed(){
//        let tergetImg = imageProcessViewModel.targetImageProcessed.cropped(to: GetLastSelectObject().stringRect)
//        let denoise = NoiseReduction(tergetImg)
//        let tergetImgBW = SetGrayScale(denoise!)
//
//        let panel = NSSavePanel()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            let result = panel.runModal()
//            if result == .OK{
//                imageProcess.SaveCIIToPNG(CIImage: tergetImg, filePath: panel.url!.path )
//                imageProcess.SaveCIIToPNG(CIImage: tergetImgBW!, filePath: panel.url!.path + "_BW.bmp" )
//
//            }
//        }
    }
}

//struct StringObjectPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        StringObjectPropertyView()
//    }
//}
