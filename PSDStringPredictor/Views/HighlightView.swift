////
////  HighlightView.swift
////  PSDStringGenerator
////
////  Created by ipdesign on 13/12/2020.
////  Copyright © 2020 ipdesign. All rights reserved.
////
//
import SwiftUI

struct HighlightView: View {
    //    @ObservedObject var imageVM = imageProcessViewModel
    //    @ObservedObject var stringObjectVM = psdViewModel
    //    @ObservedObject var pSDViewModel = PSDViewModel()
    
    @ObservedObject var psdsVM: PsdsVM
    
    //var selectId: [UUID]
    //imageProcessViewModel.targetNSImage.size.height - obj.stringRect.origin.y
    //let ids: [UUID]
    var body: some View {
        ForEach(psdsVM.selectedStrIDList, id:\.self){ theid in
            //if (psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid) != nil) {
            ZStack{
                Rectangle()
                    .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.width, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.height)
                    .position(x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.midX, y: psdsVM.selectedNSImage.size.height - psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.midY)
                    .foregroundColor(Color.green.opacity(0.3))
                    .shadow(color: .green, radius: 5, x: 0, y: 0)
                    .gesture(DragGesture()
                                .onChanged { gesture in
                                    if abs(gesture.translation.width / gesture.translation.height) > 1 {
                                        psdsVM.DragOffsetDict[theid] = CGSize(width: gesture.translation.width / 10, height: 0)
                                    } else {
                                        psdsVM.DragOffsetDict[theid] = CGSize(width: 0, height: gesture.translation.height / 10)
                                    }
                                }
                             
                    )
                
                
                
                Rectangle()
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.width, height: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.height)
                    .position(x: psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.midX, y: psdsVM.selectedNSImage.size.height - psdsVM.GetStringObjectForOnePsd(psdId: psdsVM.selectedPsdId, objId: theid)!.stringRect.midY)
                    .blendMode(.lighten)
                //}
                //            }else{
                //                Text("")
                //            }
            }
            
            
            
        }
        
        //    func GetStringObject(_ id: UUID) -> StringObject?{
        //        return stringObjectVM.FindStringObjectByIDOnePSD(psdId: stringObjectVM.selectedPSDID, objId: id)
        //    }
    }
//
////struct HighlightView_Previews: PreviewProvider {
////    static var previews: some View {
////        HighlightView(rect: CGRect.init(x: 10, y: 10, width: 50, height: 20))
////    }
////}
}
