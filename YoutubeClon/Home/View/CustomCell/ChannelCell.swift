//
//  ChannelCell.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 22/11/22.
//

import UIKit
import Kingfisher

class ChannelCell: UITableViewCell {

    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var channelInfoLabel: UILabel!
    @IBOutlet weak var suscriberNumbersLabel: UILabel!
    @IBOutlet weak var bellImage: UIImageView!
    @IBOutlet weak var suscribeLabel: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    private func configureView() {
        selectionStyle = .none
        bellImage.image = .bellImage
        bellImage.tintColor = .grayColor
        // redondeando la imagen
        profileImage.layer.cornerRadius = 51/2
    }
    
    func configCell(model: ChannelModel.Items) {
        // Alonso: - Mostrando la data de forma dinamica
        channelInfoLabel.text = model.snippet.description
        channelTitle.text = model.snippet.title
        suscriberNumbersLabel.text = "\(model.statistics?.subscriberCount ?? "0") suscribers ∘ \(model.statistics?.videoCount ?? "0") videos"
        
        // trayendo la url usando kinfisher
        if let bannerUrl = model.brandingSettings?.image.bannerExternalUrl, let url = URL(string: bannerUrl) {
            bannerImage.kf.setImage(with: url)
        }
        
        
        let imageUrl = model.snippet.thumbnails.medium.url
        
        guard let url = URL(string: imageUrl) else {
            return
        }
        profileImage.kf.setImage(with: url)
    }
}
