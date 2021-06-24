//
//  SearchViewController.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/21/21.
//

import UIKit

// MARK: SearchResultsViewControllerDelegate

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewController(_ viewController: SearchResultsViewController, didSelectSearchResult searchResult: Place)
}

// MARK: SearchResultsViewController

final class SearchResultsViewController: NiblessViewController {
    
    private enum ViewMetrics {
        static let horizontalMargin: CGFloat = 20
    }
    
    private let headerViewReuseIdentifier = "SearchResultsHeaderView"
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Sorry!"
        label.font = UIFont.init(name: "SavoyeLetPlain", size: 58)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.init(name: "HiraginoSans-W6", size: 17)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorColor = .lightGray
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        tableView.register(SearchResultsHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var results = [Place]()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        updateColors()
    }
    
    // MARK: Public Interface
    
    func showLoading() {
        tableView.isHidden = true
        textStackView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func show(error: String) {
        tableView.isHidden = true
        activityIndicator.stopAnimating()
        
        textStackView.isHidden = false
        titleLabel.text = "Whoops!"
        subtitleLabel.text = error
    }
    
    func show(results: [Place]) {
        self.results = results
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func showNoResults() {
        tableView.isHidden = true
        activityIndicator.stopAnimating()
        
        textStackView.isHidden = false
        titleLabel.text = "No Results Found"
        subtitleLabel.text = nil
    }
    
    // MARK: Private
    
    private func configureLayout() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(textStackView)
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewMetrics.horizontalMargin),
            textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewMetrics.horizontalMargin),
            textStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func updateColors() {
        view.backgroundColor = .black
        activityIndicator.color = StyleGuide.Colors.alamoYellow
        titleLabel.textColor = .white
        subtitleLabel.textColor = StyleGuide.Colors.alamoYellow
    }
}
    
// MARK: UITableViewDataSource

extension SearchResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeueReusableCell(for: indexPath)
        let result = results[indexPath.row]
        cell.configure(with: result)
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = results[indexPath.row]
        delegate?.searchResultsViewController(self, didSelectSearchResult: searchResult)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard !results.isEmpty else {
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView? {
        guard !results.isEmpty else {
            return nil
        }
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewReuseIdentifier) as? SearchResultsHeaderView
    }
}
