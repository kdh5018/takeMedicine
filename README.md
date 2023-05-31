# 약먹었니?

<p align="center">
  <img src="https://github.com/kdh5018/takeMedicine/assets/104900735/8a767743-3bda-4497-bf17-79f33a40a7b3" width="300", height="300">
</p>

## App Store 주소
https://apps.apple.com/kr/app/%EC%95%BD%EB%A8%B9%EC%97%88%EB%8B%88/id6449581332

<p>
  <img src="https://github.com/kdh5018/takeMedicine/assets/104900735/ef469388-f57b-441f-997e-e46d346b1f8a" width="160.5", height="347.25">
  <img src="https://github.com/kdh5018/takeMedicine/assets/104900735/7eeb383c-be79-4578-b209-7f552c4b061c" width="160.5", height="347.25">
  <img src="https://github.com/kdh5018/takeMedicine/assets/104900735/3376d3ca-1a29-4dc1-9eeb-26185a1ac235" width="160.5", height="347.25">
  <img src="https://github.com/kdh5018/takeMedicine/assets/104900735/b8451965-eb33-4b5d-a7de-4ae43b2b0833" width="160.5", height="347.25">
</p>

## 앱 주요 기능
평소에 챙겨 먹어야 하는 약들을 자주 까먹는 경우를 떠올려 약을 복용해야 하는 시간을 설정하여 해당 시간이 되면 알림을 보내 까먹지 않고 약을 먹을 수 있게끔 제작된 CRUD 앱

## 앱 주요 기술
- 언어: Swift
- UI 프레임워크: UIKit(Storyboard)
- 디자인 패턴: MVC 패턴
- 알림 구현: Local Notification
- 데이터 저장 방식: UserDefaults

## 배포 과정에서 리젝 경험과 해결 방법
### 1. The support URL specified in your app’s metadata, (기존 정보제공 URL) does not properly navigate to the intended destination.
&rarr; 정보를 제공한 URL을 읽기 허용이 된 URL을 첨부했어야 했는데 비공개 URL을 제공해서 읽기 허용이 되어있는 URL로 재첨부하여 해결
### 2. We discovered one or more bugs in your app. Specifically, we were unable to set a time. Please review the details below and complete the next steps. 
&rarr; 심사과정에서 앱 기능 중 시간 설정에 대한 처리 과정을 잘못 이해함. 시간 설정하는 방법을 사진 첨부와 함께 회신해서 해결
