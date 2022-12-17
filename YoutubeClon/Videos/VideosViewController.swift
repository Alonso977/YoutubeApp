//
//  VideosViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 16/11/22.
//

import UIKit

class VideosViewController: UIViewController {

    @IBOutlet weak var tableViewVideos: UITableView!
    lazy var presenter = VideoPresenter(delegate: self)
    var videoList: [VideoModel.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        Task {
            await presenter.getVideos()
        }
        
    }
    
    // Alonso: - Configuramos el tableview
    func configTableView() {
//        // Alonso: - Registramos la celda
//        let nibVideos = UINib(nibName: "\(VideoCell.self)", bundle: nil)
//        tableViewVideos.register(nibVideos, forCellReuseIdentifier: "\(VideoCell.self)")
        
        //USANDO LA EXTENSION QUE CREE PARA TABLEVIEW PUEDO REEMPLAZAR LAS DOS LINEAS DE ARRIBA SOLO CON LA SIGUIENTE
        tableViewVideos.register(cell: VideoCell.self)
        
        tableViewVideos.separatorColor = .clear
        tableViewVideos.delegate = self
        tableViewVideos.dataSource = self
    }

}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videoList[indexPath.row]
        
        //USANDO LA EXTENSION QUE CREE PARA TABLEVIEW PUEDO REEMPLAZAR LAS DOS LINEAS DE ARRIBA SOLO CON LA SIGUIENTE
        let cell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else{
//            return UITableViewCell()
//        }
        cell.didTapDostsButton = {[weak self] in
            self?.configButtonSheet()
        }
        cell.configCell(model: video)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // dandole un tamaño a la celda para que no se distorcione
        return 95.0
    }
    
}

extension VideosViewController: VideosViewProtocol {
    func getVideos(videoList: [VideoModel.Item]) {
        self.videoList = videoList
        tableViewVideos.reloadData()
    }
    
    // Alonso: - Metodo para cuando se precione el boton de mas opciones
    func configButtonSheet() {
        let vc = BottonSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}
