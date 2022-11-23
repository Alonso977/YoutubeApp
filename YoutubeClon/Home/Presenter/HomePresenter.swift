//
//  HomePresenter.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 19/11/22.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    //Se hace un array dentro de otro para utilizar un tableview para toda la informacion
    func getData(list: [Any])
}

class HomePresenter {
    var provider : HomeProviderProtocol
    weak var delegate : HomeViewProtocol?
    private var objectList : [[Any]] = []
    
    
    init(delegate : HomeViewProtocol, provider : HomeProviderProtocol = HomeProvider()) {
        // Alonso: - De esta forma siempre que se compile va a llamar al provider se conecta a la API
        self.provider = provider
        self.delegate = delegate
        
        // Alonso: - De esta forma siempre que se compile va a llamar EL MOCK
#if DEBUG
        if MockManager.shared.runAppWithMock{
            self.provider = HomeProviderMock()
        }
#endif
    }
    
    
    func getHomeObjects() async{
        //borro todos los llamados que tenga a la API
        objectList.removeAll()
        
        // tengo los datos listos para ser usados
        async let channel = try await provider.getChannel(channelId: Constants.channelId).items
        async let playlist = try await provider.getPlaylists(channelId: Constants.channelId).items
        async let videos = try await provider.getVideos(searchString: "", channelId: Constants.channelId).items
        
        do {
            //los datos que ya tengo se los paso a estas variables
            let (responseChannel, responsePlaylist, responseVideos) = await(try channel, try playlist, try videos)
            //index 0
            objectList.append(responseChannel)
            
            //busco en la respuesta del playlist el id
            if let playlistId = responsePlaylist.first?.id, let playlistItems = await getPlaylistItems(playlistId: playlistId) {
                //index 1
                objectList.append(playlistItems.items)
            }
            
            //index2
            objectList.append(responseVideos)
            // index3
            objectList.append(responsePlaylist)
            
            // hago los llamados y los cargo en la funcion getData
            delegate?.getData(list: objectList)
            
        } catch {
            print(error)
        }
        
    }
    
    func getPlaylistItems(playlistId: String) async -> PlaylistItemsModel?{
        do {
            let playlistItems = try await provider.getPlaylistItems(playlistId: playlistId)
            return playlistItems
        } catch {
            print("error: ", error)
            return nil
        }
        
    }
    
}
