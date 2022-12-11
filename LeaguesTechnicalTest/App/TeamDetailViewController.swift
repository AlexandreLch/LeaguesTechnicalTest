//
//  TeamDetailViewController.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import UIKit
import Combine

// MARK: - TeamDetailViewController
class TeamDetailViewController: UIViewController {
    
    // MARK: Private properties
    private let viewModel: TeamDetailViewModelType
    private var cancellables = Set<AnyCancellable>()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bannerImageView = UIImageView()
    private let countryLabel = UILabel()
    private let leagueLabel = UILabel()
    private let teamDescriptionLabel = UILabel()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.setup()
    }
    
    init(viewModel: TeamDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    private func setupLayout() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        for view in [self.bannerImageView, self.countryLabel, self.leagueLabel, self.teamDescriptionLabel] {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(view)
        }
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        constraints.append(contentsOf: [
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
        
        constraints.append(contentsOf: [
            self.bannerImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.bannerImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            self.bannerImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4),
            self.bannerImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        constraints.append(contentsOf: [
            self.countryLabel.topAnchor.constraint(equalTo: self.bannerImageView.bottomAnchor, constant: 4),
            self.countryLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4)
        ])
        
        constraints.append(contentsOf: [
            self.leagueLabel.topAnchor.constraint(equalTo: self.countryLabel.bottomAnchor, constant: 8),
            self.leagueLabel.leadingAnchor.constraint(equalTo: self.countryLabel.leadingAnchor)
        ])
        
        constraints.append(contentsOf: [
            self.teamDescriptionLabel.topAnchor.constraint(equalTo: self.leagueLabel.bottomAnchor, constant: 8),
            self.teamDescriptionLabel.leadingAnchor.constraint(equalTo: self.countryLabel.leadingAnchor),
            self.teamDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4),
            self.teamDescriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupStyle() {
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        
        self.bannerImageView.contentMode = .scaleAspectFit
        
        self.countryLabel.font = self.countryLabel.font.withSize(12)
        
        self.leagueLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.teamDescriptionLabel.font = self.teamDescriptionLabel.font.withSize(16)
        self.teamDescriptionLabel.numberOfLines = 0
    }
    
    private func setupViewModel() {
        self.title = self.viewModel.title
        self.countryLabel.text = self.viewModel.country
        self.leagueLabel.text = self.viewModel.league
        self.teamDescriptionLabel.text = self.viewModel.description
        
        self.viewModel.banner.sink { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.bannerImageView.image = image
                self.view.layoutSubviews()
            }
        }.store(in: &self.cancellables)
    }

    private func setup() {
        self.setupViewModel()
        self.setupStyle()
        self.setupLayout()
    }
}
