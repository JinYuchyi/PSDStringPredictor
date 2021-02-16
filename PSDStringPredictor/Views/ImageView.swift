//
//  ImageView.swift
//  UITest
//
//  Created by ipdesign on 4/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI


struct ImageView: View {
    //var imageProcess: ImageProcess
    //@EnvironmentObject var data: DataStore
    //    let imgUtil = ImageUtil()
    //    let control = Controller()
    //let imgProcess = ImageProcess()
    //@ObservedObject var imageViewModel: ImageProcess = imageProcessViewModel
    //@ObservedObject var imageVM: ImageVM
    //    @Binding var showImage: Bool
    @ObservedObject var psds: PsdsVM
    @ObservedObject var regionVM: RegionProcessVM
    @ObservedObject var interactive: InteractiveViewModel
    
    var body: some View{
        
        //else{
        ZStack{
            Image(nsImage: psds.processedCIImage.ToNSImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
            SelectionOverlayView( interactive: interactive, psdsVM: psds)
            RegionProcessOverlayView(interactive: interactive, psdsVM: psds, regionProcessVM: regionVM)
                .IsHidden(condition: regionVM.regionActive)
        }
        
    }
    
}

//struct GetShowContent: View{
//    var body: some View{
//
//    }
//}


//
//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView(imageProcess: <#ImageProcess#>)
//            .previewLayout(PreviewLayout.fixed(width: 1000, height: 1000))
//    }
//}
