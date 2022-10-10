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
            ScrollView {
                Text(vm.consoleLog)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 200)
                
            HStack{
                TextField("Commit message", text: $vm.commitMessage, onCommit: {
                    vm.commitnPush()
                })
                    
                    .frame(maxWidth: 200)
                    
                Button {
                    vm.commitnPush()
                } label: {
                    Text("Commit & Push")
                }

            }
            Spacer()
        }
    }
}

struct RepositoryFunctionsView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryFunctionsView("TESTINGOS")
    }
}
