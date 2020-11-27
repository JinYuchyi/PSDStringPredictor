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
    
    @ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    //    @Binding var showPredictString: Bool
    //    @Binding var showDebugOverlay: Bool
    @State var width: CGFloat = 0
    //@State var detailed: Bool = false
    @State var fixed: Bool = false
    @State var ignored: Bool = false
    @State var fixedDisabled: Bool = false
    @State var ignoredDisabled: Bool = false
    
    var stringLabel: StringObject
    
    func makeView(_ geometry: GeometryProxy) -> some View {
        print(geometry.size.width, geometry.size.height)
        DispatchQueue.main.async { self.width = geometry.size.width }
        
        return Text("Test")
            .frame(width: geometry.size.width)
    }
    
    func InfoBtnTapped(){
        stringObjectVM.UpdateSelectedStringObject(selectedStringObject: self.stringLabel)
        //print(stringLabel.color)
        //stringLabel.PredictTracking()
    }
    
    func FixedBtnTapped(){
        fixed = !fixed
        stringObjectVM.stringObjectFixedDict[stringLabel] = fixed
        ignoredDisabled = fixed
        //print("Fixed List: \(stringObjectVM.stringObjectFixedDict)")
    }
    
    func IgnoreBtnTapped(){
        ignored = !ignored
        stringObjectVM.stringObjectIgnoreDict[stringLabel] = ignored
        fixedDisabled = ignored
//        if ignored == true {
//            if fixed == true{
//                fixed = false
//                stringObjectVM.stringObjectFixedDict[stringLabel.id] = false
//            }
//        }
        //Remove
//        let index = stringObjectVM.stringObjectListData.firstIndex(where: {$0.id == stringLabel.id} )
//        if index != nil {
//            //In case it is the selected object, we have to make the selected object empty first.
//            if stringObjectVM.selectedStringObject.id == stringLabel.id{
//                stringObjectVM.selectedStringObject = StringObject.init()
//            }
//            stringObjectVM.stringObjectListData.remove(at: index!)
//        }
        //print("Ignore List: \(stringObjectVM.stringObjectIgnoreDict)")
        
    }
    
    var body: some View {
        
        ZStack {
//            Rectangle()
//                .fill(Color.red.opacity(1))
//                .frame(width: 4, height: 4)
//                .position(x: stringLabel.stringRect.origin.x , y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y )
           
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
            
            Rectangle()
                .stroke(stringObjectVM.selectedStringObject.id == stringLabel.id ? Color.green : Color.red, lineWidth: stringObjectVM.selectedStringObject.id == stringLabel.id ? 4 : 1)
                .frame(width: stringLabel.stringRect.width, height: stringLabel.stringRect.height)
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y - stringLabel.stringRect.height/2  )
            
            Text(stringLabel.content)

                .foregroundColor(Color(red: Double(stringLabel.color.components![0] * 255.0), green: Double(stringLabel.color.components![1] * 255.0), blue: Double(stringLabel.color.components![2] * 255.0)))
                .font(.custom(stringLabel.CalcFontFullName(), size: stringLabel.fontSize))
                .tracking(stringLabel.tracking)
                //.font(.system(size: stringLabel.fontSize, weight: stringLabel.fontWeight))
                .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y  - stringLabel.stringRect.height/2  )
      
//            if stringLabel.fontSize < 20 {
//                Text(stringLabel.content)
//                    //.foregroundColor(stringLabel.color)
//                    //.font(.custom("SF Pro Text", size: stringLabel.fontSize))
//                    //.tracking(stringLabel.tracking)
//                    .font(.system(size: stringLabel.fontSize, weight: stringLabel.fontWeight))
//                    .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y  - stringLabel.stringRect.height/2  )
//            }
//            else{
//                Text(stringLabel.content)
//                    //.foregroundColor(stringLabel.color)
//
//                    //"SF Pro Display"
//
//                    .font(.custom(stringLabel.CalcFontFullName(), size: stringLabel.fontSize))
//                    .tracking(stringLabel.tracking)
//                    //.font(.system(size: stringLabel.fontSize, weight: stringLabel.fontWeight))
//                    .position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.origin.y  - stringLabel.stringRect.height/2  )
//            }
            
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

                //Button for lock
                Button(action: {self.FixedBtnTapped()}){
                    CustomImage( name: fixed ? "tick-active" : "tick-round")
                        //.frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .scaledToFit()
                }
                .buttonStyle(RoundButtonStyle())
                .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(-4)
                .IsHidden(condition: !fixedDisabled)
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
                .IsHidden(condition: !ignoredDisabled)
                //.position(x: stringLabel.stringRect.maxX, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.maxY   )
            }
            .frame(width: 30, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .trailing)
            .position(x: stringLabel.stringRect.maxX, y: imageViewModel.GetTargetImageSize()[1] - stringLabel.stringRect.maxY - 5 )
        }
        
        //.position(x: stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2, y: imageViewModel.GetTargetImageSize()[1] -  stringLabel.position[1] - stringLabel.height/2)
        
        //        func CGPositionToSwiftPosition(From pos: [Int]) -> [Int] {
        //            let newX = stringLabel.stringRect.origin.x + stringLabel.stringRect.width/2
        //            let newY = imageViewModel.GetTargetImageSize()[1] -  stringLabel.position[1] - stringLabel.height/2
        //            return  [newX, newY]
        //        }
        
        
    }
}
//
//func SetPosition() -> [CGFloat] {
//    //let x = Int.random(in: 0..<100)
//    //let y = Int.random(in: 0..<100)
//    return [200, 200]
//}
//
//func SetHeight() -> CGFloat {
//    return 20
//}
//
//func SetWidth() -> CGFloat {
//    return 20
//}
//
//func SetFontSize() -> CGFloat {
//    return 50
//}
//
//func SetTracking() -> CGFloat {
//    return 20
//}
//
//func SetContent() -> String{
//    return "Default " +  SetPosition()[0].description  + ", " +  SetPosition()[1].description
//}


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
