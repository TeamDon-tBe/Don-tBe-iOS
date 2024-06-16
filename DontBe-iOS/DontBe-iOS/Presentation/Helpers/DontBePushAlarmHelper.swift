//
//  DontBePushAlarmHelper.swift
//  DontBe-iOS
//
//  Created by 박윤빈 on 6/11/24.
//

import UIKit

final class DontBePushAlarmHelper {
    
    private var contentID = Int()
    
    init(contentID: Int) {
        self.contentID = contentID
    }
    
    func start() {
        load()
    }
    
    private func load() {
        if let window = UIApplication.shared.windows.first {
            if let rootViewController = window.rootViewController as? UINavigationController {
                let targetViewController = PostDetailViewController(viewModel: PostDetailViewModel(networkProvider: NetworkService()))
                // 데이터 전달
                targetViewController.contentId = Int(self.contentID ?? 0)
                rootViewController.pushViewController(targetViewController, animated: true)
            }
        }
    }
    
    func checkUserLoginState() {
        
    }
}
