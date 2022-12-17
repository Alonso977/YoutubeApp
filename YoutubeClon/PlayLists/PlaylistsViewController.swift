//
//  PlaylistsViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 16/11/22.
//

import UIKit

class PlaylistsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var playList: [PlayListModel.Items] = []
    lazy var presenter = PlaylistPresenter(delegate: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableview()
        
        Task {
            await presenter.getPlaylists()
        }
        
    }
    
    //configurando la tableview
    func configTableview() {
        //crear la celda y registrarla
        tableview.register(cell: PlaylistCell.self)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
}

extension PlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist = playList[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: PlaylistCell.self, for: indexPath)
        
        cell.didTapDostsButton = {[weak self] in
            self?.configButtonSheet()
        }
        cell.configCell(model: playlist)
        return cell
    }
}

extension PlaylistsViewController: PlaylistViewProtocol{
    func getPlaylists(playList: [PlayListModel.Items]) {
        self.playList = playList
        tableview.reloadData()
    }
    
    // funcion para mas acciones de cada playlist
    func configButtonSheet() {
        let vc = BottonSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
}
