//
//  PlayListProvider.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 28/11/22.
//

import Foundation

protocol PlaylistProviderProtocol {
    func getPlaylists(channelId: String) async throws -> PlayListModel
}
 
class PlayListProvider: PlaylistProviderProtocol {
    func getPlaylists(channelId: String) async throws -> PlayListModel {
        let queryParams: [String:String] = ["part":"snippet,contentDetails", "channelId" : channelId]

        let requestModel = RequestModel(endpoint: .playlist, queryItems: queryParams)
        
        do {
            let model = try await ServiceLayer.callService(requestModel, PlayListModel.self)
            return model
        }catch {
             print(error)
            throw error
        }
    }
}
