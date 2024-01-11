//
//  StringLiterals.swift
//  DontBe
//
//  Created by 변상우 on 12/26/23.
//

import Foundation

enum StringLiterals {
    enum Tabbar {
        static let home = "홈"
        static let writing = "글쓰기"
        static let notification = "알림"
        static let myPage = "마이"
    }
    
    enum Write {
        static let writeNavigationTitle = "새로운 글"
        static let writeNavigationBarButtonItemTitle = "취소"
        static let writeContentPlaceholder = "어떤 생각을 하고 있나요?"
        static let writePostButtonTitle = "게시"
        static let writePopupContentLabel = "작성 중인 글을 삭제하시겠어요?"
        static let writePopupCancleButtonTitle = "취소"
        static let writePopupConfirmButtonTitle = "삭제"
    }

    enum Login {
        static let title = "온화한 커뮤니티\nDON’T BE에서 만나요."
    }
    
    enum Join {
        static let joinNavigationTitle = "회원가입"
        static let agreement = "약관동의"
        static let checkTerms = "DON’T BE와 함께하기 전\n필요한 약관들을 확인해주세요!"
        static let allCheck = "전체선택"
        static let useAgreement = "이용약관 동의"
        static let privacyAgreement = "개인정보 수집 및 이용동의"
        static let checkAge = "만 14세 이상입니다"
        static let advertisementAgreement = "마케팅 활용 / 광고성 정보 수신동의"
        static let nickName = "닉네임"
        static let nickNamePlaceHolder = "닉네임을 입력해주세요."
        static let duplicationCheck = "중복확인"
        static let duplicationCheckDescription = "*중복된 닉네임인지 확인해주세요"
        static let duplicationNotPass = "*사용 불가능한 닉네임입니다."
        static let duplicationPass = "*사용 가능한 닉네임입니다."
    }
    
    enum Onboarding {
        static let placeHolder = "한문장으로 소개를 남겨주세요!"
        static let information = "설정한 사진, 닉네임, 한줄소개는 설정에서 변경 가능해요!"
    }
    
    enum Button {
        static let skip = "건너뛰기"
        static let next = "다음으로"
        static let start = "시작하기"
        static let finish = "완료하기"
    }
    
    enum Toast {
        static let uploading = "게시 중..."
        static let uploaded = "게시 완료!"
    }
    
    enum Notification {
        static let alarm = "알림"
        static let likeContent = "님이 회원님의 글을 좋아합니다."
        static let writeComment = "님이 답글을 작성했습니다."
        static let likeComment = "님이 회원님의 답글을 좋아합니다."
        static let welcome = "님, 이제 다시 글을 작성할 수 있어요! 오랜만에 인사를 남겨주세요!"
        static let transparency = "님, 투명해져서 당분간 글을 작성할 수 없어요."
        static let violation = "님 커뮤니티 활동 정책 위반으로 더이상 돈비를 이용할 수 없어요. 자세한 내용은 문의사항으로 남겨주세요."
        static let emphasizeViolation = "님 커뮤니티 활동 정책 위반으로 더이상 돈비를 이용할 수 없어요."
        static let contentTransparency = "님, 작성하신 게시글로 인해 점점 투명해지고 있어요."
        static let commentTransparency = "님, 작성하신 답글로 인해 점점 투명해지고 있어요."
    }
    
    enum MyPage {
        static let MyPageNavigationTitle = "마이"
    }
}
