//
//  RepositoryFunctionsViewModel.swift
//  Pusher
//
//  Created by Permyakov Vladislav on 10.10.2022.
//

import Foundation
import SwiftUI
class RepositoryFunctionsViewModel: ObservableObject{
    @Published var consoleLog: String = ""
    @Published var commitMessage: String = ""
    @Published var consoleMessage: String = ""
    let path: String
    init(_ path: String){
        self.path = path
        consoleLog = (try? safeShell("cd \(self.path); git branch -r;")) ?? ""
    }
    
    func commitnPush(){
        DispatchQueue.main.async {
            let response = try? self.safeShell("cd \(self.path);git add .; git commit -m \"\(self.commitMessage)\"; git push origin main")
            if let response{
                withAnimation {
                    self.commitMessage = ""
                    self.consoleLog += response
                }
            }
        }
    }
    
    private func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
}
