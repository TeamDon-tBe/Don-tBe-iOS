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
        static let notValidNickName = "*닉네임에 사용할 수 없는 문자가 포함되어 있어요."
        static let duplicationCheck = "중복확인"
        static let duplicationCheckDescription = "*중복된 닉네임인지 확인해주세요"
        static let duplicationNotPass = "*사용 불가능한 닉네임입니다."
        static let duplicationPass = "*사용 가능한 닉네임입니다."
    }
    
    enum Onboarding {
        static let placeHolder = "한 문장으로 소개를 남겨주세요!"
        static let information = "설정한 닉네임, 한 줄 소개는 설정에서 변경 가능해요!\n작성한 한 줄 소개는 작성한 게시글로 업로드 돼요."
    }
    
    enum Button {
        static let skip = "건너뛰기"
        static let next = "다음으로"
        static let start = "시작하기"
        static let later = "한 줄 소개 나중에 작성하기"
        static let finish = "완료하기"
        static let editFinish = "수정완료"
        static let goHome = "홈으로 가기"
        static let promise = "약속할게요!"
    }
    
    enum Toast {
        static let uploading = "게시 중..."
        static let uploaded = "게시 완료!"
        static let alreadyTransparency = "이미 투명도를 적용한 유저예요."
        static let deleteText = "삭제 완료"
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
        static let emptyTitle = "아직 받은 알림이 없어요."
        static let emptyDescription = "새로운 소식이 도착하면 알려드릴게요."
    }
    
    enum MyPage {
        static let MyPageNavigationTitle = "마이"
        static let MyPageEditNavigationTitle = "프로필 편집"
        static let MyPageAccountInfoNavigationTitle = "계정 정보"
        static let MyPageSignOutNavigationTitle = "계정 삭제"
        static let myPageEditIntroduction = "한줄 소개"
        static let myPageEditIntroductionPlease = "한 줄로 자신을 소개해주세요."
        static let myPageNoContentLabel = "님, 아직 글을 작성하지 않았네요!\n왠지 텅 빈 게시글이 허전하게 느껴져요."
        static let myPageNoContentOtherLabel = "님이 글을 작성하지 않았어요."
        static let myPageNoContentButton = "첫 게시글 남기기"
        static let myPageNoCommentLabel = "아직 작성한 답글이 없어요"
        static let myPageNoCommentOtherLabel = "님이 답글을 작성하지 않았어요."
        static let myPageCustomerURL = "https://joyous-ghost-8c7.notion.site/Don-t-be-e949f7751de94ba682f4bd6792cbe36e"
        static let myPageFeedbackURL = "https://forms.gle/DqnypURRBDks7WqJ6"
        static let myPageUseTermURL = "https://joyous-ghost-8c7.notion.site/4ac9966cf7d944bf9595352edbc1b1b0"
        static let myPageMoreInfoTitle = "이용약관"
        static let myPageMoreInfoButtonTitle = "자세히 보기"
        static let myPageSignOutButtonTitle = "계정삭제"
        static let myPageLogoutPopupTitleLabel = "로그아웃"
        static let myPageLogoutPopupContentLabel = "계정에서 로그아웃하시겠어요?"
        static let myPageLogoutPopupLeftButtonTitle = "취소"
        static let myPageLogoutPopupRightButtonTitle = "확인"
        static let myPageSignOutPopupTitleLabel = "계정삭제"
        static let myPageSignOutPopupContentLabel = "계정을 삭제하시겠어요?"
        static let myPageSignOutPopupLeftButtonTitle = "취소"
        static let myPageSignOutPopupRightButtonTitle = "확인"
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
        static let deletePopupTitleLabel = "게시글을 삭제하시겠어요?"
        static let deletePopupContentLabel = "삭제한 게시글은 영구히 사라져요."
        static let deletePopupCommentLabel = "삭제한 답글은 영구히 사라져요."
        static let deletePopupLefteftButtonTitle = "취소"
        static let deletePopupRightButtonTitle = "삭제"
    }
    
    enum Post {
        static let navigationTitleLabel = "게시글"
        static let textFieldLabel = "님에게 답글 남기기"
        static let popupReplyContentLabel = "작성 중인 글을 삭제하시겠어요?"
        static let popupReplyCancelButtonTitle = "취소"
        static let popupReplyConfirmButtonTitle = "삭제"
    }
    
    enum BottomSheet {
        static let deleteLabel = "삭제하기"
        static let warnLabel = "신고하기"
        static let profileEdit = "프로필 편집"
        static let accountInfo = "계정 정보"
        static let feedback = "피드백 남기기"
        static let customerCenter = "고객센터"
        static let logout = "로그아웃"
    }
    
    enum Network {
        static let expired = "access, refreshToken 모두 만료되었습니다. 재로그인이 필요합니다."
        static let baseImageURL = "https://github.com/TeamDon-tBe/SERVER/assets/97835512/fb3ea04c-661e-4221-a837-854d66cdb77e"
        static let notificationImageURL = "https://github.com/TeamDon-tBe/SERVER/assets/128011308/327d416e-ef1f-4c10-961d-4d9b85632d87"
        static let warnUserGoogleFormURL = "https://forms.gle/FTgZKkajwtzFvAk99"
        static let errorMessage = "이런!\n현재 요청하신 페이지를 찾을 수 없어요!"
    }
}
