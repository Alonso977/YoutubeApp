//
//  HomeViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 16/11/22.
//

import UIKit
import CoreMedia
import FloatingPanel

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!
    
    // Alonso: - Conectando al presenter
    lazy var presenter = HomePresenter(delegate: self)
    private var objectList : [[Any]] = []
    private var sectionTitleList: [String] = []
    var fpc: FloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configFloatingPanel()
        
        Task {
            await presenter.getHomeObjects()
        }
    }
    
    // Alonso: - Registramos el tableView
    func configTableView() {
        // =================== METODO TRADICIONAL DE REGISTRAR CELDAS ================
        //        let nibChannel = UINib(nibName: "\(ChannelCell.self)", bundle: nil)
        //        tableViewHome.register(nibChannel, forCellReuseIdentifier: "\(ChannelCell.self)")
        //
        //        let nibVideo = UINib(nibName: "\(VideoCell.self)", bundle: nil)
        //        tableViewHome.register(nibVideo, forCellReuseIdentifier: "\(VideoCell.self)")
        //
        //        let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        //        tableViewHome.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
        //
        //        tableViewHome.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: "\(SectionTitleView.self)")
        // =================== FIN METODO TRADICIONAL DE REGISTRAR CELDAS ================
        
        // =================== USANDO LA EXTENSION DE TABLEVIEW PARA REGISTRAR CELDAS ================
        tableViewHome.register(cell: ChannelCell.self)
        tableViewHome.register(cell: VideoCell.self)
        tableViewHome.register(cell: PlaylistCell.self)
        tableViewHome.registerFromClass(headerFooterView: SectionTitleView.self)
        
        // Registramos la celda y quitamos los separadores
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorColor = .clear
        tableViewHome.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: -80, right: 0)
    }
    
    //funcion para ocultar el navbar
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -5 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 5 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
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
            // =================== USANDO LA EXTENSION DE TABLEVIEW PARA REGISTRAR CELDAS ================
            let channelCell = tableView.dequeueReusableCell(for: ChannelCell.self, for: indexPath)
            // =================== USANDO LA FORMA TRADICIONAL PARA REGISTRAR CELDAS ================
//            guard let channelCell = tableView.dequeueReusableCell(withIdentifier: "\(ChannelCell.self)", for: indexPath) as? ChannelCell else {
//                return UITableViewCell()
//            }
            // Alonso: - Desde aqui llamo la funcion que cree en el archivo de Channel
            channelCell.configCell(model: channel[indexPath.row])
            return channelCell
            
        }else if let playlistItems = item as? [PlaylistItemsModel.Item] {
            // Alonso: - si lo puede convertir entoces que cree una nueva celda
//            guard let playlistItemsCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
//                return UITableViewCell()
//            }
            let playlistItemsCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            
            playlistItemsCell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
            playlistItemsCell.configCell(model: playlistItems[indexPath.row])
            return playlistItemsCell
            
        }else if let videos = item as? [VideoModel.Item] {
            // Alonso: - si lo puede convertir entoces que cree una nueva celda
//            guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "\(VideoCell.self)", for: indexPath) as? VideoCell else {
//                return UITableViewCell()
//            }
            let videoCell = tableView.dequeueReusableCell(for: VideoCell.self, for: indexPath)
            videoCell.didTapDostsButton = {[weak self] in
                self?.configButtonSheet()
            }
            videoCell.configCell(model: videos[indexPath.row])
            return videoCell
            
        }else if let playlist = item as? [PlayListModel.Items] {
            // Alonso: - si lo puede convertir entoces que cree una nueva celda
//            guard let playlistcell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
//                return UITableViewCell()
//            }
            let playlistcell = tableView.dequeueReusableCell(for: PlaylistCell.self, for: indexPath)
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
//        guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SectionTitleView.self)") as? SectionTitleView else {
//            return nil
//        }
        let sectionView = tableView.dequeueReusableHeaderFooterView(for: SectionTitleView.self)
        
        sectionView.title.text = sectionTitleList[section]
        sectionView.configView()
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = objectList[indexPath.section]
        var videoId : String = ""
        
        if let playListItem = item as? [PlaylistItemsModel.Item] {
            videoId = playListItem[indexPath.row].contentDetails?.videoId ?? ""
            
        } else if let videos = item as? [VideoModel.Item] {
            videoId = videos[indexPath.row].id ?? ""
        } else {
            return
        }
        
        presentViewPanel(videoId)
        
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

extension HomeViewController: FloatingPanelControllerDelegate{
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

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
//        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 60.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}
