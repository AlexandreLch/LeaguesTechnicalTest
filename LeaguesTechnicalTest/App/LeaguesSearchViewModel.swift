//
//  LeaguesSearchViewModel.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 10/12/2022.
//

import Foundation
import Combine
import UIKit

// MARK: - LeaguesSearchViewModelType
protocol LeaguesSearchViewModelType {
    var displayedFilteredLeagues: CurrentValueSubject<[String], Never> { get }
    var teams: [Team] { get }
    var teamDetail: CurrentValueSubject<Team?, Never> { get }
    var teamImages: CurrentValueSubject<[UIImage?], Never> { get }
    var shouldShowSpinner: CurrentValueSubject<Bool, Never> { get }
    
    func updateTeamsByLeague(league: String)
    func updateTableViewData(with filter: String)
    func resetTableViewData()
    func getTeam(at index: Int, completion: @escaping ((Team?) -> Void))
    func didClickOnCollectionView()
}

// MARK: - LeaguesSearchViewModel
class LeaguesSearchViewModel: LeaguesSearchViewModelType {
    
    // MARK: Private properties
    private var leagues: [League] = []
    private let leagueManager: LeagueManagerType
    private var availableLeagueSearchFilter: [String] = []
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Public properties
    var displayedFilteredLeagues = CurrentValueSubject<[String], Never>([])
    var teams: [Team] = []
    var teamDetail = CurrentValueSubject<Team?, Never>(nil)
    var teamImages = CurrentValueSubject<[UIImage?], Never>([])
    var shouldShowSpinner = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: Life Cycle
    init(leagueManager: LeagueManagerType) {
        self.leagueManager = leagueManager
        self.getAllLeague()
    }
    
    // MARK: Private methods
    private func getAllLeague() {
        self.leagueManager.fetchAllLeague { [weak self] league in
            guard let self = self else { return }
            self.leagues = league
            league.forEach {
                if !self.availableLeagueSearchFilter.contains($0.strLeague) {
                    self.availableLeagueSearchFilter.append($0.strLeague)
                }
            }
        } failure: { error in
            print(error)
        }
    }
    
    /// Downloading every badges for displayed teams and adding them to collectionView datasources as they are downloaded
    private func downloadImages(index: Int = 0) {
        self.shouldShowSpinner.value = true
        let imageToDownload = self.teams.map { $0.strTeamBadge }
        guard index < imageToDownload.count else {
            self.shouldShowSpinner.value = false
            return
        }
        guard let urlString = imageToDownload[index],
            let url = URL(string: urlString) else {
            self.teamImages.value.append(UIImage(named: "placeholder_sport"))
            self.downloadImages(index: index + 1)
            return
        }
        ImageDownloadManager.shared.imageWith(url) { image in
            self.teamImages.value.append(image)
            self.downloadImages(index: index + 1)
        }
    }
    
    /// Display teams by league in reverse alphabetical order and only showing one team out of two and keeping team badges urlstring for future download
    /// - Parameter league: The league name used to fetch teams that belongs to it
    private func getTeamsByLeague(league: String) {
        self.teamImages.value = []
        self.leagueManager.fetchTeamsFromLeague(params: league) { teams in
            var displayedTeams: [Team] = []
            for i in 0...teams.count - 1 {
                if i % 2 == 0 {
                    displayedTeams.append(teams[i])
                }
            }
            let sortedTeams = displayedTeams.sorted { $0.strTeam > $1.strTeam }
            self.teams = sortedTeams
            self.downloadImages()
        } failure: { error in
            print(error)
        }
    }
    
    // MARK: Public methods
    func getTeam(at index: Int, completion: @escaping ((Team?) -> Void)) {
        self.leagueManager.featchTeamDetail(params: self.teams[index].strTeam) { teams in
            DispatchQueue.main.async {
                completion(teams.first)
            }
        } failure: { error in
            print(error)
        }
    }
    
    func updateTableViewData(with filter: String) {
        self.displayedFilteredLeagues.send(availableLeagueSearchFilter.filter { $0.contains(filter) })
    }
    
    func resetTableViewData() {
        self.displayedFilteredLeagues.value = []
    }
    
    func updateTeamsByLeague(league: String) {
        self.getTeamsByLeague(league: league)
    }
    
    func didClickOnCollectionView() {
        self.shouldShowSpinner.value = false
    }
}
