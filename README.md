# yoo0 유영
<img width="1920" alt="KakaoTalk_Photo_2024-07-19-23-03-58" src="https://github.com/user-attachments/assets/1afc56c5-19da-4dc9-9e0c-e76075c66d32">

## 🫧About 유영
### 같이 유영하러 갑시다.
### 유저가 ‘공간’을 ‘영상’으로 디깅하고, 나만의 ‘공간 취향’을 발견하는 서비스

```
"내 취향에 맞는 공간을 촬영하고 업로드하는 숏폼을 활용하는 라이프스타일 플랫폼"
사용자들은 새로운 장소를 자유롭게 둘러보고 취향을 찾으며, 다른 사용자들과 공간 경험을 나눌 수 있습니다.
동영상을 활용하여 방문 전에도 실제와 유사한 공간감을 느낄 수 있는 공간 영상을 제공합니다. 
또한 키워드와 취향에 맞는 유저 구독 기능을 통해 무분별한 알고리즘에서 벗어나 취향에 맞는 공간 정보만 탐색할 수 있도록 하는 가치를 제공합니다. 
```

## 📍Problem
- 취향에 맞는 공간 정보를 받을 수 있는 플랫폼의 분산
- 공간감을 느낄 수 없는 가공된 사진
- 기존 플랫폼의 영상 알고리즘으로 내 취향에 맞지 않는 공간 노출

## 📍Solve
1. 내 공간 경험 업로드하기
: 사용자가 다양한 장소를 촬영한 공간감이 느껴지는 짧은 영상을 앱에 업로드할 수 있으며, 간편한 인터페이스로 촬영부터 업로드까지 손쉽게 진행할 수 있습니다.
2. 내 취향 분석표 수집하기
: 사용자 취향을 분석하여 맞춤형 취향 분석표를 제공합니다. 나만의 분석표를 받고 공간 취향을 알아볼 수 있습니다.
3. 취향 기반 유저의 소식 받기
: 다른 유저를 팔로우하고, 그들의 영상을 저장하고 소식을 받을 수 있습니다.
4. 관심 있는 공간 저장하기
: 마음에 드는 공간 영상을 저장하고, 쉽게 보관할 수 있습니다.

## 🫧About Team
| [한지석](https://github.com/sozohoy) | [송여경](https://github.com/0gonge) | [문형근](https://github.com/Chandrarla) |
|:---:|:---:|:---:|
|<img width="250" alt="sozohoy" src="https://avatars.githubusercontent.com/sozohoy">|<img width="250" alt="0gonge" src="https://avatars.githubusercontent.com/0gonge">|<img width="250" alt="Chandrarla" src="https://avatars.githubusercontent.com/Chandrarla">|

- 한지석 : 영상, 기록
- 송여경 : 프로필, 팔로잉, 팔로워
- 문형근 : 로그인, 홈

## Team Photo
![IMG_8049 2](https://github.com/user-attachments/assets/8fc48fd8-5fa1-4f72-98c6-dbf07cd2c72c)


## Library
  [![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)
<p>
  <img src="https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white"/>
</p>

### Tuist : 프로젝트 관리 적용 , 모듈화 
### UI : SnapKit + Then
### NetWork : Moya
### Reactive : RxSwift

## Coding Convention
```
1. 여백 두칸으로 고정
2. 함수명은 주어 + 동사 + (목적어)
3. UI는 set ~ 으로 작성하고 순서는 setStyle() -> setUI() -> setAutolayout(). 오토레이아웃은 상, 하, 좌, 우, 크기 순서로 지정하기
4. 접근제어자 신경써서 작성하기
5. 파라미터가 2개 이상이다 ? -> Command + M
6. Command + I 수시로 하기
7. 컴포넌트 -> 프로퍼티 -> 생명주기 -> UI세팅 -> 기타 함수들 -> Extension
8. TableView, CollectionView Delegate, DataSource 를 같은 클래스 내부가 아닌 Extension을 활용하여 관리하기
9. 주석 쓸거라면 코드의 위에 작성하기!
10. import 순서는 UIKit(Foundation) -> 내부 모듈 -> 외부 모듈로 선언하고 ABC 순서대로 작성
```

## Git Flow 
<img width="753" alt="스크린샷 2024-06-26 오후 12 14 34" src="https://github.com/Team-Recordy/Recordy-iOS/assets/49385546/7a098200-d152-4207-a6ef-b7a845e3f766">
<br>
(Master == Main, Hotfix 미사용)

```
/// 항상 develop 브랜치가 최신 상태인지 확인해주세요 !
/// 작업 브랜치에서 작업 중에 develop 브랜치의 최신 상태가 변경되었다면?
/// -> 작업 브랜치에 머지를 해주어야 함
1. issue 생성
2. develop 브랜치에서 git checkout -b (issue 종류/#작업번호)
3. 해당 브랜치에서 작업 진행 및 커밋(커밋은 한번에 다 올리지 말기)
4. 작업 완료 후 빌드가 되는지 확인 후 원격으로 push
5. PR & merge
```

## Commit Message
```
일반적인 커밋 : `feat: 버튼 작동 시 특정 이벤트 발생하는 기능 구현(#33)`
최신 작업 상황 반영 : `merge: develop into #33

#   feat        : 기능 구현(UI 포함)
#   fix         : 기능 수정
#   bug         : 버그 해결
#   refactor    : 리팩토링 
#   merge       : 최신 작업 상황 반영시
#   style       : 스타일 (코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)  
#   docs        : 문서 수정 (문서 추가, 수정, 삭제, README)  
#   test        : 테스트 (테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)  
#   chore       : 기타 변경사항 (빌드 스크립트 수정, assets, 패키지 매니저 등)    
#   rename      : 파일 혹은 폴더명을 수정하거나 옮기는 작업만 한 경우  
#   remove      : 파일을 삭제하는 작업만 수행한 경우  
#   init        : 초기 생성
```

## Foldering Convention
```
├── 🧩 App 
|   ├── 🗂️ Sources
│   │   ├── AppDelegate
│   │   ├── SceneDelegate
|   ├── 🗂️ Resources
│   │   ├── LaunchScreen
|   ├── 🗂️ Derived
│   │   ├── Info.plist
├── 🧩 Common
|   ├── 🗂️ Sources
│   │   ├── 🗂️ Extension
│   │   ├── 🗂️ Font
│   │   ├── 🗂️ Components
│   ├── 🗂️ Resources
│   │   ├── 🗂️ Font
│   │   ├── Asset
|   ├── 🗂️ Derived
│   │   ├── 🗂️ InfoPlists
│   │   │   ├── Info.plist
│   │   ├── 🗂️ Sources
│   │   │   ├── TuistAssets+Common
│   │   │   ├── TuistBundle+Common
│   │   │   ├── TuistFonts+Common
├── 🧩 Core
│   ├── 🗂️ Coordinator
│   ├── 🗂️ Network
│   ├── 🗂️ Base
...
├── 🧩 Data
│   ├── 🗂️ DTO
│   ├── 🗂️ API
│   ├── 🗂️ Model
...
├── 🧩 Presentation
│   ├── 🗂️ AView
│   │   ├── 🗂️ Flows
│   │   │   ├── ACoordinator
│   │   ├── 🗂️ Feature
│   │   │   ├── AViewController
│   │   │   ├── AViewModel
```
