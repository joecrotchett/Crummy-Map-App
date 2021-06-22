//
//  SearchResultCell.swift
//  Crummy Map App
//
//  Created by Joe Crotchett on 6/21/21.
//
 
import UIKit

// MARK: SearchResultCell

@objc final class SearchResultCell: UITableViewCell {
    
    private enum CellMetrics {
        static let horizontalMargin: CGFloat = 20
        static let verticalMargin: CGFloat = 15
    }
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let accessoryDisclosureView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "disclosure")!.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initComplete()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComplete()
    }
    
    // MARK: Public Interface
    
    func configure(with place: Place) {
        countryLabel.text = place.country?.uppercased()
        addressLabel.text = place.streetAddress
    }
    
    // MARK: Private
    
    private func initComplete() {
        
        // Layout
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellMetrics.horizontalMargin),
            addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellMetrics.verticalMargin),
        ])
        
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countryLabel)
        NSLayoutConstraint.activate([
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellMetrics.horizontalMargin),
            countryLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellMetrics.verticalMargin)
        ])
        
        accessoryDisclosureView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(accessoryDisclosureView)
        NSLayoutConstraint.activate([
            accessoryDisclosureView.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: CellMetrics.horizontalMargin),
            accessoryDisclosureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CellMetrics.horizontalMargin),
            accessoryDisclosureView.widthAnchor.constraint(equalToConstant: 6),
            accessoryDisclosureView.heightAnchor.constraint(equalToConstant: 10),
            accessoryDisclosureView.centerYAnchor.constraint(equalTo: contentView .centerYAnchor)
        ])
        
        // Accessiblity
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: UIContentSizeCategory.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFonts), name: UIAccessibility.boldTextStatusDidChangeNotification, object: nil)
        
        // Styling
        updateFonts()
        updateColors()
    }
    
    @objc private func updateFonts() {
        let titleFont = UIFont.preferredFont(forTextStyle: .body)
        addressLabel.font = titleFont
        
        let subtitleFont = UIFont.preferredFont(forTextStyle: .caption1)
        countryLabel.font = subtitleFont
    }
    
    private func updateColors() {
        contentView.backgroundColor = .black
        addressLabel.textColor = .white
        countryLabel.textColor = StyleGuide.Colors.alamoYellow
        accessoryDisclosureView.tintColor = StyleGuide.Colors.alamoYellow
    }
}
