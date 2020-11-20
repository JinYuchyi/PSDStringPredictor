//
//  ScriptManager.swift
//  PSDStringPredictor
//
//  Created by ipdesign on 20/11/2020.
//  Copyright © 2020 ipdesign. All rights reserved.
//

import Foundation

class TernimalScriptManager{
    
    func execute(command: String) {
        let script = """
    tell application \"Terminal\"
        do script "\(command)"
    end tell
    """
        print(script)
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output = scriptObject.executeAndReturnError(&error)
            
            if (error != nil) {
                print("error: \(String(describing: error))")
            } else {
                print("output: \(String(describing: output.stringValue))")
            }
        }
    }
    
    func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/python"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    
}
