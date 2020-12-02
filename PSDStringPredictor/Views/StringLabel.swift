//
//  StringLabel.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct StringLabel: View {
    //    var id : UUID = UUID()
    //    var position: [CGFloat]
    //    var height: CGFloat
    //    var width: CGFloat
    //    var fontsize: CGFloat = 50//SetFontSize()
    //    var tracking: CGFloat
    //    var content: String
    //    var color: Color
    //var myState: Int // 1 is fixed, 2 is ignored, 0 is none
    var stringLabel: StringObject
    @State var fixed: Bool
    @State var ignored: Bool
    @State var fixedEnabled: Bool
    @State var ignoredEnabled: Bool
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    @State var width: CGFloat = 0
    
    //@State private var newOffset: CGSize = .zero
    
    
    func CalcTrackingAfterOffset() -> CGFloat {
       // var offset : CGSize = .zero
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[stringLabel] != nil{
            d = stringObjectVM.DragOffsetDict[stringLabel]!.width / 10
        }
        return stringLabel.tracking + d
    }
    
    func CalcSizeAfterOffset() -> CGFloat {
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[stringLabel] != nil{
            d = stringObjectVM.DragOffsetDict[stringLabel]!.height / 20
        }
        return stringLabel.fontSize - d
    }
    
    func makeView(_ geometry: GeometryProxy) -> some View {
        //print(geometry.size.width, geometry.size.height)
        DispatchQueue.main.async { self.width = geometry.size.width }
        
        return Text("Test")
            .frame(width: geometry.size.width)
    }
    
    func InfoBtnTapped(){
        stringObjectVM.UpdateSelectedStringObject(selectedStringObject: self.stringLabel)
    }
    
    func FixedBtnTapped(){
        fixed = !fixed
        stringObjectVM.stringObjectFixedDict[stringLabel] = fixed
        //        if ignored == true {
        //            ignored = false
        //        }
        ignoredEnabled = !fixed
        //print("Fixed List: \(stringObjectVM.stringObjectFixedDict)")
    }
    
    func IgnoreBtnTapped(){
        ignored = !ignored
        stringObjectVM.stringObjectIgnoreDict[stringLabel] = ignored
        //        if fixed == true {
        //            fixed = false
        //        }
        fixedEnabled = !ignored
    }
    
    
    
    var body: some View {
        
        ZStack {
            
            if stringLabel.colorMode == 1{
                Rectangle()
                    .fill( Color.white.opacity(0.3))
                    .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                    .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
            }else if stringLabel.colorMode == 2 {
                Rectangle()
                    .fill( Color.black.opacity(0.3))
                    .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                    .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
            }
            
            Rectangle()
                .stroke(stringObjectVM.selectedStringObject.id == stringLabel.id ? Color.green.opacity(0.6) : Color.red, lineWidth: stringObjectVM.selectedStringObject.id == stringLabel.id ? 3 : 1)
                .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
            
            Text(stringLabel.content)
                .foregroundColor(stringLabel.color.ToColor())
                .font(.custom(stringLabel.CalcFontFullName(), size: CalcSizeAfterOffset()))
                .tracking(CalcTrackingAfterOffset())
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y  - stringLabel.stringRect.height/2  )
            //.shadow(color: .white, radius: 10, x: 5, y: 5)
            
            //Drag layer
            Rectangle()
                .fill( Color.yellow.opacity(0.3))
                .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
                .gesture(DragGesture()
                            .onChanged { gesture in
                                stringObjectVM.DragOffsetDict[stringLabel] = gesture.translation
                                //self.newOffset = gesture.translation
                                //print(self.newOffset)
                            }
                )
            
            HStack{
                //Button for show detail
                Button(action: {self.InfoBtnTapped()}){
                    CustomImage( name: "detail-round")
                        //.frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(-4)
                
                //Button for fix
                Button(action: {self.FixedBtnTapped()}){
                    CustomImage( name: fixed ? "tick-active" : "tick-round")
                        //.frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(-4)
                .IsHidden(condition: fixedEnabled)
                //.position(x: stringLabel.stringRect.maxX, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.maxY   )
                
                //Button for delete
                Button(action: {self.IgnoreBtnTapped()}){
                    CustomImage( name: ignored ? "forbidden-active" : "forbidden-round")
                        //.frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(-4)
                .IsHidden(condition: ignoredEnabled)
                //.position(x: stringLabel.stringRect.maxX, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.maxY   )
            }
            .frame(width: 30, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .trailing)
            .position(x: stringLabel.stringRect.maxX, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.maxY - 5 )
        }
    }
}

struct StringLabel_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}){
            //            Text("􀍢")
            //
            //                //.background(Color.black)
            //                .foregroundColor(Color.white)
            //                //.border(Color.black, width: 1)
            //                //.shadow(radius: 0.1)
            //                .cornerRadius(10)
        }
        .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .shadow(radius: 10)
    }
}
