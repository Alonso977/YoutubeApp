//
//  MainViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 15/11/22.
//

import UIKit

class MainViewController: UIViewController {

    var rootPageViewController: RootPageViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootPageViewController {
            // aqui le estamos pasando el indice de cada controlador
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }
    
}

extension MainViewController: RootPageProtocol {
    func currentPage(_ index: Int) {
        print("Current page: ", index)
    }
    
    
}
