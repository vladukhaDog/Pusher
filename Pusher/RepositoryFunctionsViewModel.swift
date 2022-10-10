//
//  RepositoryFunctionsViewModel.swift
//  Pusher
//
//  Created by Permyakov Vladislav on 10.10.2022.
//

import Foundation
import SwiftUI
class RepositoryFunctionsViewModel: ObservableObject{
    @Published var consoleLog: [String] = []
    @Published var commitMessage: String = ""
    @Published var consoleMessage: String = ""
    @Published var branches: [String] = []
    @Published var selectedBranch: String = ""
    @Published var repoName: String = ""
    let path: String
    init(_ path: String){
        
        
        self.path = path
        fetchBranches()
        if let branch = UserDefaults.standard.string(forKey: "branchFor/\(path)"){
            if let branchFromCache = self.branches.first(where: { br in
                br.contains(branch)
            }){
                selectedBranch = branchFromCache
            }
        }
        self.getRepoName()
    }
    
    func fetchBranches(){
        self.branches = []
        var array = ((try? safeShell("cd \(self.path); git branch -r;")) ?? "").split(whereSeparator: \.isNewline)
        array.removeAll { kn in
            kn.contains("->")
        }
        if !array.isEmpty{
            for item in array{
                self.branches.append("\(item)")
            }
        }
        
        if let first = self.branches.first{
            selectedBranch = first
        }
    }
    
    func commitnPush(){
        DispatchQueue.main.async {
            let response = try? self.safeShell("cd \(self.path);git add .; git commit -m \"\(self.commitMessage)\"; git push \(self.selectedBranch)")
            if let response{
                withAnimation {
                    self.commitMessage = ""
                    self.consoleLog.append(response)
                }
            }
        }
    }
    func getRepoName() {
        DispatchQueue.main.async {
            let response = try? self.safeShell("cd \(self.path); git config --get remote.origin.url")
            if let response{
                let arr = response.components(separatedBy: "/")
                withAnimation {
                    self.repoName = arr.last ?? ""
                }
            }
        }
    }
    func updateCheckout(){
        DispatchQueue.main.async {
            let response = try? self.safeShell("cd \(self.path); git checkout \(self.selectedBranch);")
            if let response{
                withAnimation {
                    self.consoleLog.append(response)
                }
            }
        }
    }
    func Pull(){
        DispatchQueue.main.async {
            let response = try? self.safeShell("cd \(self.path); git pull \(self.selectedBranch)")
            if let response{
                withAnimation {
                    self.consoleLog.append(response)
                }
            }
        }
    }
    func Push(){
        DispatchQueue.main.async {
            let response = try? self.safeShell("cd \(self.path); git push \(self.selectedBranch)")
            if let response{
                withAnimation {
                    self.consoleLog.append(response)
                }
            }
        }
    }
    func Commit(){
        DispatchQueue.main.async {
            let response = try? self.safeShell("cd \(self.path); git add .; git commit -m \"\(self.commitMessage)\"; ")
            if let response{
                withAnimation {
                    self.commitMessage = ""
                    self.consoleLog.append(response)
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
