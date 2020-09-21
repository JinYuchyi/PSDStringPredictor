//
//  ContentView.swift
//  UITest
//
//  Created by ipdesign on 3/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ContentView: View {

//    @ObservedObject var stringObjectList = StringObjectList()
//    @ObservedObject var imageProcess: ImageProcess = ImageProcess()
//    @ObservedObject  var db = DBVideoModel()
//    @State private var ocr =  OCR()
//
//    @EnvironmentObject var data: DataStore
    let data = DataStore()
    @ObservedObject var stringObjectViewModel = StringObjectViewModel()
    //@ObservedObject var charFrameVM = charframe()
    //let stringObjectViewModel = StringObjectViewModel()

    
    var body: some View {
        
        
        HStack(alignment: .top){
//            Button(action: {
//                self.loglist.CleanMsg()
//            }) {
//                Text("Test")
//            }
            //StringObjectListView(stringObject: StringObjectsData)
            VStack{
                Text(String(self.stringObjectViewModel.countNum))
                ControlPanel(stringObjectViewModel: stringObjectViewModel)
                    .padding(.top, 20.0)
                    .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                ImageProcessView()
                    .padding(.top, 20.0)
                .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)

                StringObjectListView( )
                    .padding(.top, 20.0)
                .border(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.1), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)

//                LogListView(logList: loglist)
//                    .frame(width:400, height: 300.0)
            }
     
            //.frame(width: 400.0)
            
            ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                ZStack{
                    ImageView()
                    //CharacterFrameListView(frameList: charFrameList)
                    
                    LabelsOnImage( stringObjectViewModel:stringObjectViewModel)
                }
            }
         
            .frame(width: 1100)
        }


    }
}


//struct ContentView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ContentView()
//            .frame(width: 1500, height: 1000 )
//    }
//}


struct People: Identifiable {
    var id = UUID()
    var name: String
    var number: String
}

struct PeopleRow: View {
    @State var isChecked: Bool = true
    
    var people: People
    
    var body: some View{
        //Text("The street name is \(people.name)")
        HStack{
            
            Button(action: {self.isChecked.toggle()}) {
                if self.isChecked {
                    Image("star-empty")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                } else {
                    Image("star-filled")
                        .resizable()
                        .frame(width: 12, height: 12)
                }

            }
            .padding(.leading, 10)
            

            VStack(alignment: .leading){
                Text(people.name)
                Text(people.number)
            }
            
        }
    }
}

struct ListData: View {
    
    var body: some View{
        let people1 = People(name: "Adam", number: "555-666")
        let people2 = People(name: "Carry", number: "555-666")
        let peoples = [people1, people2]

        return List(peoples){
            item in PeopleRow(people: item)
        }
    }
}







