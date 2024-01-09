//
//  TabBarItem.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/7/24.
//

import UIKit

enum DontBeTabBarItem: CaseIterable {
    case home
    case writing
    case notification
    case myPage
    
    var icon: UIImage {
        switch self {
        case .home: return ImageLiterals.TabBar.icnHome
        case .writing: return ImageLiterals.TabBar.icnWriting
        case .notification: return ImageLiterals.TabBar.icnNotification
        case .myPage: return ImageLiterals.TabBar.icnMyPage
        }
    }
    
    var selectedIcon: UIImage {
        switch self {
        case .home: return ImageLiterals.TabBar.icnHomeSelected
        case .writing: return ImageLiterals.TabBar.icnWritingSelected
        case .notification: return ImageLiterals.TabBar.icnNotificationSelected
        case .myPage: return ImageLiterals.TabBar.icnMyPageSelected
        }
    }
    
    var title: String {
        switch self {
        case .home: return StringLiterals.Tabbar.home
        case .writing: return StringLiterals.Tabbar.writing
        case .notification: return StringLiterals.Tabbar.notification
        case .myPage: return StringLiterals.Tabbar.myPage
        }
    }
    
    var targetViewController: UIViewController? {
        switch self {
        case .home: return ViewController()
        case .writing: return WriteViewController()
        case .notification: return nil
        case .myPage: return nil
        }
    }
}
