//
//  AboutProvider.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 1/12/22.
//

import Foundation

protocol AboutProviderProtocol {
    func getVideos(channelId: String) async throws -> VideoModel
}

class AboutProvider: AboutProviderProtocol{
    func getVideos(channelId: String) async throws -> VideoModel {
        var queryParams: [String:String] = ["part":"snippet", "type": "video", "maxResults": "50"]
        
        if !channelId.isEmpty {
            queryParams["channelId"] = channelId
        }
        let requestModel = RequestModel(endpoint: .search, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            return model
        }catch {
             print(error)
            throw error
        }
    }
}
