//
//  Log.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct Log: View {
    var body: some View {
        Text("hello")
        .debugPrint("This is the log text.")

    }
}

struct Log_Previews: PreviewProvider {
    static var previews: some View {
        Log()
    }
}

extension View {
    func debugPrint(_ value:Any) -> some View {
        #if DEBUG
        print(value)
        #endif
        return self
    }
}
