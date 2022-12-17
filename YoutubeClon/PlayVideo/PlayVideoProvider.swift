//
//  PlayVideoProvider.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 11/12/22.
//

import Foundation


protocol PlayVideoProviderProtocol{
    func getVideo(_ videoId: String) async throws -> VideoModel
    func getRelatedVideos(_ relatedVideoId: String) async throws -> VideoModel
    func getChannel(_ channelId: String) async throws -> ChannelModel
}

class PlayVideoProvider: PlayVideoProviderProtocol {
    
    func getVideo(_ videoId: String) async throws -> VideoModel{
        let queryItems = ["id": videoId, "part": "snippet,contentDetails,status,statistics"]
        let request = RequestModel(endpoint: .videos, queryItems: queryItems)
        
        do{
            let model = try await ServiceLayer.callService(request, VideoModel.self)
            return model
        }catch{
            throw error
        }
    }
    
    func getRelatedVideos(_ relatedVideoId: String) async throws -> VideoModel {
        let queryItems = ["relatedVideoId": relatedVideoId, "part": "snippet", "maxResults":"50","type":"video"]
        let requestModel = RequestModel(endpoint: .search, queryItems: queryItems)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, VideoModel.self)
            return model
        }catch {
            throw error
        }
    }
    
    func getChannel(_ channelId: String) async throws -> ChannelModel {
        let queryParams = ["id" : channelId, "part":"snippet,statistics"]
        let requestModel = RequestModel(endpoint: .channels, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, ChannelModel.self)
            return model
        }catch {
            throw error
        }
    }
    
}
