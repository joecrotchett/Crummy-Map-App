//
//  SearchResultsHeaderView.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/22/21.
//

import UIKit

final class SearchResultsHeaderView: UITableViewHeaderFooterView {
    
    private enum CellMetrics {
        static let horizontalMargin: CGFloat = 15
        static let verticalMargin: CGFloat = 20
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontForContentSizeCategory = true
        label.text = "PLACES"
        return label
    }()
    
    private let separator = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAccessiblity()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported")
    }
    
    // MARK: Private
    
    private func configureAccessiblity() {
        // Accessiblity
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: UIContentSizeCategory.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: UIAccessibility.boldTextStatusDidChangeNotification, object: nil)
        
        // Styling
        updateFonts()
        updateColors()
    }
    
    @objc private func updateFonts() {
        let font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.font = font
    }
    
    private func updateColors() {
        contentView.backgroundColor = .black
        titleLabel.textColor = StyleGuide.Colors.alamoYellow
        separator.backgroundColor = .lightGray
    }
    
    private func configureLayout() {
    
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellMetrics.horizontalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CellMetrics.horizontalMargin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellMetrics.verticalMargin),
        ])
        
        contentView.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
