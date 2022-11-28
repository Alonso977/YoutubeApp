//
//  PlaylistCell.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 22/11/22.
//

import UIKit
import Kingfisher


class PlaylistCell: UITableViewCell {

    @IBOutlet weak var dotsImage: UIImageView!
    @IBOutlet weak var videoCountOverlay: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    
    var didTapDostsButton : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        selectionStyle = .none
        
        dotsImage.image = UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate)
        dotsImage.tintColor = UIColor(named: "grayColor")
    }

    @IBAction func dotsButtonTapped(_ sender: Any) {
        if let tap = didTapDostsButton{
            tap()
        }
    }
    
    func configCell(model: PlayListModel.Items) {
        videoTitle.text = model.snippet.title
        videoCount.text = String(model.contentDetails.itemCount)+" videos"
        videoCountOverlay.text = String(model.contentDetails.itemCount)
        
        let imageUrl = model.snippet.thumbnails.medium.url
        if let url = URL(string: imageUrl) {
            videoImage.kf.setImage(with: url)
        }
        
        
    }
}
