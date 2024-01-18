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
        static var imgProfile: UIImage { .load(name: "img_profile") }
        static var btnBackGray: UIImage { .load(name: "btn_back_gray") }
        static var img404: UIImage { .load(name: "img_404") }
    }
    
    enum TabBar {
        static var icnHome: UIImage { .load(name: "icn_home") }
        static var icnHomeSelected: UIImage { .load(name: "icn_home_selected") }
        static var icnWriting: UIImage { .load(name: "icn_writing") }
        static var icnWritingSelected: UIImage { .load(name: "icn_writing_selected") }
        static var icnNotificationRead: UIImage { .load(name: "icn_notification").withRenderingMode(.alwaysOriginal) }
        static var icnNotificationUnread: UIImage { .load(name: "icn_notification_unread").withRenderingMode(.alwaysOriginal) }
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
        static var imgFourthTitle: UIImage { .load(name: "title_fourth") }
    }
    
    enum Login {
        static var btnApple: UIImage { .load(name: "login_btn_apple") }
        static var btnKakao: UIImage { .load(name: "login_btn_kakao") }
        static var btnNaver: UIImage { .load(name: "login_btn_naver") }
        static var icnLogo: UIImage { .load(name: "icn_login_logo") }
    }
    
    enum Join {
        static var btnCheckBox: UIImage { .load(name: "btn_checkbox") }
        static var btnNotCheckBox: UIImage { .load(name: "btn_not_checkbox") }
        static var imgNecessary: UIImage { .load(name: "btn_necessary") }
        static var btnSelect: UIImage { .load(name: "btn_select") }
        static var btnView: UIImage { .load(name: "btn_view") }
        static var btnPlus: UIImage { .load(name: "btn_plus") }
    }
    
    enum Home {
        static var textLogo: UIImage { .load(name: "Logo") }
        static var icnNotice: UIImage { .load(name: "icn_notice") }
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
    
    enum Toast {
        static var icnCheck: UIImage { .load(name: "icn_check") }
    }
    
    enum Notification {
        static var imgNotice: UIImage { .load(name: "img_notice") }
        static var imgEmpty: UIImage { .load(name: "img_empty") }
    }
    
    enum MyPage {
        static var icnMenu: UIImage { .load(name: "icn_menu") }
        static var icnEditProfile: UIImage { .load(name: "icn_editprofile") }
        static var emptyPercentage: UIImage { .load(name: "empty-transparency-percentage") }
        static var fullPercentage: UIImage { .load(name: "transparency percentage") }
        static var icnTransparencyInfo: UIImage { .load(name: "icn_transparency_info") }
        static var icnPercentageBox: UIImage { .load(name: "icn_percentage-box") }
        static var btnEditProfile: UIImage { .load(name: "btn_editprofile") }
        static var btnAccount: UIImage { .load(name: "btn_acoount") }
        static var btnFeedback: UIImage { .load(name: "btn_feedback") }
        static var btnCustomerCenter: UIImage { .load(name: "btn_customerCenter") }
    }
    
    enum TransparencyInfo {
        static var progressbar1: UIImage { .load(name: "my_progressbar1") }
        static var progressbar2: UIImage { .load(name: "my_progressbar2") }
        static var progressbar3: UIImage { .load(name: "my_progressbar3") }
        static var progressbar4: UIImage { .load(name: "my_progressbar4") }
        static var progressbar5: UIImage { .load(name: "my_progressbar5") }
        static var imgTransparencyInfo1: UIImage { .load(name: "img_transparenc_info1") }
        static var imgTransparencyInfo2: UIImage { .load(name: "img_transparenc_info2") }
        static var imgTransparencyInfo3: UIImage { .load(name: "img_transparenc_info3") }
        static var imgTransparencyInfo4: UIImage { .load(name: "img_transparenc_info4") }
        static var imgTransparencyInfo5: UIImage { .load(name: "img_transparenc_info5") }
        static var btnClose: UIImage { .load(name: "btn_close") }
    }

    enum Popup {
        static var transparentButtonImage: UIImage { .load(name: "transparentPopUp") }
    }
    
    enum BottomSheet {
        static var deleteIcon: UIImage { .load(name: "icn_delete") }
        static var warnIcon: UIImage { .load(name: "icn_warning") }
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
