## 1. Recordy
```
레코디는 공간을 영상을 통해 디깅하고, 본인의 취향을 발견하는 서비스이다. 취향에 맞는 공간 정보를 받을 수 있는
플랫폼들은 분산되어 있고, 가공된 리뷰 사진으로 인해 실제 공간감을 느낄 수 없다는 문제로부터 서비스가 시작되었다.
주요 기능은 유저가 직접 촬영하여 업로드한 영상을 업로드, 타유저가 업로드한 영상을 넘겨보는 것이다. 취향에 적합한
영상이 있다면 북마크할 수 있으며 비슷한 취향을 가진 유저를 팔로우하여 해당 유저의 게시 영상을 확인할 수 있다.
```

## 2. 팀원
| [한지석](https://github.com/sozohoy) | [송여경](https://github.com/0gonge) | [문형근](https://github.com/Chandrarla) |
|:---:|:---:|:---:|
|<img width="250" alt="sozohoy" src="https://avatars.githubusercontent.com/sozohoy">|<img width="250" alt="0gonge" src="https://avatars.githubusercontent.com/0gonge">|<img width="250" alt="Chandrarla" src="https://avatars.githubusercontent.com/Chandrarla">|


## 3. Library

```
아키텍처(우선순위)
1. MVVM - Coordinator
2. 모듈화 적용
3. Clean Architecture 기반

라이브러리 사용
1. 프로젝트 관리 도구: Tuist
  - 프로젝트 충돌 방지
  - 모듈화 적용 
  - 리소스(Asset, Font, Color)등 편하게 관리 가능

2. UI: SnapKit + Then
  - UI를 편하게 구현하기 위함

3. Network: Moya
  - Network 통신을 편하게 하기 위함

4. Reactive: RxSwift
  - 반응형 프로그래밍을 편하게 하기 위함
  - MVVM을 보다 편하게 구현할 수 있음
```
    
## 4. Coding Convention
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


## 5. Git Flow 전략
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

### 커밋 메시지
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

## 6. Foldering Convention
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
