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
            var request = URLRequest(url: URL(string: "https://cv-api.kakaobrain.com/pose")!)
            request.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            let headers: [String: String] = ["Content-Type": "multipart/form-data;boundary=\(boundary)", "Authorization": "KakaoAK 32e827cd3335958e97b7b7240ec4466c"]
            
            headers.forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            var body = Data()
            let boundaryPrefix = "--\(boundary)\r\n"
            
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"r\n".data(using: .utf8)!)
            //body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            //body.append(json)
            body.append("\r\n".data(using: .utf8)!)
            
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://cv-api.kakaobrain.com/pose")!)
            
            return String(decoding: data, as: UTF8.self)
        })
}
