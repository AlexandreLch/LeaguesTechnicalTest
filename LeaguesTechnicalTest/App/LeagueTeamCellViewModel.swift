//
//  LeagueTeamCellViewModel.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import Foundation
import UIKit
import Combine

protocol LeagueTeamCellViewModelType {
    var image: CurrentValueSubject<UIImage?, Never> { get }
}

class LeagueTeamCellViewModel: LeagueTeamCellViewModelType {
    private let imageUrl: String
    private let imageDownloadManager: ImageDownloadManager
    var image = CurrentValueSubject<UIImage?, Never>(UIImage(named: "placeholder_sport"))
    
    init(imageUrl: String, imageDownloadManager: ImageDownloadManager) {
        self.imageUrl = imageUrl
        self.imageDownloadManager = imageDownloadManager
        
        self.getImage(url: imageUrl)
    }
    
    private func getImage(url: String) {
        guard let url = URL(string: url) else { return }
        self.imageDownloadManager.imageWith(url) { [weak self] image in
            guard let self = self else { return }
            self.image.send(image)
        }
    }
}
