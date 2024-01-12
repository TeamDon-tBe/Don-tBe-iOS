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
    
    enum MyPage {
        static let MyPageNavigationTitle = "마이"
        static let MyPageEditNavigationTitle = "프로필 편집"
        static let MyPageAccountInfoNavigationTitle = "계정 정보"
    }
    
    enum TransparencyInfo {
        static let title1 = "투명도가 무엇인가요?"
        static let title2 = "게시글의 투명도 주기 버튼을 클릭하면,"
        static let title3 = "게시글의 투명도 주기 버튼을 클릭하면,"
        static let title4 = "투명도가 너무 낮아지면\n활동에 제한이 생겨요."
        static let title5 = "투명도 적용은 5일간 지속돼요."
        static let content1 = "투명도는 돈비 커뮤니티의 온화함을 만들어나가는\n기능으로, 상대의 감정을 반영한 온화 권장 수치예요."
        static let content2 = "해당 유저가 작성한 모든 게시글, 답글이 -1%씩 점점\n투명해지고, 모두에게 투명도가 적용되어 보여져요."
        static let content3 = "내가 투명도를 적용한 유저들의 활동은\n홈 화면에서 투명하게 보여져요."
        static let content4 = "투명도가 -85%가 된 유저는\n더 이상 게시글과 답글을 작성할 수 없어요."
        static let content5 = "투명도는 최근 5일 동안 버튼이 적용된 내용을 반영해요.\n5일이 지나면 적용되었던 투명도가 다시 회복돼요."
    }
    
    enum Home {
        static let transparentPopupTitleLabel = "투명도 주기"
        static let transparentPopupContentLabel = "지금 누르신 투명도 기능이 Don’t be를 더 온화한 커뮤니티로 만들기 위한 일이겠죠?"
        static let transparentPopupLefteftButtonTitle = "조금 더 고민하기"
        static let transparentPopupRightButtonTitle = "네, 맞아요"
    }
}
