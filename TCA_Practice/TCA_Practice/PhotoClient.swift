//
//  PhotoClient.swift
//  TCA_Practice
//
//  Created by Sunwoo on 2022/12/01.
//

import Foundation
import ComposableArchitecture

struct PhotoClient {
    var post: @Sendable (Data) async throws -> String
}

extension DependencyValues {
    var photoClient: PhotoClient {
        get { self[PhotoClient.self] }
        set { self[PhotoClient.self] = newValue }
    }
}

extension PhotoClient: DependencyKey {
    static let liveValue = PhotoClient(
        post: { imageData in
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://cv-api.kakaobrain.com/pose")!)
            
            return String(decoding: data, as: UTF8.self)
        })
}
