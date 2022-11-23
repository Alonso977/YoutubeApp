//
//  HomeViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 16/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Alonso: - Conectando al presenter
    lazy var presenter = HomePresenter(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await presenter.getHomeObjects()
        }
    }
}

extension HomeViewController : HomeViewProtocol {
    func getData(list: [Any]) {
        print("list : ", list)
    }
    
    
}
