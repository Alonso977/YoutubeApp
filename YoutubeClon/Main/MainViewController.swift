//
//  MainViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 15/11/22.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var tabsView: TabsView!
    var rootPageViewController: RootPageViewController!
    //opciones de navegacion del menu
    private var option: [String] = ["HOME","VIDEOS","PLAYLIST","CHANNEL","ABOUT"]
    var currentPageIndex : Int = 0{
        willSet{
            print("willset: \(currentPageIndex)")
            let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIndex, section: 0))
            cell?.isSelected = false
        }
        didSet{
            print("didset: \(currentPageIndex)")
            if let _ = rootPageViewController {
                rootPageViewController.currentPage = currentPageIndex
                let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIndex, section: 0))
                cell?.isSelected = true
            }
        }
    }
    
    var didTapOption: Bool = false{
        
        didSet{
            if didTapOption{
                tabsView.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.35) {
                    self.didTapOption.toggle()
                    self.tabsView.isUserInteractionEnabled = true
                }
            }
        }
        
    }
    
    var prevPercent : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
   
        configNavigationBar()
        tabsView.buildView(delegate: self, options: option)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootPageViewController {
            
            // aqui le estamos pasando el indice de cada controlador
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }
    
    // Alonso: - Como estoy heredando todos los metodos del BaseViewController si quiero darle funcionalidad a los botones lo que haria es lo siguiente
    override func dotsButtonPressed() {
        
    }
    
}

extension MainViewController: RootPageProtocol {
    func currentPage(_ index: Int) {
        print("Current page: ", index)
        
        currentPageIndex = index
        tabsView.selectedItem = IndexPath(item: index, section: 0)
    }
    
    func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int) {
        if percent == 0.0 || didTapOption{
            return
        }
        
        let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
        
        if direction == .goingRight {
            if index == option.count-1 {return}
            
            let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index+1, section: 0))
            
            let calculateNewLeading = currentCell!.frame.origin.x + (currentCell!.frame.width * percent)
            let newWidth = (prevPercent < percent) ? nextCell?.frame.width : currentCell?.frame.width
            
            updateUnderlineConstraints(calculateNewLeading, newWidth!)
        }else {
            if index == 0 {return}
            
            let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index-1, section: 0))
            
            let calculateNewLeading = currentCell!.frame.origin.x - (nextCell!.frame.width * percent)
            let newWidht = (prevPercent) < percent ? nextCell?.frame.width : currentCell?.frame.width
            
            updateUnderlineConstraints(calculateNewLeading, newWidht!)
        }
        
        prevPercent = percent
    }
    
    func updateUnderlineConstraints(_ leading: CGFloat, _ width: CGFloat){
        tabsView.leadingConstraint?.constant = leading
        tabsView.widthConstraint?.constant = width
        tabsView.layoutIfNeeded()
    }
    
}

extension MainViewController: TabsViewProtocol {
    func didSelectOption(index: Int) {
        print("option: ", index)
        
        didTapOption = true
        
        let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))!
        tabsView.updateUnderline(xOrigin: currentCell.frame.origin.x, width: currentCell.frame.width)
        
        
        var direction : UIPageViewController.NavigationDirection = .forward
        if index < currentPageIndex{
            direction = .reverse
        }
        rootPageViewController.setViewControllerFromIndex(index: index, direction: direction)
        
        currentPageIndex = index
    }
}
