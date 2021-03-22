//
//  AppDelegate.swift
//  UITest
//
//  Created by ipdesign on 3/9/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Cocoa
import SwiftUI
import CoreData

let viewContext = AppDelegate().persistentContainer.viewContext

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
//    var charWindow: NSWindow!

//    var settingWindow: NSWindow!
    let dbUtils = DBUtils.shared
    @ObservedObject var psdsVM = PsdsVM()
    @ObservedObject var imageProcess = ImageProcess()
    @ObservedObject var settingVM = SettingViewModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
  
        let contentView = ContentView( imageViewModel: imageProcess, psdsVM: psdsVM, settingVM: settingVM)

        let screenSize = NSScreen.main?.frame

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: screenSize ?? NSRect(x: 0, y: 0, width: 1700, height: 1000),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView, .resizable],
            backing: .buffered, defer: false)
        window.center()
        window.isReleasedWhenClosed = true
        window.setFrameAutosaveName("StringGeneratorMain")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.title = "AutoLayer \(softwareInfo.getMainVersion())"

        //Prepare the config setting
        PreSettingConfig()
        
    }
    
//    func createCharDSWindow(img: CIImage) {
//        charWindow = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
//            styleMask: [.closable],
//            backing: .buffered, defer: false)
//        charWindow.center()
//        
//    }
//    
//    func closeCharDSWindow() {
//        charWindow.isReleasedWhenClosed = true
//        charWindow.close()
//    }
    
    
    
    
    func PreSettingConfig(){
//        stringObjectVM.frameOverlay = false
//        stringObjectVM.stringOverlay = true
        //Load color data
        imageProcess.FetchStandardHSVList()
//        CSVManager.shared.ParsingCsvFileAsFrontSpace(FilePath: )
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        //self.saveContext ()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FontData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving and Undo support
    
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }
    
    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            
            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
    
    @IBAction func AboutStringLayerGenerator(_ sender: Any) {
        // 应用警示框
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = "DTP Asia"

        
        alert.informativeText = "yuqi_jin@apple.com"
        alert.beginSheetModal(for: NSApp.mainWindow!, completionHandler: nil)
    }
    
    @IBAction func LoadFontSizeTable(_ sender: Any) {
        dbUtils.ReloadCharacterTable()
    }
    
    @IBAction func LoadFontTrackingTable(_ sender: Any) {
        dbUtils.ReloadFontTable()
    }
    
    @IBAction func LoadBoundsTable(_ sender: Any) {
        dbUtils.ReloadBoundsTable()
    }

    @IBAction func LoadPreference(_ sender: Any) {
        let plistM = PlistManager.shared
        self.window = ClosableWindow (contentRect: NSMakeRect (0, 0, 480, 300), styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView], backing: NSWindow.BackingStoreType.buffered, defer: false)
        let item = plistM.Load(plistName: "AppSettings")
        //print(item.Debug)
        //self.window! .title = "new window"
        self.window! .isOpaque = false
        self.window! .center ()
        self.window! .contentView = NSHostingView (rootView: SettingsView(item: item, settingsVM: settingVM, PSPath: settingVM.LoadPList(name: "AppSettings").PSPath))
        self.window! .isMovableByWindowBackground = true
        self.window! .makeKeyAndOrderFront (nil)
         
        //self.window.contentView = NSWindowController (window: self.window)
        
    }
    
    @IBAction func LoadFile(_ sender: Any) {
        
    }
    
    @IBAction func LoadImage(_ sender: Any) {
        //stringObjectVM.LoadImageBtnPressed()
        psdsVM.LoadImage()
    }
    
    @IBAction func ToggleShowStringLayer(_ sender: Any) {
        psdsVM.stringIsOn.toggle()
        //print("Toggle")
    }
    @IBAction func MoveUp(_ sender: Any) {
//        guard let lastID = psdsVM.selectedStrIDList.last else {return}
//        guard let lastObj = psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: lastID) else {return}
        psdsVM.tmpObjectForStringProperty.posY = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minY + 1).toString()
        psdsVM.commitPosY()
//        let tmpRect = CGRect(x: lastObj.stringRect.minX, y: lastObj.stringRect.minY + 1, width: lastObj.stringRect.width, height: lastObj.stringRect.height)
//        psdsVM.psdModel.SetRect(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, value: tmpRect)

    }
    
    @IBAction func MoveUpLarge(_ sender: Any) {
        psdsVM.tmpObjectForStringProperty.posY = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minY + 10).toString()
        psdsVM.commitPosY()
    }
    
    @IBAction func MoveDown(_ sender: Any) {
//        guard let lastID = psdsVM.selectedStrIDList.last else {return}
//        guard let lastObj = psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: lastID) else {return}
        psdsVM.tmpObjectForStringProperty.posY = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minY - 1).toString()
        psdsVM.commitPosY()
//        let tmpRect = CGRect(x: lastObj.stringRect.minX, y: lastObj.stringRect.minY - 1, width: lastObj.stringRect.width, height: lastObj.stringRect.height)
//        psdsVM.psdModel.SetRect(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, value: tmpRect)
    }
    
    @IBAction func MoveDownLarge(_ sender: Any) {
        psdsVM.tmpObjectForStringProperty.posY = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minY - 10).toString()
        psdsVM.commitPosY()
    }
    
    
    @IBAction func MoveLeft(_ sender: Any) {
//        guard let lastID = psdsVM.selectedStrIDList.last else {return}
//        guard let lastObj = psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: lastID) else {return}
        psdsVM.tmpObjectForStringProperty.posX = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minX - 1).toString()
        psdsVM.commitPosX()
//        let tmpRect = CGRect(x: lastObj.stringRect.minX - 1, y: lastObj.stringRect.minY, width: lastObj.stringRect.width, height: lastObj.stringRect.height)
//        psdsVM.psdModel.SetRect(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, value: tmpRect)
    }
    
    
    @IBAction func MoveLeftLarge(_ sender: Any) {
        psdsVM.tmpObjectForStringProperty.posX = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minX - 10).toString()
        psdsVM.commitPosX()
    }
    
    @IBAction func MoveRight(_ sender: Any) {
//        guard let lastID = psdsVM.selectedStrIDList.last else {return}
//        guard let lastObj = psdsVM.GetSelectedPsd()?.GetStringObjectFromOnePsd(objId: lastID) else {return}
        psdsVM.tmpObjectForStringProperty.posX = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minX + 1).toString()
        psdsVM.commitPosX()
//        let tmpRect = CGRect(x: lastObj.stringRect.minX + 1, y: lastObj.stringRect.minY, width: lastObj.stringRect.width, height: lastObj.stringRect.height)
//        psdsVM.psdModel.SetRect(psdId: psdsVM.selectedPsdId, objId: psdsVM.selectedStrIDList.last!, value: tmpRect)
    }
    
    
    @IBAction func MoveRightLarge(_ sender: Any) {
        psdsVM.tmpObjectForStringProperty.posX = (psdsVM.fetchLastStringObjectFromSelectedPsd().stringRect.minX + 10).toString()
        psdsVM.commitPosX()
    }
    
 
    @IBAction func SaveDocument(_ sender: Any) {
        psdsVM.SaveDocument()
    }
    @IBAction func OpenDocument(_ sender: Any) {
        psdsVM.OpenDocument()
    }
    @IBAction func OpenRadarURL(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "rdar://new/problem/component=DTP%20Tools&version=PS%20Layering")!)
    }
    @IBAction func DeleteSelectedStringObjects(_ sender: Any) {
        psdsVM.deleteSelectedStringObjects()
    }
    @IBAction func duplicateStringObject(_ sender: Any) {
        var str = psdsVM.fetchLastStringObjectFromSelectedPsd()
        str.id = UUID()
        psdsVM.psdStrDict[psdsVM.selectedPsdId]?.append(str.id)
        psdsVM.stringObjectDict[str.id] = str
    }
}

