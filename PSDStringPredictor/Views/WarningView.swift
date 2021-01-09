//
//  WarningView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 9/12/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct WarningView: View {
    @ObservedObject var stringObjectVM = psdViewModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black).opacity(0.9)
            
            VStack{
                Text("Warning")
                    .font(.title)
                    .foregroundColor(.red)
                    .bold()
                    .shadow(color: Color.black.opacity(0.5), radius: 1, y: 2 )
                
                    .padding()
                
                Text(stringObjectVM.warningContent)
                    .bold()
                    .shadow(color: Color.black.opacity(0.5), radius: 1, y: 2 )
                Button(action: {stringObjectVM.warningContent = ""}) {
                    Text("OK")
                }
                .padding()
            }
            //.frame(width: 550, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        }
        .frame(width: 550, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .opacity(stringObjectVM.warningContent == "" ? 0 : 1)

    }
}

struct WarningView_Previews: PreviewProvider {
    static var previews: some View {
        WarningView()
    }
}
