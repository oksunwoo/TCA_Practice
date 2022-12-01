//
//  PhotoPassView.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/12/01.
//

import SwiftUI
import ComposableArchitecture

struct PhotoPass: ReducerProtocol {
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        <#code#>
    }
}

struct PhotoPassView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PhotoPassView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPassView()
    }
}
