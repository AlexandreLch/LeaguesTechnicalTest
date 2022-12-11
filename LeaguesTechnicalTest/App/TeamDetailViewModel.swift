//
//  TeamDetailViewModel.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import Foundation
import UIKit
import Combine

protocol TeamDetailViewModelType {
    var title: String { get }
    var banner: CurrentValueSubject<UIImage?, Never> { get }
    var country: String { get }
    var league: String { get }
    var description: String { get }
}

class TeamDetailViewModel: TeamDetailViewModelType {
    private let team: Team
    private let imageDownloadManager: ImageDownloadManager
    var title: String
    var banner = CurrentValueSubject<UIImage?, Never>(nil)
    var country: String
    var league: String
    var description: String
    
    init(team: Team, imageDownloadManager: ImageDownloadManager) {
        self.team = team
        self.imageDownloadManager = imageDownloadManager
        self.title = team.strTeam
        self.country = team.strCountry
        self.league = team.strLeague
        self.description = team.strDescriptionEN ?? "No description"
        
        if let urlString = team.strTeamBanner {
            self.downloadBanner(with: urlString)
        }
    }
    
    private func downloadBanner(with url: String) {
        guard let url = URL(string: url) else { return }
        self.imageDownloadManager.imageWith(url) { [weak self] image in
            guard let self = self else { return }
            self.banner.send(image)
        }
    }
}
