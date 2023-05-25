//
//  PlusViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit
import GoogleMobileAds


//MARK: - 약 추가하기 페이지
class PlusViewController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var textFieldTimePicker: UITextField!
    
    @IBOutlet weak var plusBtn: UIButton!
    
    
    var plusDelegate: MedicineDelegate?
    
    
    // 시간 값 저장하는 배열
    var notificationTimeComponents: [DateComponents] = []
    
    // 각 시간 구성 요소에 대한 알림 요청 생성
    var notificationRequests: [UNNotificationRequest] = []
    var notificationIds: [String] = []
    
    var addedTimeComponents = Set<DateComponents>()
    
    var hour = 0
    var minute = 0
    
    let timePicker = UIDatePicker()
    
    /// 시간 추가하기 버튼 클릭 시 복용 시간 추가 기능 구현
    var clickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        // 배너 사이즈 설정
        bannerView = GADBannerView(adSize: GADAdSizeBanner)

        // 광고 배너의 아이디 설정
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        // 광고 로드
        bannerView.load(GADRequest())
        
        // 델리겟을 배너에 연결
        bannerView.delegate = self
        
        // 복용 시간 미입력시 약 추가 동작 안 되게끔 구현
        plusBtnEnabled()

        // 키보드 return시 내려가게 하기 위해 델리겟 설정
        nameTextField.delegate = self

        self.showTimePicker()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // 화면에 배너뷰를 추가
    func addBannerViewToView(_ bannerView: GADBannerView) {
        // 오토레이아웃으로 뷰를 설정
      bannerView.translatesAutoresizingMaskIntoConstraints = false
        //루트뷰에 배너를 추가
      view.addSubview(bannerView)
        // 앵커를 설정하여 오토레이아웃 설정
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    //MARK: - GADBannerViewDelegate 메소드
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
        // 화면에 배너뷰를 추가
        addBannerViewToView(bannerView)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
    
    // 뷰컨트롤러에 지난 날짜 삭제하기 위한 입력한 날짜 저장한 배열 전송
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationVC = segue.destination as? ViewController {
            destinationVC.notiIds = self.notificationIds
        }
        if let destinationVC = segue.destination as? EditViewController {
            destinationVC.editAddedTimeComponents = self.addedTimeComponents
        }
    }
    
    // 시간을 입력해야만 저장 버튼 활성화되게끔 하는 함수
    func plusBtnEnabled() {
        plusBtn.isEnabled = false
        textFieldTimePicker.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    @objc func textFieldDidChange() {
        if textFieldTimePicker.text != "" {
            plusBtn.isEnabled = true
        }
    }
    
    /// 복용 시간 설정을 위한 데이트피커
    private func showTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.minimumDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        timePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
        timePicker.addTarget(self, action: #selector(showTime(timePicker:)), for: .editingDidEnd)
        
        textFieldTimePicker.inputView = timePicker
        
        let timeToolbar = UIToolbar().TimetoolbarPicker(select: #selector(timeDismissPicker))
        self.textFieldTimePicker.inputAccessoryView = timeToolbar
    }

    
    @objc func showTime(timePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시 m분"
        let selectedTime = formatter.string(from: timePicker.date)
        
        // 지정한 시간에 알림 보내기 위한 시, 분 데이터 변수에 저장
        let time = timePicker.date
        let hour = Calendar.current.component(.hour, from: time)
        let minute = Calendar.current.component(.minute, from: time)
        
        var timeComponents = DateComponents()
        timeComponents.calendar = Calendar.current
        timeComponents.hour = hour
        timeComponents.minute = minute
        
        // 시간 값 배열에 넣기
        notificationTimeComponents.append(timeComponents)
        
        // 텍스트필드 데이터 입력되면 보이게끔
        if textFieldTimePicker.isEditing {
            textFieldTimePicker.text = selectedTime
        }
    }
    
    
    @objc func timeDismissPicker() {
        self.showTime(timePicker: timePicker)
        view.endEditing(true)
    }
    
    
    //MARK: - 로컬 노티피케이션 사용을 위한 함수

    
    /// 로컬 노티피케이션 사용을 위한 함수
    /// - Parameter title: 알림 이름
    /// - Returns: 스케줄링 처리가 된 알림 ID들
    func notificationSet(title: String) -> [String] {
        let content = UNMutableNotificationContent()
        content.title = "약 먹었니?"
        content.body = "\(title)을 먹을 시간입니다💊"
        content.sound = .default
        
        let notificationCenter = UNUserNotificationCenter.current()

        notificationIds = notificationTimeComponents.compactMap { timeComponents in

            let uuidString = UUID().uuidString

            // 트리거 반복 이벤트 만들기
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
            // 요청 생성
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            notificationRequests.append(request)
            print(#fileID, #function, #line, "- uuidString: \(uuidString)")

            notificationCenter.add(request) { (error) in
                if error != nil {
                    print("error: \(error)")
                }
            }
            // 추가된 시간대의 정보를 addedTimeComponents에 추가
            addedTimeComponents.insert(timeComponents)
            return uuidString
        }
        return notificationIds
    }
    
    func deleteNotification(_ notiIds: [String]) {
        let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: notiIds)
            notificationCenter.removeDeliveredNotifications(withIdentifiers: notiIds)
    }

    @IBAction func btnAdded(_ sender: UIButton) {
        
        // 새로운 약 추가
        let title = nameTextField.text ?? ""

        let time = textFieldTimePicker.text ?? ""
        
        let scheduledNotiIds = notificationSet(title: title)
        
        let newMedicine = MedicineData(title: title, time: time, notiIds: scheduledNotiIds)
    
        self.plusDelegate?.addNewMedicine(newMedicine)
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func btnCanceled(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}

extension PlusViewController: UITextFieldDelegate {
    // 키보드 리턴시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}

