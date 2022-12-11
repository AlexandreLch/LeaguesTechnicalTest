//
//  UICollectionViewExtension.swift
//  LeaguesTechnicalTest
//
//  Created by Alexandre Lellouche on 11/12/2022.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerCellClass<T: UICollectionViewCell>(_ className: T.Type) {
        register(className, forCellWithReuseIdentifier: String(describing: className))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as! T
    }
}
