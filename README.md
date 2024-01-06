# 👻 Don-tBe-iOS 

## ✨ 프로젝트 소개
### 비난·차별·혐오 표현의 글을 투명하게, 우리가 함께 만들어가는 온화한 익명 커뮤니티 Don’t be

<br>

## 🍎 iOS Developers
| 👑 변희주 | 변상우 | 김연수 |
| :--------: | :--------: | :--------: |
| | | |
| | | |
| | | |
| | | |

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
