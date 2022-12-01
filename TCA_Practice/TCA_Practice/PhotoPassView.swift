//
//  PhotoPassView.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/12/01.
//

import SwiftUI
import ComposableArchitecture

//struct PhotoPass: ReducerProtocol {
//    struct State: Equatable {
//        
//    }
//    
//    enum Action: Equatable {
//        
//    }
//    
//    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
//        
//    }
//}

struct PhotoPassView: View {
    //let store: StoreOf<PhotoPass>
    
    var body: some View {
        VStack {
            Text("매니매니봉봉")
            
        }
        
    }
}

struct PhotoPassView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhotoPassView()
           // PhotoPassView(store: Store(initialState: PhotoPass.State(), reducer: PhotoPass()))
        }
    }
}
