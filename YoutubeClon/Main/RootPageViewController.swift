//
//  RootPageViewController.swift
//  YoutubeClon
//
//  Created by Alonso Alas on 15/11/22.
//

import UIKit

enum ScrollDirection{
    case goingLeft
    case goingRight
}

// Alonso: - con este protocolo lo que estoy haciendo es permitiendo que otros controladores tengan acceson a ciertos
// atributos o funciones de este controller
protocol RootPageProtocol: AnyObject {
    func currentPage(_ index: Int)
    func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int)
}



class RootPageViewController: UIPageViewController {
    
    var subViewControllers = [UIViewController]()
    var currentIndex: Int = 0
    weak var delegateRoot: RootPageProtocol?
    var startOffset:CGFloat = 0.0
    var currentPage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        delegateRoot?.currentPage(0)
        setUpViewController()
        setScrollViewDelegate()
    }
    
    // Alonso: - Con esta funcion le digo al root page view controller cuantas paginas quiero mostrar
    private func setUpViewController() {
        subViewControllers = [
            HomeViewController(),
            VideosViewController(),
            PlaylistsViewController(),
            ChannelViewController(),
            AboutViewController()
        ]
        
        // Alonso: - de esta forma voy a saber en que pantalla estoy
        // Alonso: - Asignandole un ID a cada uno de los controladores que tengo
        _ = subViewControllers.enumerated().map({$0.element.view.tag = $0.offset})
        
        // Alonso: - Solo cargue la pagina y va a cargar la primera pantalla que sera home, la direccion hacia adelante
        setViewControllerFromIndex(index: 0, direction: .forward)
    }
    
    func setViewControllerFromIndex(index: Int, direction: NavigationDirection, animated: Bool = true) {
        // Alonso: - Este metodo se encarga de navegar entre vistas
        setViewControllers([subViewControllers[index]], direction: direction, animated: animated)
    }
    
    private func setScrollViewDelegate(){
        guard let scrollView = view.subviews.filter({$0 is UIScrollView}).first as? UIScrollView else {return}
        scrollView.delegate = self
    }
    
}

extension RootPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // Alonso: - Con este metodo se le dice al page view controller la cantidad de views que tengo
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    // Este metodo sirve para mostrar la pantalla anterior
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if index <= 0 {
            return nil
        }
        return subViewControllers[index-1]
    }
    
    // Este metodo sirve para mostrar la pantalla siguiente
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        
        // DE ESTA FORMA SACO EL ULTIMO CONTROLLADOR DE LA LISTA
        if index >= (subViewControllers.count - 1) {
            return nil
        }
        return subViewControllers[index+1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("finished : ", finished)
        
        // Alonso: - de esta forma obtengo el tag que asigne arriba
        if let index = pageViewController.viewControllers?.first?.view.tag {
            currentIndex = index
            // buscamos en el delegate root la funcion current page y de esta forma podemos compartir el index a otros controladores
            delegateRoot?.currentPage(index)
        }
    }
}

extension RootPageViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
        print("startOffset: \(startOffset)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction = 0
        if startOffset < scrollView.contentOffset.x {
            direction = 1 //right
        }else if startOffset > scrollView.contentOffset.x{
            direction = -1 //left
        }
        
        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage / self.view.frame.width
        delegateRoot?.scrollDetails(direction: (direction == 1) ? .goingRight : .goingLeft, percent: percent, index: currentPage)
        
        print("percent ", percent)
        print("direction ", direction)
        
    }
    
}
