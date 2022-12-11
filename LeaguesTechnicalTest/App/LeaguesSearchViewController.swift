//
//  LeaguesSearchViewController.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 10/12/2022.
//

import UIKit
import Combine

// MARK: - LeaguesSearchViewController
class LeaguesSearchViewController: UIViewController {
    
    // MARK: Private properties
    private let viewModel: LeaguesSearchViewModelType
    private var cancellables = Set<AnyCancellable>()
    let downloadSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // MARK: Public properties
    let searchController: UISearchController
    let teamsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let searchResultTableView = UITableView()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        
        self.setupResultTableView()
        self.setupSearchController()
        self.setupTeamsCollectionView()
        self.setupObservables()
        self.setupSpinner()
    }
    
    init(viewModel: LeaguesSearchViewModelType) {
        self.viewModel = viewModel
        self.searchController = UISearchController(searchResultsController: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    private func setupSpinner() {
        self.downloadSpinner.translatesAutoresizingMaskIntoConstraints = false
        self.downloadSpinner.hidesWhenStopped = true
        
        self.view.addSubview(self.downloadSpinner)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            self.downloadSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.downloadSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupResultTableView() {
        self.searchResultTableView.backgroundColor = .clear
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.alpha = 0
        self.searchResultTableView.estimatedRowHeight = 50.0
        self.searchResultTableView.rowHeight = UITableView.automaticDimension
        self.searchResultTableView.contentInsetAdjustmentBehavior = .never
        self.searchResultTableView.registerCellClass(FilteredLeagueCell.self)
        self.searchResultTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.searchResultTableView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            self.searchResultTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.searchResultTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.searchResultTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.searchResultTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupObservables() {
        self.viewModel.displayedFilteredLeagues.sink { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }.store(in: &self.cancellables)
        
        self.viewModel.teamImages.sink { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.teamsCollectionView.reloadData()
            }
        }.store(in: &self.cancellables)
        
        self.viewModel.shouldShowSpinner.sink { [weak self] shouldShowSpinner in
            guard let self = self else { return }
            if shouldShowSpinner {
                DispatchQueue.main.async {
                    self.downloadSpinner.startAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.downloadSpinner.stopAnimating()
                }

            }
        }.store(in: &self.cancellables)
    }
    
    private func setupTeamsCollectionView() {
        self.teamsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.teamsCollectionView.alpha = 0
        self.view.addSubview(self.teamsCollectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 150, height: 150)
        
        self.teamsCollectionView.setCollectionViewLayout(layout, animated: false)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            self.teamsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.teamsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.teamsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.teamsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        self.teamsCollectionView.registerCellClass(LeagueTeamCell.self)
        self.teamsCollectionView.delegate = self
        self.teamsCollectionView.dataSource = self
    }
    
    private func showTeamCollectionView() {
        UIView.animate(withDuration: 0.3) {
            self.teamsCollectionView.alpha = 1
        }
    }
    
    private func hideTeamCollectionView() {
        UIView.animate(withDuration: 0.3) {
            self.teamsCollectionView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.teamsCollectionView.reloadData()
        }

    }
    
    private func showSearchTableView() {
        UIView.animate(withDuration: 0.3) {
            self.searchResultTableView.alpha = 1
        }
    }
    
    private func hideSearchTableView() {
        UIView.animate(withDuration: 0.3) {
            self.searchResultTableView.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.searchResultTableView.reloadData()
        }

    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search by league"
        self.searchController.searchBar.autocapitalizationType = .words
        self.searchController.searchBar.returnKeyType = .done
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.searchResultTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.searchResultTableView.contentInset = .zero
    }
}

// MARK: - UISearchResultsUpdating, UISearchControllerDelegate & UISearchBarDelegate
extension LeaguesSearchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              !text.isEmpty else {
            self.viewModel.resetTableViewData()
            self.searchResultTableView.reloadData()
            return
        }
        guard let textCount = searchController.searchBar.text?.count,
              textCount >= 3 else { return }
        self.viewModel.updateTableViewData(with: text)
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        self.showSearchTableView()
        self.hideTeamCollectionView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.resetTableViewData()
        self.hideSearchTableView()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LeaguesSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.displayedFilteredLeagues.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FilteredLeagueCell.self)
        cell.setContent(title: self.viewModel.displayedFilteredLeagues.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.updateTeamsByLeague(league: self.viewModel.displayedFilteredLeagues.value[indexPath.row])
        self.searchController.isActive = false
        self.showTeamCollectionView()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LeaguesSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.teamImages.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LeagueTeamCell.self, forIndexPath: indexPath)
        if let image = self.viewModel.teamImages.value[indexPath.row] {
            cell.setContent(image: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.getTeam(at: indexPath.row) { [weak self] team in
            guard let self = self else { return }
            guard let team = team else { return }
            self.viewModel.didClickOnCollectionView()
            self.hideTeamCollectionView()
            let vm = TeamDetailViewModel(team: team, imageDownloadManager: ImageDownloadManager())
            let vc = TeamDetailViewController(viewModel: vm)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
