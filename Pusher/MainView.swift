//
//  ContentView.swift
//  Pusher
//
//  Created by Permyakov Vladislav on 10.10.2022.
//

import SwiftUI

struct MainView: View {
    @StateObject private var vm: MainViewModel = .init()
    var body: some View {
        VStack {
            Button {
                vm.selectRepositoryFromFiles()
            } label: {
                Text("Select Repository")
            }
            VStack{
                if !vm.projectPath.isEmpty{
                    RepositoryFunctionsView(vm.projectPath)
                        .id(vm.projectPath)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).combined(with: .opacity))
                        
                }
            }.animation(.spring(), value: vm.projectPath)
        }
        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
