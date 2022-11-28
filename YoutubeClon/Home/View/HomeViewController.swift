//
//  HomeViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 16/11/22.
//

import UIKit
import CoreMedia

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    
    // Alonso: - Conectando al presenter
    lazy var presenter = HomePresenter(delegate: self)
    private var objectList : [[Any]] = []
    private var sectionTitleList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        Task {
            await presenter.getHomeObjects()
        }
    }
    
    // Alonso: - Registramos el tableView
    func configTableView() {
        let nibChannel = UINib(nibName: "\(ChannelCell.self)", bundle: nil)
        tableViewHome.register(nibChannel, forCellReuseIdentifier: "\(ChannelCell.self)")
        
        let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        tableViewHome.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
        
        let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        tableViewHome.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
        
        tableViewHome.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")
        
        
        // Registramos la celda y quitamos los separadores
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorColor = .clear
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = objectList[indexPath.section]
        
        // Alonso: - valido lo que si channel se puede convertir en Modelo
        if let channel = item as? [ChannelModel.Items] {
            // Alonso: - si lo puede convertir entoces que cree una nueva celda
            guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCell.self)", for: indexPath) as? ChannelCell else {
                return UITableViewCell()
            }
            // Alonso: - Desde aqui llamo la funcion que cree en el archivo de Channel
            channelCell.configCell(model: channel[indexPath.row])
            return channelCell
            
        }else if let playlistItems = item as? [PlaylistItemsModel.Item] {
            // Alonso: - si lo puede convertir entoces que cree una nueva celda
            guard let playlistItemsCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                return UITableViewCell()
            }
            playlistItemsCell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            return playlistItemsCell
            
        }else if let videos = item as? [VideoModel.Item] {
            // Alonso: - si lo puede convertir entoces que cree una nueva celda
            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
                return UITableViewCell()
            }
            videoCell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
            videoCell.configCell(model: videos[indexPath.row])
            return videoCell
            
        }else if let playlist = item as? [PlayListModel.Items] {
            // Alonso: - si lo puede convertir entoces que cree una nueva celda
            guard let playlistcell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
                return UITableViewCell()
            }
            
            playlistcell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
            playlistcell.configCell(model: playlist[indexPath.row])
            return playlistcell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // dandole un tamaño a la celda para que no se distorcione
        if indexPath.section == 1 || indexPath.section == 2 {
            return 95.0
        }
        return UITableView.automaticDimension
    }
    
    //funcion para agregar titulos a cada seccion
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView else {
            return nil
        }
        sectionView.title.text = sectionTitleList[section]
        sectionView.configView()
        return sectionView
    }
 
    // Alonso: - Metodo para cuando se precione el boton de mas opciones
    func configButtonSheet() {
        let vc = BottonSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
}

extension HomeViewController : HomeViewProtocol{
    
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
        tableViewHome.reloadData()
    }
    
}
