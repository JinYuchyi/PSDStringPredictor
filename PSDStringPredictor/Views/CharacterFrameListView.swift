//
//  CharacterFrameListView.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 17/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct CharacterFrameListView: View {
    //@EnvironmentObject var data: DataStore
    var frameList : [CharFrame]
    //var charlist: [CharacterFrameView]
    var body: some View {
        ForEach(frameList, id: \.id){ item in
            CharacterFrameView(charFrame: item)
            .position(x: item.rect.midX, y: item.rect.midY)
        }

    }
    

}


struct CharacterFrameListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterFrameListView( frameList: [
            CharFrame(id: 0, rect: CGRect(x: 50,y: 50,width: 50,height: 50), char: "A"),
            CharFrame(id: 1, rect: CGRect(x: 300,y: 150,width: 50,height: 50), char: "c")
        ])
    }
}
