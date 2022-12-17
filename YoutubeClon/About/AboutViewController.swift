//
//  AboutViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 16/11/22.
//

import UIKit
import FloatingPanel

class AboutViewController: UIViewController{

    @IBOutlet weak var tableview: UITableView!
    lazy var presenter = AboutPresenter(delegate: self)
    var videoList: [VideoModel.Item] = []
    var fpc: FloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        configFloatingPanel()
        
        Task {
            await presenter.getVideo()
        }
        
    }
    
    //Primer paso es configurar la tableView
    func configTableView(){
        //============= METODO TRADICIONAL DE REGISTRAR CELDAS =================
//        let nibVideos = UINib(nibName: "\(VideoCell.self)", bundle: nil)
//        // segundo paso es registrar la celda
//        tableview.register(nibVideos, forCellReuseIdentifier: "\(VideoCell.self)")
        // =================== FIN METODO TRADICIONAL DE REGISTRAR CELDAS ================
        
        // =================== USANDO LA EXTENSION DE TABLEVIEW PARA REGISTRAR CELDAS ================
        tableview.register(cell: VideoCell.self)
        
        //tercer paso crear el delegate y el datasource
        tableview.separatorColor = .clear
        tableview.delegate = self
        tableview.dataSource = self
    }
    
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
        
        cell.didTapDostsButton = {[weak self ]in
            self?.configButtonSheet()
        }
        cell.configCell(model: video)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var videoId : String = ""
        
        videoId = videoList[indexPath.row].id ?? ""
        
        presentViewPanel(videoId)
        
    }
    
}

extension AboutViewController: AboutViewProtocol {
    func getVideos(videoList: [VideoModel.Item]) {
        //self.videoList es la varibale que seteamos arriba, que es tipo videomodel y que espera un arreglo vacio
        self.videoList = videoList
        tableview.reloadData()
    }
    
// Mostramos mas opciones para cuando se precionen los tres puntos de cada video
    func configButtonSheet() {
        let vc = BottonSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}


extension AboutViewController: FloatingPanelControllerDelegate{
    func presentViewPanel(_ videoId:String){
        
        let contentVC = PlayVideoViewController()
        contentVC.videoId = videoId
        fpc?.set(contentViewController: contentVC)
        if let fpc = fpc{
            present(fpc, animated: true)
        }
    }
    
    func configFloatingPanel() {
        fpc = FloatingPanelController(delegate: self)
        fpc?.isRemovalInteractionEnabled = true
        fpc?.surfaceView.grabberHandle.isHidden = true
        fpc?.layout = MyFloatingPanelLayout()
        fpc?.surfaceView.contentPadding = .init(top: -40, left: 0, bottom: -40, right: 0)
    }
    
    func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
        
    }
    
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        if targetState.pointee != .full {
            //todo
            
        } else {
            //todo
            
        }
    }
}
