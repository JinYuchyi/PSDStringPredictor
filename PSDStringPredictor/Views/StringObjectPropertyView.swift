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
    @State var fontSize: String = ""
    
    let pixelMgr = PixelProcess()
    
    @ObservedObject var psdsVM: PsdsVM
    //@State var charList: [String]
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
    
    func fontSizeCommit(){
        let newVal = CGFloat((fontSize as NSString).floatValue) + (psdsVM.DragOffsetDict[psdsVM.selectedStrIDList.last!]?.height ?? 0)
        psdsVM.psdModel.SetFontSize(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, value: newVal, offset: false)
    }
    
//    func SetChar(index: Int, value: String){
//        print("Changed to \(value)")
//    }
    
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
    
    var floatingTextField: some View {
        GeometryReader{ geo in
            HStack{
                TextField("", text: $fontSize)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.black)


                //
            }.frame(width:geo.size.width * 0.9)
        }
        

           // .background(Color.black.opacity(0.1))
    }
    
    var body: some View {
        List{
            Section(header: Text("String Properties")){
                HStack{
                    Text("Content")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(GetLastSelectObject().content)")
                        .frame(width:200, alignment: .topLeading)
                }
                
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
                        

                        .onTapGesture {
                            //self.overlay(floatingTextField)
                        }
//                    TextField("\(CalcOffsetSize(targetObj: GetLastSelectObject()))", text: $fontSize, onCommit: {fontSizeCommit()})
//                        .frame(width:200, alignment: .topLeading)
                        
                }

                HStack{
                    Text("Tracking")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Text("\(CalcOffsetTracking(targetObj: GetLastSelectObject()))")
                        .frame(width:200, alignment: .topLeading)
                }

                HStack{
                    Text("Font")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    
                    VStack{
                        if GetLastSelectObject().fontSize != 0 {
                            Text("\(GetLastSelectObject().FontName)" )
                                .frame(width:200, alignment: .topLeading)
                                .onTapGesture {
                                    psdsVM.ToggleFontName(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)
                                }
                        }
                    }
                    
                }
                
                HStack{
                    Text("Color")
                        .foregroundColor(Color.gray)
                        .frame(width:80, alignment: .topLeading)
                    Image(nsImage: GetLastSelectObject().colorPixel.ToNSImage())
                        .scaleEffect(10)

                    if psdsVM.selectedStrIDList.count > 0{
                        Text("\(Int((GetLastSelectObject().color.components![0] * 255).rounded())), \(Int((GetLastSelectObject().color.components![1] * 255).rounded())), \(Int((GetLastSelectObject().color.components![2] * 255).rounded()))")
                    }

                }.onTapGesture {
                    if psdsVM.selectedStrIDList.count > 0 {
                        psdsVM.ToggleColorMode(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!)
                    }
                }
                
                
//                HStack{
//                    Text("Bounds")
//                        .foregroundColor(Color.gray)
//                        .frame(width:80, alignment: .topLeading)
//                    Text("X: \(Int(GetLastSelectObject().stringRect.minX.rounded() )), Y: \(Int(GetLastSelectObject().stringRect.minY.rounded())), W: \(Int(GetLastSelectObject().stringRect.width.rounded() )), H: \(Int(GetLastSelectObject().stringRect.height.rounded()))")
//                        .frame(width:200, alignment: .topLeading)
//                }
                
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
