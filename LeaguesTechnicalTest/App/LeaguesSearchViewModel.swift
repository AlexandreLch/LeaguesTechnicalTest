//
//  LeaguesSearchViewModel.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 10/12/2022.
//

import Foundation
import Combine

protocol LeaguesSearchViewModelType {
    var displayedFilteredLeagues: CurrentValueSubject<[String], Never> { get }
    var teams: CurrentValueSubject<[Team], Never> { get }
    
    func updateTeamsByLeague(league: String)
    func updateTableViewData(with filter: String)
    func resetTableViewData()
}

class LeaguesSearchViewModel: LeaguesSearchViewModelType {
    private var leagues: [League] = []
    private let leagueManager: LeagueManagerType
    private var availableLeagueSearchFilter: [String] = []
    var displayedFilteredLeagues = CurrentValueSubject<[String], Never>([])
    var teams = CurrentValueSubject<[Team], Never>([])
    
    init(leagueManager: LeagueManagerType) {
        self.leagueManager = leagueManager
        self.getAllLeague()
    }
    
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
    
    func updateTableViewData(with filter: String) {
        self.displayedFilteredLeagues.send(availableLeagueSearchFilter.filter { $0.contains(filter) })
    }
    
    func resetTableViewData() {
        self.displayedFilteredLeagues.value = []
    }
    
    func updateTeamsByLeague(league: String) {
        self.getTeamsByLeague(league: league)
    }
    
    private func getTeamsByLeague(league: String) {
        self.leagueManager.fetchTeamsFromLeague(params: league) { teams in
            self.teams.send(teams)
        } failure: { error in
            print(error)
        }
    }
}
