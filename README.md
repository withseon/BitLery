# BitLery (비트러리)

> 실시간 암호화폐 시세 정보를 확인하고 관심 코인을 관리하는 가상화폐 모니터링 앱

<p align="center">
<img width="150" height="325" alt="Image" src="https://github.com/user-attachments/assets/2d12a024-d3e9-44e0-88ff-49038807da23" />
<img width="150" height="325" alt="Image" src="https://github.com/user-attachments/assets/6cd3a37f-87b6-485b-8619-d67a5a7d382c" />
<img width="150" height="325" alt="Image" src="https://github.com/user-attachments/assets/d87b9ffe-cfc9-466d-9221-e96608cfde8c" />
<img width="150" height="325" alt="Image" src="https://github.com/user-attachments/assets/2efc96d8-da5b-4f4c-9382-b7f44d97fe92" />
<img width="150" height="325" alt="Image" src="https://github.com/user-attachments/assets/8080f8d2-451b-4798-95ca-00d02da3f4ea" />
</p>

<br></br>
## ✨ 프로젝트 소개

BitLery는 실시간 암호화폐 시세 정보를 제공하고, 사용자가 관심 있는 코인을 즐겨찾기하여 모니터링할 수 있는 플랫폼입니다.
<br/>
<br/>

### 개발 기간
2025.03.28 ~ 2025.05.04.11 / iOS 개발 (1인 개발)
<br/>
<br/>

### 개발 환경
- iOS 16.0+
- Swift 5
- Xcode 16.2
- UIKit
<br/>

### 주요 기능

- **실시간 시세 확인**: 업비트/코인게코 API 기반 실시간 암호화폐 시세 조회
- **차트 뷰**: 코인별 상세 가격 차트 및 거래량 정보
- **즐겨찾기**: 관심 코인 즐겨찾기 관리 (Realm)
- **검색**: 코인 이름 및 심볼 기반 검색
- **트렌드 분석**: 시장 동향 및 NFT 트렌드 파악
- **네트워크 모니터링**: 실시간 연결 상태 감지 및 알림
</br>

### 프레임워크 & 라이브러리

- **UI**: UIKit
- **차트**: DGCharts
- **반응형 프로그래밍**: RxSwift, RxCocoa
- **오토레이아웃**: SnapKit
- **이미지 캐싱**: Kingfisher
- **데이터베이스**: RealmSwift
- **키보드 관리**: IQKeyboardManager
- **탭 관리**: Tabman
- **토스트 메시지**: Toast
</br>

## ✨ 아키텍처
MVVM 패턴 도입
<br/>
<br/>

### 디자인 패턴
- **MVVM (Model-View-ViewModel)**: 비즈니스 로직과 UI 분리
- **Singleton Pattern**: 네트워크 매니저 및 저장소 관리
- **Repository Pattern**: 데이터 소스 추상화 (Realm)
- **Protocol-Oriented Programming**: BaseViewModel, Requestable 프로토콜 활용

</br>

### 프로젝트 구조

<details>
  <summary>프로젝트 구조 보기</summary>

  ```
  BitLery/
  ├── App/                   # 앱 진입점
  │   ├── AppDelegate.swift
  │   └── SceneDelegate.swift
  │
  ├── Common/                # 공통 모듈
  │   ├── Base/             # Base 클래스
  │   │   ├── BaseView.swift
  │   │   ├── BaseViewController.swift
  │   │   └── BaseCollectionViewCell.swift
  │   ├── Component/        # 재사용 컴포넌트
  │   │   ├── CustomNavigationBar.swift
  │   │   ├── CustomSearchBar.swift
  │   │   ├── SortView.swift
  │   │   ├── RateView.swift
  │   │   ├── DetailInfoView.swift
  │   │   ├── TitleLabel.swift
  │   │   └── MoreButton.swift
  │   ├── Entity/           # 도메인 모델
  │   │   ├── Ticker.swift
  │   │   ├── MarketCoin.swift
  │   │   ├── TrendCoin.swift
  │   │   ├── TrendNFT.swift
  │   │   ├── SearchCoin.swift
  │   │   └── CoinBasicInfo.swift
  │   ├── Extension/        # 확장 기능
  │   │   ├── UIView+.swift
  │   │   └── UIImageView+.swift
  │   └── Protocol/         # 프로토콜
  │       ├── BaseViewModel.swift
  │       └── Requestable.swift
  │
  ├── Core/                  # 데이터 Layer
  │   ├── Network/          # 네트워크 통신
  │   │   ├── NetworkManager.swift
  │   │   ├── NetworkMonitorService.swift
  │   │   ├── NetworkError.swift
  │   │   ├── APIErrorResponse.swift
  │   │   ├── RequestType.swift
  │   │   ├── Router/       # API 라우터
  │   │   │   ├── UpbitRouter.swift
  │   │   │   └── CoingeckoRouter.swift
  │   │   └── DTO/          # 데이터 전송 객체
  │   │       ├── UpbitTicker/
  │   │       ├── CoingeckoMarket/
  │   │       ├── CoingeckoSearch/
  │   │       └── CoingeckoTrend/
  │   └── Database/         # 로컬 데이터베이스
  │       └── Realm/
  │           ├── RealmDataRepository.swift
  │           ├── RealmError.swift
  │           └── Table/
  │               └── CoinTable.swift
  │
  ├── Scene/                 # UI Layer (View + ViewModel)
  │   ├── TabBar/           # 탭바
  │   │   └── MainTabBarController.swift
  │   ├── Market/           # 마켓 화면
  │   │   ├── MarketViewController.swift
  │   │   ├── MarketViewModel.swift
  │   │   └── Cell/
  │   │       └── MarketCollectionViewCell.swift
  │   ├── Trend/            # 트렌드 화면
  │   │   ├── TrendViewController.swift
  │   │   ├── TrendViewModel.swift
  │   │   ├── Cell/
  │   │   │   ├── CoinTrendCollectionViewCell.swift
  │   │   │   └── NFTTrendCollectionViewCell.swift
  │   │   ├── Detail/       # 상세 화면
  │   │   │   ├── DetailViewController.swift
  │   │   │   └── DetailViewModel.swift
  │   │   └── Search/       # 검색 화면
  │   │       ├── SearchViewController.swift
  │   │       ├── SearchViewModel.swift
  │   │       ├── SearchTabViewController.swift
  │   │       ├── Coin/
  │   │       │   └── CoinSearchViewController.swift
  │   │       ├── Market/
  │   │       │   └── MarketSearchViewController.swift
  │   │       ├── NFT/
  │   │       │   └── NFTSearchViewController.swift
  │   │       └── Cell/
  │   │           └── SearchCoinCollectionViewCell.swift
  │   ├── Dialog/           # 다이얼로그
  │   │   ├── DialogViewController.swift
  │   │   └── DialogViewModel.swift
  │   └── Setting/          # 설정 화면
  │       └── SettingViewController.swift
  │
  ├── Resource/              # 리소스
  │   ├── Assets.xcassets   # 이미지 및 색상
  │   │   ├── color/       # 컬러 에셋
  │   │   └── icon/        # 아이콘 에셋
  │   ├── Resource.swift
  │   ├── Resource+SystemFont.swift
  │   └── Resource+RateChange.swift
  │
  ├── Util/                  # 유틸리티
  │   └── FormatHelper.swift
  │
  └── APIKEY.swift           # API 키 관리
  ```

</details>
</br>

## ✨ 주요 기능 상세

### 1. 실시간 시세 조회

- 업비트/코인게코 API를 통한 실시간 암호화폐 시세 데이터 수신
- RxSwift 기반 반응형 데이터 바인딩
- 가격 변동률 및 거래량 표시
- 정렬 기능 (가격순, 변동률순, 거래량순)

### 2. 코인 상세 정보

- Swift Charts를 활용한 가격 차트 시각화
- 실시간 가격 정보 및 거래량 통계
- 즐겨찾기 추가/제거 기능
- Realm 기반 즐겨찾기 데이터 영구 저장

### 3. 검색 및 필터링

- Tabman을 활용한 탭 기반 검색 (코인, 마켓, NFT)
- 코인 이름 및 심볼 기반 실시간 검색
- 공백 검색 방지 처리
- 검색 결과 즐겨찾기 상태 표시

### 4. 트렌드 분석

- 코인게코 API 기반 트렌드 코인 조회
- NFT 트렌드 정보 제공
- 인기 순위 및 가격 변동률 표시

### 5. 즐겨찾기 관리

- RealmSwift 기반 즐겨찾기 데이터 저장
- 실시간 즐겨찾기 상태 동기화
- 삭제 및 추가 기능
- 앱 재실행 시 복원

### 6. 네트워크 모니터링

- Network Framework 기반 연결 상태 감지
- 네트워크 끊김 시 사용자 알림 (Alert)
- 자동 재연결 처리
- 실시간 네트워크 상태 모니터링

### 7. 이미지 캐싱

- Kingfisher를 활용한 이미지 다운로드 및 캐싱

</br>
