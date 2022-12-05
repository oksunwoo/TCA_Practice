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
        var photoData: Data?
        var isPhotoRequest = false
        var result: String?
        @BindableState var photo: UIImage?
        @BindableState var isPhotoPickerPresented = false
    }
    
    enum Action: BindableAction, Equatable {
        case confirmButtonTapped
        case photoResponse(TaskResult<String>)
        case photoInput(UIImage?)
        case showPhotoPicker
        case binding(BindingAction<State>)
    }
    
    @Dependency (\.photoClient) var photoClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .confirmButtonTapped:
                state.isPhotoRequest = true
                state.photoData = changeType(from: state.photo!)
                
                return .task { [photoData = state.photoData] in
                    await .photoResponse(TaskResult { try await
                        self.photoClient.post(photoData!)
                    })
                }
                
            case .photoInput(let photo):
                state.photo = photo
                return .none
                
            case .photoResponse(.success(let response)):
                state.isPhotoRequest = false
                state.result = response
                
                return .none
                
            case .photoResponse(.failure):
                state.isPhotoRequest = false
                return .none
                
            case .showPhotoPicker:
                state.isPhotoPickerPresented.toggle()
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}

func changeType(from image: UIImage) -> Data {
    return image.jpegData(compressionQuality: 1)!
}


struct PhotoPassView: View {
    let store: StoreOf<PhotoPass>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) {
            viewStore in
            Section {
                VStack {
                    Text("매니매니봉봉")
                    Button {
                        viewStore.send(.showPhotoPicker)
                    } label: {
                        let image = viewStore.photo == nil ? Image(systemName: "plus.circle") : Image(uiImage: viewStore.photo!)
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: viewStore.binding(\.$isPhotoPickerPresented)) {
                        PhotoPicker(image: viewStore.binding(\.$photo))
                    }
                   
                    Button("결과 확인하기") {
                        viewStore.send(.confirmButtonTapped)
                    }
                    .buttonStyle(.bordered)
                    
                    if viewStore.isPhotoRequest {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .id(UUID())
                    }
                    
                    if let result = viewStore.result {
                        Text(result)
                    }
                }
            }
        }
    }
}



struct PhotoPassView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhotoPassView(store: Store(initialState: PhotoPass.State(), reducer: PhotoPass()))
        }
    }
}
