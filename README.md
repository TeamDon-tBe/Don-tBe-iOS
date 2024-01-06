# 👻 Don-tBe-iOS 

## ✨ 프로젝트 소개
### 비난·차별·혐오 표현의 글을 투명하게, 우리가 함께 만들어가는 온화한 익명 커뮤니티 Don’t be

<br>

## 🍎 iOS Developers
| 👑 변희주 | 변상우 | 김연수 |
| :--------: | :--------: | :--------: |
| <img src="https://github.com/TeamDon-tBe/Don-tBe-iOS/assets/97782228/bbed44fe-eed0-4b8c-a249-fad0970515b6" width="230px"/> | <img src="https://github.com/TeamDon-tBe/Don-tBe-iOS/assets/97782228/142e1c53-3f15-4497-be7e-3af3ae702cf5" width="230px"/> | <img src="https://github.com/TeamDon-tBe/Don-tBe-iOS/assets/97782228/06d74614-17de-4517-b185-5c26b6fb7edf" width="230px"/> |
|[Heyjoo](https://github.com/Heyjooo)|[boogios](https://github.com/boogios)|[yeonsu0-0](https://github.com/yeonsu0-0)|
| 온보딩, 알림 | 글쓰기, 마이페이지 |   홈   |
| 따뜻한 익명의 공간을 <br>만들어나가요 ❤️‍🔥 | | 오늘은 어떤 코드를 짜볼까 ~ |

<br>

## 🔄 Architecture Pattern
### MVVM Pattern
<img width="685" alt="스크린샷 2024-01-07 오전 12 40 16" src="https://github.com/TeamDon-tBe/Don-tBe-iOS/assets/97782228/e990804a-6e1d-4b38-bfd6-c5710d12b7cb">

<br>

## ✅ Coding Convention
Don't be Coding Convention  ➡️ 
🔗https://joyous-ghost-8c7.notion.site/Coding-Convention-fe51e7ac0d624b6f9653087e20e2c4b5?pvs=4

<br>

## 🧬 Git branch 전략
~~~ 
1️. 처음에는 main branch와 main에서부터 시작된 develop branch가 존재합니다.
2️. 새로운 작업이 있는 경우 develop branch에서 feature branch를 생성합니다. 
   feature branch는 언제나 develop branch에서부터 시작하게 됩니다. 
   기능 추가 작업이 완료되었다면 feature branch는 develop 브랜치로 merge 됩니다. 
3️. 수정 사항이 생기면 develop branch에서 fix branch를 생성합니다. 
   fix branch도 마찬가지로 develop branch에서부터 시작하게 됩니다. 
   수정이 완료되었다면 fix branch는 develop 브랜치로 merge 됩니다. 
4️. develop에 이번 버전에 포함되는 모든 기능이 merge 되었다면 QA를 하기 위해 develop branch에서 release branch를 생성합니다. 
   QA를 진행하면서 발생한 버그들은 release branch에서 수정됩니다. 
   QA를 무사히 통과했다면 release branch를 main과 develop branch로 merge 합니다.
5️. 마지막으로 출시된 main 브랜치에서 버전 태그를 추가합니다.
~~~

<br>

## 📁 Project Foldering Convention
~~~
├── Application
│   ├── AppDelegate
│   ├── SceneDelegate
├── Global
│   ├── Extension
│   ├── Literals
│   │   ├── ImageLiterals
│   │   ├── StringLiterals
│   ├── Resources
│   │   ├── Font
│   │   ├── Assets
│   │   ├── Info.plist
├── Network
│   ├── Foundation
│   |   ├── Config
|   |   ├── NetworkError
│   ├── Scene1(이름)
│   |   ├── DTO
|   |   ├── Service
├── Presentation
│   ├── Scene1(이름)
│   │   ├── Views
│   │   ├── ViewControllers
│   │   ├── ViewModels
│   │   ├── Cells
│   │   │   ├── Cell1
│   │   │   ├── Cell2
│   ├── Example
│   │   ├── ExampleView
│   │   ├── ExampleViewController
├───├───├── ExampleCollectionViewCell
~~~

## 📚 Library
~~~
1. SnapKit
    - Auto Layout을 보다 간결하게 작성할 수 있게 해주는 라이브러리
2. KakaoOpenSDK
    - 카카오 플랫폼과의 통합을 위한 개발 도구를 제공하는 라이브러리
~~~
