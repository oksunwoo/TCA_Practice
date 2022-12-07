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
            let headers: [String: String] = ["Content-Type": "multipart/form-data; boundary=\(boundary)", "Authorization": ""]
            
            headers.forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            var body = Data()

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"toni\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: toni\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            return String(decoding: data, as: UTF8.self)
        })
}
