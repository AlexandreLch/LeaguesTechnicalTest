//
//  APIService.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 10/12/2022.
//

import Foundation

class APIService {
    static let instance = APIService()
    
    private func baseRequest(route: Route, params: String? = nil, success: @escaping ((Data) -> Void), failure: @escaping ((String) -> Void)) {
        
        var urlString = "https://www.thesportsdb.com/api/v1/json/50130162\(route.rawValue)"
        
        if let params = params {
            urlString.append(params)
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    success(data)
                } else {
                    failure("No data")
                }
            }.resume()
        }
    }
    
    func getAllLeagues(success: @escaping ((AllLeaguesResponse) -> Void), failure: @escaping ((String) -> Void)) {
        self.baseRequest(route: .allLeagues) { data in
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(AllLeaguesResponse.self, from: data)
                success(response)
            } catch let error {
                print(error)
            }
        } failure: { errorString in
            failure(errorString)
        }
    }
    
    func getTeamsByLeague(params: String, success: @escaping ((TeamsLeagueResponse) -> Void), failure: @escaping ((String) -> Void)) {
        let cleanedParams = params.replacingOccurrences(of: " ", with: "%20")
        let fullParams = "?l=\(cleanedParams)"
        self.baseRequest(route: .teamLeague, params: fullParams) { data in
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(TeamsLeagueResponse.self, from: data)
                success(response)
            } catch let error {
                print(error)
            }
        } failure: { errorString in
            failure(errorString)
        }
    }
    
    func getTeamDetail(params: String, success: @escaping ((TeamsLeagueResponse) -> Void), failure: @escaping ((String) -> Void)) {
        self.baseRequest(route: .teamDetail, params: params) { data in
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(TeamsLeagueResponse.self, from: data)
                success(response)
            } catch let error {
                print(error)
            }
        } failure: { errorString in
            failure(errorString)
        }
    }
}

extension APIService {
    enum Route: String {
        case allLeagues = "/all_leagues.php"
        case teamLeague = "/search_all_teams.php"
        case teamDetail = "/searchteams.php"
    }
}
