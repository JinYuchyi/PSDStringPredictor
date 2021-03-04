//
//  PsdOperatorView.swift
//  PSDStringGenerator
//
//  Created by ipdesign on 18/1/2021.
//  Copyright © 2021 ipdesign. All rights reserved.
//

import SwiftUI

struct PsdOperatorView: View {
    
    @ObservedObject var psdsVM : PsdsVM
    
    var body: some View {
        GeometryReader{geo in
            HStack(alignment:.center){
                Button(action: {psdsVM.CommitAll()}, label: {
                    Text("Commit All")
                        .frame(width: 80)
                })
 
                Button(action: {psdsVM.LoadImage()}, label: {
                    Text("Add")
                        .frame(width: 40)
                })
                Button(action: {psdsVM.removePsd(psdId: psdsVM.selectedPsdId)}, label: {
                    Text("Delete")
                        .frame(width: 40)
                })
                Button(action: {psdsVM.DeleteAll()}, label: {
                    Text("Del All")
                        .frame(width: 40)
                })
            }
            .frame(width:geo.size.width, height: geo.size.height, alignment: .bottom)
            //.padding()
        }
        
    }
    
}

//struct PsdOperatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        PsdOperatorView()
//    }
//}
