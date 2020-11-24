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
    
    var body: some View {
        List{
            Section(header: Text("String Properties")){
                
                
                
                VStack(alignment: .leading){
                    Text("Content:")
                        .foregroundColor(Color.gray)
                    Text("\(stringObjectVM.selectedStringObject.content)")
                }
                
                //Spacer().frame(height: 10)
                
                VStack(alignment: .leading){
                    Text("Size:")
                        .foregroundColor(Color.gray)
                    Text("\(stringObjectVM.selectedStringObject.fontSize)")
                }
                
                //Spacer().frame(height: 10)
                
                VStack(alignment: .leading){
                    Text("Tracking:")
                        .foregroundColor(Color.gray)
                    Text("\(stringObjectVM.selectedStringObject.tracking)")
                }
                
                //Spacer().frame(height: 10)
                
                VStack(alignment: .leading){
                    Text("Weight:")
                        .foregroundColor(Color.gray)
                    Text("\(stringObjectVM.selectedStringObject.fontWeight.ToString())")
                }
                
                //Spacer().frame(height: 10)
                
                VStack(alignment: .leading){
                    Text("BoundingBox:")
                        .foregroundColor(Color.gray)
                    Text("x: \(Int(stringObjectVM.selectedStringObject.stringRect.minX.rounded())), y: \(Int(stringObjectVM.selectedStringObject.stringRect.minY.rounded()))")
                    Text("w: \(Int(stringObjectVM.selectedStringObject.stringRect.width.rounded())), h: \(Int(stringObjectVM.selectedStringObject.stringRect.height.rounded()))")
                }
                
                //Spacer().frame(height: 10)
                
                VStack(alignment: .leading){
                    Text("Components Images:")
                        .foregroundColor(Color.gray)
                    ScrollView ( .horizontal, showsIndicators: true) {
                        
                        HStack {
                            
                            ForEach(0..<stringObjectVM.selectedStringObject.charImageList.count, id: \.self){ index in
                                
                                VStack{
                                    Image(nsImage: stringObjectVM.selectedStringObject.charImageList[index].ToNSImage())
                                        .frame(height: 100)
                                    
                                    TextField(String(stringObjectVM.selectedStringObject.charArray[index]), text: $stringField)
                                    Text("\(Int(stringObjectVM.selectedStringObject.charRects[index].width.rounded()))/\(Int(stringObjectVM.selectedStringObject.charRects[index].height.rounded()))")
                                    Text(String(stringObjectVM.selectedStringObject.charFontWeightList[index].ToString()))
                                    
                                    FontSizeView(index: index)
                                    
                                    Button(action: {SaveBtnPressed(index)}){
                                        Text("􀈄")
                                        //                                .padding(.horizontal, 40.0)
                                        //                                .frame(minWidth: 200, maxWidth: .infinity)
                                        
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
    
    func SaveBtnPressed(_ index: Int){
        
        let panel = NSSavePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                //let img = stringObjectVM.selectedStringObject.charImageList[index]
                imageProcess.SaveCIIToPNG(CIImage: stringObjectVM.selectedStringObject.charImageList[index], filePath: panel.url!.path )
                let fixedRect = pixelMgr.FixBorder(image: DataStore.targetImageProcessed, rect: stringObjectVM.selectedStringObject.charRects[index])
                let fixedImg = DataStore.targetImageProcessed.cropped(to: fixedRect)
                imageProcess.SaveCIIToPNG(CIImage: fixedImg, filePath: panel.url!.path+"_fixed" )
                
            }
        }
    }
}

struct StringObjectPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        StringObjectPropertyView()
    }
}
