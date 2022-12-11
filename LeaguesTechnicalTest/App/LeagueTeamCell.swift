//
//  LeagueTeamCell.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import UIKit
import Combine

class LeagueTeamCell: UICollectionViewCell {
    private let placeHolderImageView = UIImageView(image: UIImage(named: "placeholder_sport"))
    private let teamImageView = UIImageView()
    private var cancellables = Set<AnyCancellable>()
    var viewModel: LeagueTeamCellViewModelType?
    
    func setContent(viewModel: LeagueTeamCellViewModelType) {
        viewModel.image.sink { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.placeHolderImageView.alpha = 0
                self.teamImageView.alpha = 1
                self.teamImageView.image = image
            }
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
        self.teamImageView.alpha = 0
        self.placeHolderImageView.contentMode = .scaleAspectFit
        self.placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.placeHolderImageView)
        self.contentView.addSubview(self.teamImageView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            self.placeHolderImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.placeHolderImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.placeHolderImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.placeHolderImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        constraints.append(contentsOf: [
            self.teamImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.teamImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.teamImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.teamImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
}
