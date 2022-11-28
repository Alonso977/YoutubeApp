//
//  BottonSheetViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 25/11/22.
//

import UIKit

class BottonSheetViewController: UIViewController {
    
    @IBOutlet weak var optionContainer: UIView!
    @IBOutlet weak var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Alonso: - Ocultar las opciones
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay(_:)))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        optionContainer.animateBottomSheet(show: true){}
    }
    
    
    @objc func didTapOverlay(_ sender: UITapGestureRecognizer) {
        optionContainer.animateBottomSheet(show: false){
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
}
