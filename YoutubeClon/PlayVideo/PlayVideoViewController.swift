//
//  PlayVideoViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 6/12/22.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tableViewVideos: UITableView!
    lazy var presenter = PlayVideoPresenter(delegate: self)
    
    var videoId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromApi()
        configPlayerView()
        configTableView()
    }
    
    private func loadFromApi(){
        Task{ [weak self] in
            await self?.presenter.getVideos(videoId)
            
        }
    }
    
    func configPlayerView() {
        let playerVars : [AnyHashable: Any] = ["playsinline":1, "controls":1, "autohide":1, "showinfo":0, "modestbranding": 0]
        
        playerView.load(withVideoId: videoId, playerVars: playerVars)
        playerView.delegate = self
    }
    
    private func configTableView(){
        //delegate
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
        
        //register tables
        tableViewVideos.register(cell: VideoHeaderCell.self)
        tableViewVideos.register(cell: VideoFullWithCell.self)
        
        tableViewVideos.rowHeight = UITableView.automaticDimension
        tableViewVideos.estimatedRowHeight = 60
    }
}

extension PlayVideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.relatedVideoList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.relatedVideoList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.relatedVideoList[indexPath.section]
        if indexPath.section == 0{
            guard let video = item[indexPath.row] as? VideoModel.Item else{return UITableViewCell()}
            
            let videoHeaderCell = tableView.dequeueReusableCell(for: VideoHeaderCell.self, for: indexPath)
            videoHeaderCell.configCell(videoModel: video, channelModel: presenter.channelModel)
            videoHeaderCell.selectionStyle = .none
            return videoHeaderCell
        }else {
            
            guard let video = item[indexPath.row] as? VideoModel.Item else{ return UITableViewCell()}
            let videoFullWithCell = tableView.dequeueReusableCell(for: VideoFullWithCell.self, for: indexPath)
            videoFullWithCell.configCell(model: video)
            return videoFullWithCell
        }
    }
    
    
}


extension PlayVideoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}

extension PlayVideoViewController: PlayVideoViewProtocol{
    func getRelatedVideosFinished(){
        print("response")
        tableViewVideos.reloadData()
    }
}
