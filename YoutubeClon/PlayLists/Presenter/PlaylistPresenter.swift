//
//  PlaylistPresenter.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 28/11/22.
//

import Foundation

protocol PlaylistViewProtocol: AnyObject {
    func getPlaylists(playList : [PlayListModel.Items])
}

class PlaylistPresenter {
    private weak var delegate: PlaylistViewProtocol?
    private var provider: PlaylistProviderProtocol
    
    init(delegate: PlaylistViewProtocol, provider: PlaylistProviderProtocol = PlayListProvider()) {
        self.provider = provider
        self.delegate = delegate
        
        #if DEBUG
        if MockManager.shared.runAppWithMock {
            self.provider = PlayListProviderMock()
        }
        #endif
    }
    
    @MainActor
    func getPlaylists() async {
        do{
            let playlist = try await provider.getPlaylists(channelId: Constants.channelId).items
            delegate?.getPlaylists(playList: playlist)
        }catch{
            print("error")
        }
    }
    
}
