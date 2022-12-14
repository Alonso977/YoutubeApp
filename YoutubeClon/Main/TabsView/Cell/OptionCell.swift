//
//  OptionCell.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 5/12/22.
//

import UIKit

class OptionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override var isSelected: Bool{
        didSet {
            highlightTitle(isSelected ? .whiteColor : .grayColor)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func highlightTitle(_ color: UIColor){
        titleLabel.textColor = color
    }
    
    func configCell(options: String) {
        titleLabel.text = options
    }
}
