//
//  TestView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 28/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        ZStack
        {
        Rectangle()
        .stroke(Color.red, lineWidth: 2)
        .frame(width: 100, height: 50)
            
            Text("Hello, Wo11")
                .multilineTextAlignment(.leading)
                .padding(.all, 0.0)
                .coordinateSpace(name: /*@START_MENU_TOKEN@*/ /*@PLACEHOLDER=Coordinate Space Name@*/CoordinateSpace.local/*@END_MENU_TOKEN@*/)
                
            //.frame(width: 100, alignment: .leading)
            
        }
        .position(x: 100, y: 50)

    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
