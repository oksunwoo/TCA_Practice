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
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    var body: some View {
        VStack {
            Text("매니매니봉봉")
            Button {
                imagePickerPresented.toggle()
            } label: {
                let image = profileImage == nil ? Image(systemName: "plus.circle") : profileImage ?? Image(systemName: "plus.circle")
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.black)
            }
            .sheet(isPresented: $imagePickerPresented,
                   onDismiss: loadImage) {
                PhotoPicker(image: $selectedImage)
            }
            Button("결과 확인하기") {
                
            }
            .buttonStyle(.bordered)
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
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
