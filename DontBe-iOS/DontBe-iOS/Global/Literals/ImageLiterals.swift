//
//  ImageLiterals.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import UIKit

enum ImageLiterals {
    enum Common {
        static var btnBack: UIImage { .load(name: "btn_back") }
        static var logoSymbol: UIImage { .load(name: "logo_symbol") }
    }
    
    enum TabBar {
        static var icnHome: UIImage { .load(name: "icn_home") }
        static var icnHomeSelected: UIImage { .load(name: "icn_home_selected") }
        static var icnWriting: UIImage { .load(name: "icn_writing") }
        static var icnWritingSelected: UIImage { .load(name: "icn_writing_selected") }
        static var icnNotification: UIImage { .load(name: "icn_notification") }
        static var icnNotificationSelected: UIImage { .load(name: "icn_notification_selected") }
        static var icnMyPage: UIImage { .load(name: "icn_mypage") }
        static var icnMyPageSelected: UIImage { .load(name: "icn_mypage_selected") }
    }
    
    enum Onboarding {
        static var progressbar1: UIImage { .load(name: "onboarding_progressbar_1") }
        static var progressbar2: UIImage { .load(name: "onboarding_progressbar_2") }
        static var progressbar3: UIImage { .load(name: "onboarding_progressbar_3") }
        static var progressbar4: UIImage { .load(name: "onboarding_progressbar_4") }
        static var imgOne: UIImage { .load(name: "img_onboarding1") }
        static var imgTwo: UIImage { .load(name: "img_onboarding2") }
        static var imgThird: UIImage { .load(name: "img_onboarding3") }
        static var imgOneTitle: UIImage { .load(name: "title_first") }
        static var imgTwoTitle: UIImage { .load(name: "title_second") }
        static var imgThirdTitle: UIImage { .load(name: "title_third") }
    }
    
    enum Login {
        static var btnApple: UIImage { .load(name: "login_btn_apple") }
        static var btnKakao: UIImage { .load(name: "login_btn_kakao") }
        static var btnNaver: UIImage { .load(name: "login_btn_naver") }
        static var icnLogo: UIImage { .load(name: "icn_login_logo") }
    }
    
    enum Home {
        static var textLogo: UIImage { .load(name: "Logo") }
    }
    
    enum Posting {
        static var btnComment: UIImage { .load(name: "btn_comment") }
        static var btnDelete: UIImage { .load(name: "btn_delete") }
        static var btnKebab: UIImage { .load(name: "btn_kebab") }
        static var btnWarn: UIImage { .load(name: "btn_warn") }
        static var btnFavoriteActive: UIImage { .load(name: "favorite=btn_favorite_active") }
        static var btnFavoriteInActive: UIImage { .load(name: "favorite=btn_favorite_default") }
        static var icnDelete: UIImage { .load(name: "icn_delete") }
        static var btnTransparent: UIImage { .load(name: "status=btn_ghost_default") }
    }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
}
