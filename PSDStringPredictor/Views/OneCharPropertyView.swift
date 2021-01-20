//
//  OneCharPropertyView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 20/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct OneCharPropertyView: View {
    @State var index: Int
    @State var myChar: String = ""
    @ObservedObject var psdsVM : PsdsVM
    var body: some View {
        if GetLastSelectObject().charColorModeList.count > index {
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
                TextField(
                    //String(GetLastSelectObject().charArray[index]),
                    "..",
                    text:$myChar,
                    //onEditingChanged:{_ in print("") },
                    onCommit: {SetChar(value: myChar)}
                )
                
                Text("\(Int(GetLastSelectObject().charRects[index].width.rounded()))/\(Int(GetLastSelectObject().charRects[index].height.rounded()))")
                Text(String(GetLastSelectObject().charFontWeightList[index]))
                
                FontSizeView(index: index)
                
                Button(action: {CharSaveBtnPressed(index)}){
                    Text("􀈄")
                }
                
            }
        }else{
            Text("")
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
    
    func SetChar(value: String){
        psdsVM.psdModel.SetChar(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, charIndex: index, value: value)
    }
    
    func GetLastSelectObject() -> StringObject{
        
        guard let id = psdsVM.selectedStrIDList.last else {return StringObject.init()}
        return psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: id) ?? StringObject.init()
    }
    
}

//struct OneCharPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        OneCharPropertyView()
//    }
//}
