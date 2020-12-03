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
    var charFrameList: [CharFrame]
    @State var fixed: Bool
    @State var ignored: Bool
    @State var fixedEnabled: Bool
    @State var ignoredEnabled: Bool
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    @State var width: CGFloat = 0
    
    func CalcTrackingAfterOffset() -> CGFloat {
        // var offset : CGSize = .zero
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[stringLabel] != nil{
            d = stringObjectVM.DragOffsetDict[stringLabel]!.width
        }
        return stringLabel.tracking + d
    }
    
    func CalcSizeAfterOffset() -> CGFloat {
        var d : CGFloat = 0
        if stringObjectVM.DragOffsetDict[stringLabel] != nil{
            d = stringObjectVM.DragOffsetDict[stringLabel]!.height
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
            
            Group{
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
                
                //Drag layer
                Rectangle()
                    .fill( Color.yellow.opacity(0.1))
                    .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                    .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
                    .gesture(DragGesture()
                                .onChanged { gesture in
                                    if abs(gesture.translation.width / gesture.translation.height) > 1 {
                                        stringObjectVM.DragOffsetDict[stringLabel] = CGSize(width: gesture.translation.width / 10, height: 0)
                                    } else {
                                        stringObjectVM.DragOffsetDict[stringLabel] = CGSize(width: 0, height: gesture.translation.height / 10)
                                    }
                                    
                                }
                    )
                
                //Rect for each character
                ForEach (stringLabel.charRects, id:\.self){ item in
                    CharacterFrameView(charFrame: item)
                        .position(x: item.midX, y: self.imageViewModel.GetTargetImageSize()[1] - item.midY)
                }
                
            }.IsHidden(condition: fixedEnabled && ignoredEnabled)
            
            HStack{
                //Button for show detail
                Button(action: {self.InfoBtnTapped()}){
                    CustomImage( name: "detail-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(-4)
                
                //Button for fix
                Button(action: {self.FixedBtnTapped()}){
                    CustomImage( name: fixed ? "tick-active" : "tick-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(-4)
                .IsHidden(condition: fixedEnabled)
                
                //Button for delete
                Button(action: {self.IgnoreBtnTapped()}){
                    CustomImage( name: ignored ? "forbidden-active" : "forbidden-round")
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(-4)
                .IsHidden(condition: ignoredEnabled)
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
