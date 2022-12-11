//
//  FilteredLeagueCell.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import UIKit

// MARK: - FilteredLeagueCell
class FilteredLeagueCell: UITableViewCell {
    
    // MARK: Private properties
    private let leagueTitle = UILabel()
    
    
    // MARK: Public methods
    func setContent(title: String) {
        self.leagueTitle.text = title
    }
    
    // MARK: Private methods
    private func setupLayout() {
        self.backgroundColor = .clear
        self.leagueTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.leagueTitle)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            self.leagueTitle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.leagueTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
