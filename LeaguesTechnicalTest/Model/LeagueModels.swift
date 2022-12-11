//
//  LeagueModels.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 10/12/2022.
//

import Foundation

// MARK: - LeagueManagerType
protocol LeagueManagerType {
    func fetchAllLeague(success: @escaping (([League]) -> Void), failure: @escaping ((String) -> Void))
    func fetchTeamsFromLeague(params: String, success: @escaping (([Team]) -> Void), failure: @escaping ((String) -> Void))
    func featchTeamDetail(params: String, success: @escaping (([Team]) -> Void), failure: @escaping ((String) -> Void))
}

// MARK: - LeagueManager
class LeagueManager: LeagueManagerType {
    
    // MARK: Public methods
    func fetchAllLeague(success: @escaping (([League]) -> Void), failure: @escaping ((String) -> Void)) {
        APIService.instance.getAllLeagues { response in
            success(response.leagues)
        } failure: { error in
            print(error)
        }
    }

    func fetchTeamsFromLeague(params: String, success: @escaping (([Team]) -> Void), failure: @escaping ((String) -> Void)) {
        APIService.instance.getTeamsByLeague(params: params) { response in
            guard let teams = response.teams else {
                failure("no team found for this league")
                return
            }
            success(teams)
        } failure: { error in
            print(error)
        }
    }

    func featchTeamDetail(params: String, success: @escaping (([Team]) -> Void), failure: @escaping ((String) -> Void)) {
        APIService.instance.getTeamDetail(params: params) { response in
            guard let teams = response.teams else {
                failure("no team found for this league")
                return
            }
            success(teams)
        } failure: { error in
            print(error)
        }
    }
}

// MARK: - AllLeaguesResponse
struct AllLeaguesResponse: Decodable {
    let leagues: [League]
}

// MARK: - League
struct League: Decodable {
    let idLeague: String
    let strLeague: String
}

// MARK: - TeamsLeagueResponse
struct TeamsLeagueResponse: Decodable {
    let teams: [Team]?
}

// MARK: - Team
struct Team: Decodable {
    let idTeam: String
    let strTeam: String
    let strTeamBanner: String?
    let strCountry: String
    let strLeague: String
    let strDescriptionEN: String?
    let strTeamBadge: String?
}
