//
//  RepositoryFunctionsView.swift
//  Pusher
//
//  Created by Permyakov Vladislav on 10.10.2022.
//

import SwiftUI
import Foundation
import Combine
import AppKit

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
                VStack(spacing: 0){
                    consoleLogView
                    commandTextField
                }
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
//        ScrollView {
//            VStack{
        TextEditor(text: .constant(vm.consoleLog.joined(separator: "\n")))
//            }
////            Text(vm.consoleLog)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .rotationEffect(.degrees(-180))
//                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//        }
//        .frame(maxWidth: .infinity)
//        .rotationEffect(.degrees(180))
//        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//        .background(Color.primary.colorInvert().opacity(0.3).cornerRadius(15))
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
        .background(Color.primary.colorInvert().opacity(0.3).cornerRadius(5))
        .textFieldStyle(.plain)
    }
    @State private var showingCommandLine = false
    let commandBackColor = Color.black
    private var commandTextField: some View{
        HStack(spacing: 0){
            if showingCommandLine{
                HStack{
                    TextField("Console command", text: $vm.consoleMessage, onCommit: {
                        vm.consoleExecute()
                    })
                    .padding(8)
                    .background(Color.primary.colorInvert().opacity(0.3).cornerRadius(5))
                    .textFieldStyle(.plain)
                    Button {
                        vm.consoleExecute()
                    } label: {
                        Text("Exec")
                    }

                }
                .frame(height: 50)
                .background(commandBackColor)
                .id(showingCommandLine)
                .transition(.move(edge: .top).combined(with: .opacity))
            }else{Spacer()}
            Button {
                withAnimation {
                    showingCommandLine.toggle()
                }
            } label: {
                HStack(spacing: 1){
                    Text("<")
                        .font(.title)
                        .rotation3DEffect(.degrees(showingCommandLine ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    
                    Text("/")
                        .font(.title)
                    
                    Text(">")
                        .font(.title)
                        .rotation3DEffect(.degrees(showingCommandLine ? -180 : 0), axis: (x: 0, y: 1, z: 0))
                }
                .padding()
                .background(commandBackColor)
                .frame(height: 50)
            }
            .buttonStyle(.plain)
            .background(commandBackColor)
        }.clipped()
    }
}

struct RepositoryFunctionsView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryFunctionsView("TESTINGOS")
    }
}

//
//extension View{
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//            clipShape( RoundedCorner(radius: radius, corners: corners) )
//        }
//}
//struct RoundedCorner: Shape {
//
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
