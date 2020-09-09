//
//  ContentView.swift
//  UITest
//
//  Created by ipdesign on 3/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //@Binding var selectedPeople: People?
    
    //var li: [] = ListData()
    
    var body: some View {
        HStack(alignment: .top){

            //StringObjectListView(stringObject: StringObjectsData)
            VStack{
                ControlPanel()
                StringObjectList()
                LogList()
                    .frame(width:400, height: 300.0)

            }
     
            .frame(width: 400.0)
            
            ScrollView([.horizontal, .vertical] , showsIndicators: true ){
                ZStack{
                    ImageView()
                    LabelsOnImage()
                }
            }
         
            .frame(width: 1100)
        }


    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .frame(width: 1500, height: 1000 )
    }
}


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








