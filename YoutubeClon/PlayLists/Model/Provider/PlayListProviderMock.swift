//
//  PlayListProviderMock.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 28/11/22.
//

import Foundation

class PlayListProviderMock: PlaylistProviderProtocol{
    
    func getPlaylists(channelId: String) async throws -> PlayListModel {
        guard let model = Utils.parseJson(jsonName: "Playlists", model: PlayListModel.self) else {
            throw NetworkError.jsonDecoder
        }
        return model
    }

}
