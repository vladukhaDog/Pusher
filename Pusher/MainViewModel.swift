//
//  MainViewModel.swift
//  Pusher
//
//  Created by Permyakov Vladislav on 10.10.2022.
//

import Foundation
import SwiftUI
class MainViewModel: ObservableObject{
    @Published var projectPath = ""
    
    func selectRepositoryFromFiles(){
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        if panel.runModal() == .OK,  panel.url?.absoluteString != nil{
            if let fileNames = try? FileManager.default.contentsOfDirectory(atPath: panel.url?.path ?? ""){
                if fileNames.contains(".git"){
                    self.projectPath = panel.url?.path ?? ""
                }else{
                    print("Not A Repository")
                }
            }else{
                print("Got problems getting contents of Directory")
            }
            
        }
    }
}
