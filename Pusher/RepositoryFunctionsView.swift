//
//  RepositoryFunctionsView.swift
//  Pusher
//
//  Created by Permyakov Vladislav on 10.10.2022.
//

import SwiftUI

struct RepositoryFunctionsView: View {
    @StateObject private var vm: RepositoryFunctionsViewModel
    init(_ path: String){
        self._vm = StateObject(wrappedValue: .init(path))
    }
    var body: some View {
        VStack{
            Text(vm.repoName)
                .font(.largeTitle)
            HStack{
                consoleLogView
                VStack(alignment: .leading){
                    branchPicker
                    commitTextField
                    ScrollView{
                        buttonsGrid
                        HStack{
                            Spacer()
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
    private var buttonsGrid: some View{
        
            VStack {
//            VStack{
                Button {
                    vm.fetchBranches()
                } label: {
                    HStack{
                        Spacer()
                        Text("Get Branches")
                        Spacer()
                    }
                    .padding()
                    .background(Color.red)
                }
                .cornerRadius(15)
                .buttonStyle(.plain)
                Button {
                    vm.commitnPush()
                } label: {
                    HStack{
                        Spacer()
                        Text("Commit & Push")
                        Spacer()
                    }
                    .padding()
                    .background(Color.red)
                }
                .cornerRadius(15)
                .buttonStyle(.plain)
                Button {
                    
                } label: {
                    HStack{
                        Spacer()
                        Text("Commit")
                        Spacer()
                    }
                    .padding()
                    .background(Color.red)
                }
                .cornerRadius(15)
                .buttonStyle(.plain)
                Button {
                    
                } label: {
                    HStack{
                        Spacer()
                        Text("Push")
                        Spacer()
                    }
                    .padding()
                    .background(Color.red)
                }
                .cornerRadius(15)
                .buttonStyle(.plain)
                
                Button {
                    vm.Pull()
                } label: {
                    HStack{
                        Spacer()
                        Text("Pull")
                        Spacer()
                    }
                    .padding()
                    .background(Color.red)
                }
                .cornerRadius(15)
                .buttonStyle(.plain)
            }
        
    }
    private var consoleLogView: some View{
        ScrollView {
            VStack{
                ForEach(vm.consoleLog, id: \.self){message in
                    Text(message)
                    Divider()
                }
            }
//            Text(vm.consoleLog)
                .frame(maxWidth: .infinity)
                .padding()
                .rotationEffect(.degrees(-180))
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(maxWidth: .infinity)
        .rotationEffect(.degrees(180))
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        .background(Color.primary.colorInvert().opacity(0.3).cornerRadius(15))
    }
    private var branchPicker: some View{
            Picker("", selection: $vm.selectedBranch) {
                ForEach(vm.branches, id: \.self){branch in
                    Text(branch)
                        .id(branch)
                        .tag(branch)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: vm.selectedBranch) { newValue in
                vm.updateCheckout()
                UserDefaults.standard.set(newValue, forKey: "branchFor/\(vm.path)")
            }
    }
    private var commitTextField: some View{
        TextField("Commit message", text: $vm.commitMessage, onCommit: {
            vm.commitnPush()
        })
        .padding(8)
        .background(Color.primary.colorInvert().opacity(0.3).cornerRadius(15))
        .textFieldStyle(.plain)
    }
}

struct RepositoryFunctionsView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryFunctionsView("TESTINGOS")
    }
}
