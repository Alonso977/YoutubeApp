//
//  VideoCell.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 22/11/22.
//

import UIKit

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    
    @IBOutlet weak var dotsImage: UIImageView!
    
    var didTapDostsButton : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
        
    }
    
    private func configView() {
        selectionStyle = .none
        videoImage.layer.cornerRadius = 6
    }
    
    @IBAction func dotsButtonTapped(_ sender: Any) {
        if let tap = didTapDostsButton{
            tap()
        }
    }
    func configCell(model: Any) {
        
        dotsImage.image = .dotsImage
        dotsImage.tintColor = .grayColor
        
        if let video = model as? VideoModel.Item {
            if let imageUrl = video.snippet?.thumbnails.medium?.url, let url = URL(string: imageUrl){
                videoImage.kf.setImage(with: url)
            }
            videoName.text = video.snippet?.title ?? ""
            channelName.text = video.snippet?.channelTitle ?? ""
            viewsCount.text = "\(video.statistics?.viewCount ?? "0") views - 3 weaks ago"
            
        }else if let playlistItems = model as? PlaylistItemsModel.Item {
            
            if let imageUrl = playlistItems.snippet.thumbnails.medium?.url, let url = URL(string: imageUrl){
                videoImage.kf.setImage(with: url)
            }
            videoName.text = playlistItems.snippet.title
            channelName.text = playlistItems.snippet.channelTitle
            viewsCount.text = "332 views - 3 weaks ago"
            
        }
    }
    
}
