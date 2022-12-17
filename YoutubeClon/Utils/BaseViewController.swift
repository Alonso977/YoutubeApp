//
//  BaseViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 2/12/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func configNavigationBar(){
        let stackOption = UIStackView()
        stackOption.axis = .horizontal
        stackOption.distribution = .fillEqually
        stackOption.spacing = 0.0
        stackOption.translatesAutoresizingMaskIntoConstraints = false
        
        let share = buildButtons(selector: #selector(shareButtonPressed), image: .castImage, inset: 30)
        let magnify = buildButtons(selector: #selector(magnifyButtonPressed), image: .magnifyingImage, inset: 30)
        let dots = buildButtons(selector: #selector(dotsButtonPressed), image: .dotsImage, inset: 30)
        
        stackOption.addArrangedSubview(share)
        stackOption.addArrangedSubview(magnify)
        stackOption.addArrangedSubview(dots)
        
        stackOption.widthAnchor.constraint(equalToConstant: 120).isActive = true
        let customItemView = UIBarButtonItem(customView: stackOption)
        customItemView.tintColor = .clear
        navigationItem.rightBarButtonItem = customItemView
    }
    
    private func buildButtons(selector: Selector, image : UIImage, inset: CGFloat)-> UIButton{
        let button = UIButton()
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = .whiteColor
        let extraPadding : CGFloat = 2.0
        button.imageEdgeInsets = UIEdgeInsets(top: inset+extraPadding, left: inset, bottom: inset+extraPadding, right: inset)
        return button
    }
    
    @objc func shareButtonPressed(){
        print("shareButtonPressed")
    }
    
    @objc func magnifyButtonPressed(){
        print("magnifyButtonPressed")
    }
    
    @objc func dotsButtonPressed(){
        print("dotsButtonPressed")
    }
    
}
