//
//  HomeController.swift
//  WLMovieMania
//
//  Created by Dhall, Gautam on 4/21/17.
//  Copyright © 2017 GD. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift


class HomeController: UITableViewController,UISearchBarDelegate {
    
    // MARK: - Properties
    var movies = Variable([Movie]())
    
    var currentPage = 1
    var totalPages = 1
    var currentSearchText = ""
    var isLoading = false
    var detailViewController: DetailController? = nil
    // searchDisplayController was deprecated in iOS 8
    let searchController = UISearchController(searchResultsController: nil)
    
    let disposeBag = DisposeBag()
    
    
    // MARK: - View Setup
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        
        configureMoviesObserver()
        
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search movie titles e.g. 'limit' results below"
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.separatorStyle = .none
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailController
        }
        
        OverlayProgress.shared.show(self)
        fireService("limit")
        
    }
    
    func configureMoviesObserver()
    {
        movies.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            
            cell.textLabel!.text = element.title
            cell.detailTextLabel!.text = element.overview
            
            }
            .disposed(by: disposeBag)
        
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        OverlayProgress.shared.refresh(self)
    }
    
    func fireService(_ txt:String, _ page:Int = 1)  {
        
        currentSearchText = txt.lowercased()
        currentPage = page
        self.isLoading = true
        MovieDBAPIService.searchRequest(currentSearchText, page: page) { (data) in
            let dict:MovieDBAPIService = data()
            OverlayProgress.shared.hide(self)
            self.isLoading = false
            if dict.success == true
            {
                self.totalPages = dict.total_pages
                DispatchQueue.main.sync {
                    if self.currentPage != 1
                    {
                        self.movies.value.append(contentsOf: dict.results)
                    }
                    else
                    {
                        self.movies.value = dict.results
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    // requirement says, to do search if its submitted/entered, so only implementing this delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchController.searchBar.text?.characters.count)! > 0
        {
            searchController.searchBar.placeholder = "search movie titles"
            OverlayProgress.shared.show(self)
            fireService(searchController.searchBar.text!)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let actualPosition = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height - UIScreen.main.bounds.size.height - 200
        if (actualPosition >= contentHeight && currentPage < totalPages && !isLoading && !OverlayProgress.shared.isShowing)
        {
            currentPage += 1
            OverlayProgress.shared.show(self)
            fireService(currentSearchText,currentPage)
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let m = movies.value[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailController
                controller.detail = m
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
}
