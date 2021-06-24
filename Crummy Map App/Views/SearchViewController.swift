//
//  SearchViewController.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/22/21.
//

//
//  SearchResultDetailViewController.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/22/21.
//

import UIKit

final class SearchViewController: NiblessViewController {
    
    private var searchTask: DispatchWorkItem? // Used for throttling requests
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let dataManager = SearchResultsDataManager()
    private let searchResultsViewController = SearchResultsViewController()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Crummy"
        label.font = UIFont.init(name: "Rockwell-Bold", size: 58)
        
        // This serves as a logo, and should not be voiced
        label.isAccessibilityElement = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Map App"
        label.font = UIFont.init(name: "HiraginoSans-W6", size: 17)
        
        // This serves as a logo, and should not be voiced
        label.isAccessibilityElement = false
        return label
    }()
    
    override init() {
        super.init()
        configureLayout()
        title = "Search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        updateColors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationbar = self.navigationController?.navigationBar {
            navigationbar.barTintColor = StyleGuide.Colors.alamoYellow
            navigationbar.tintColor = UIColor.black
        }
    }
    
    // MARK: Private
    
    private func configureSearchController() {
        searchResultsViewController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureLayout() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(textStackView)
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateColors() {
        view.backgroundColor = .black
        activityIndicator.color = StyleGuide.Colors.alamoYellow
        titleLabel.textColor = StyleGuide.Colors.alamoYellow
        subtitleLabel.textColor = .lightGray//StyleGuide.Colors.gray0
    }
}

// MARK: UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // OpenGate minimum valid query is two characters
        guard let term = searchController.searchBar.text, term.count > 1 else {
            let vc = searchController.searchResultsController as? SearchResultsViewController
            vc?.show(results: [])
            vc?.showLoading()
            return
        }
        
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.dataManager.search(for: term) { result in
                let vc = searchController.searchResultsController as? SearchResultsViewController
                switch result {
                case .success(let searchResults):
                    if searchResults.isEmpty {
                        vc?.showNoResults()
                    } else {
                        vc?.show(results: searchResults)
                    }

                case .failure(let error):
                    vc?.show(error: error.localizedDescription)
                }
            }
        }
        
        // Throttle requests to only one per second
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
    }
}

// MARK: SearchResultsViewControllerDelegate

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ viewController: SearchResultsViewController, didSelectSearchResult searchResult: Place) {
        if let mapURL = searchResult.mapURL {
            let detailViewController = SearchResultDetailViewController(with: mapURL)
            detailViewController.title = searchResult.city
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

