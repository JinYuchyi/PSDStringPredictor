//
//  ControlPanel.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 8/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import SwiftUI
import CoreData

struct ControlPanel: View {
    
    var dbvm = DBViewModel()
    @ObservedObject var stringObjectVM: StringObjectViewModel = stringObjectViewModel
    //@ObservedObject var loglist: LogListData
    //@ObservedObject var db: DB = DB()
    //@ObservedObject var ocr: OCR = OCR()
    //@ObservedObject var stringObjectList: StringObjectList  = StringObjectList()
    var imageProcess: ImageProcess  = imageProcessViewModel
    var imgUtil: ImageUtil = ImageUtil()
    var pixelProcess = PixelProcess()
    var db = DB()
    var training = MLTraining()
    //@ObservedObject var data: DataStore
    @Binding var showImage: Bool
    @Environment(\.managedObjectContext) private var viewContext
    let trackingData = TrackingDataManager.shared
    

    
    var body: some View {
        VStack{
            Button(action: {self.LoadImageBtnPressed()}){
                Text("Load Image")
                .frame(minWidth: 200, maxWidth: .infinity)
            }.padding(.horizontal, 40.0)
            
            Button(action: {self.dbvm.ConnectDB()}){
                Text("Connect Database")
                .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
            
            Button(action: {self.dbvm.ReloadCharacterTable()}){
                Text("Reload String Table")
                .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
            
            Button(action: {self.dbvm.ReloadFontTable()}){
                Text("Reload Font Table")
                .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)

            }
            .padding(.horizontal, 40.0)
   
            Button(action: {self.stringObjectVM.PredictStrings()}){
                Text("Predict Strings")
                .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)
            }
            .frame(minWidth: 400, maxWidth: .infinity)
            
            Button(action: {self.stringObjectVM.PredictStrings()}){
                Text("Modify PSD")
                .padding(.horizontal, 40.0)
                .frame(minWidth: 200, maxWidth: .infinity)
            }
            .frame(minWidth: 400, maxWidth: .infinity)

            
            Button(action: {self.Debug()}){
                Text("Debug")
            }
            .frame(width: 500, height: 20, alignment: Alignment.center)
        }
        .frame(height: 200.0)
    }
    
    func LoadImageBtnPressed()  {
        let panel = NSOpenPanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let result = panel.runModal()
            if result == .OK{
                if ((panel.url?.pathExtension == "png" || panel.url?.pathExtension == "psd") )
                {
                    let tmp = NSImage(imageUrlPath: panel.url!.path)
                    self.imageProcess.SetTargetNSImage(tmp)
                    self.showImage = true
                }
            }
        }
    }
    

    

    
    func Debug(){
//        TrackingDataManager.Delete(viewContext)
//        TrackingDataManager.Create(viewContext, 16, 50)
        //let item = TrackingDataManager.FetchNearestOne(viewContext, fontSize: 12)
        //let objList:[CharDataObject] = CharDataManager.FetchItems(AppDelegate().persistentContainer.viewContext, char: "S", width: 10, height: 14)
        //let objList:[CharDataObject] = CharDataManager.FetchItems(AppDelegate().persistentContainer.viewContext)
        //let items = TrackingDataManager.FetchItems(viewContext)
        //print(objList.count)
//        for item in objList{
//            print("\(item.fontSize) - \(item.fontTracking)")
//        }

//        TrackingDataManager.Create(viewContext, 115, 150)
//        TrackingDataManager.FetchItems(viewContext)
        var charDatas:[CharDataObject] = []
        let request: NSFetchRequest<CharacterData> = NSFetchRequest(entityName: "CharacterData")
        request.sortDescriptors = [NSSortDescriptor(key: "fontSize", ascending: true)]
        
        request.predicate = NSPredicate(format: "char = %@ and width = %@ and height = %@", ("S"), NSNumber(value: 10), NSNumber(value: 14))
        
        let objs = (try? AppDelegate().persistentContainer.viewContext.fetch(request)) ?? []
//        for item in objs {
//            print(item.height)
//        }
        
        
    }

}

//struct ControlPanel_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlPanel()
//    }
//}





