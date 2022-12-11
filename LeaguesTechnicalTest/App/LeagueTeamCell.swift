//
//  LeagueTeamCell.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import UIKit
import Combine

class LeagueTeamCell: UICollectionViewCell {
    private let teamImageView = UIImageView()
    private var cancellables = Set<AnyCancellable>()
    
    func setContent(viewModel: LeagueTeamCellViewModelType) {
        self.teamImageView.image = viewModel.image.value
        
        viewModel.image.sink { [weak self] image in
            guard let self = self else { return }
            self.teamImageView.image = image
            self.reloadInputViews()
        }.store(in: &self.cancellables)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.teamImageView.translatesAutoresizingMaskIntoConstraints = false
        self.teamImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.teamImageView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            self.teamImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.teamImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.teamImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.teamImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
}
