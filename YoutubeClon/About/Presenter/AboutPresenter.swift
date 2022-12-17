//
//  AboutPresenter.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 1/12/22.
//

import Foundation

protocol AboutViewProtocol: AnyObject {
    func getVideos(videoList: [VideoModel.Item])
}


class AboutPresenter{
    private weak var delegate: AboutViewProtocol?
    private var provider: AboutProviderProtocol
    
    init(delegate: AboutViewProtocol, provider: AboutProviderProtocol = AboutProvider()) {
        self.provider = provider
        self.delegate = delegate
    }
    
    func getVideo() async {
        do{
            let videos = try await provider.getVideos(channelId: Constants.iosacademyId).items
            delegate?.getVideos(videoList: videos)
        }catch{
            print("Ha ocurrido un error: ", error)
        }
    }
    
}
