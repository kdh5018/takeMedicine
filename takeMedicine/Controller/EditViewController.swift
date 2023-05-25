//
//  EditViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit
import GoogleMobileAds

//MARK: - 약 수정하기 페이지
class EditViewController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    
    var prepareName: String?
    var prepareTime: String?
    
    
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editTimeTextField: UITextField!
    
    
    let PV = PlusViewController()
    
    var editMedicineData: MedicineData?
    
    var editDelegate: MedicineDelegate? = nil

    
    // 시간 값 저장하는 배열
    var notificationTimeComponents: [DateComponents] = []
    
    // 각 날짜 구성 요소에 대한 알림 요청 생성
    var notificationRequests: [UNNotificationRequest] = []
    var notificationIds: [String] = []
    
    // 뷰컨에서 넘어온 노티아이디
    var existedNotiIds: [String] = []
    
    var editAddedTimeComponents = Set<DateComponents>()
    
    var hour = 0
    var minute = 0
    
    let editDatePicker = UIDatePicker()
    let editTimePicker = UIDatePicker()
    
    
    /// 시간 추가하기 버튼 클릭 시 복용 시간 추가 기능 구현
    var clickCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배너 사이즈 설정
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        // 광고 배너의 아이디 설정
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        // 광고 로드
        bannerView.load(GADRequest())
        
        // 델리겟을 배너에 연결
        bannerView.delegate = self
        
        // 키보드 return시 내려가게 하기 위해 델리겟 설정
        editNameTextField.delegate = self
        
        editNameTextField.text = prepareName
        editTimeTextField.text = prepareTime
        
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

    /// 복용 시간 설정을 위한 데이트피커
    private func showTimePicker() {
        editTimePicker.datePickerMode = .time
        editTimePicker.preferredDatePickerStyle = .wheels
        editTimePicker.minimumDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        editTimePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
        editTimePicker.addTarget(self, action: #selector(showTime(timePicker:)), for: .editingDidEnd)
        
        editTimeTextField.inputView = editTimePicker
        
        let timeToolbar = UIToolbar().TimetoolbarPicker(select: #selector(timeDismissPicker))
        self.editTimeTextField.inputAccessoryView = timeToolbar
    }
    
    
    @objc func showTime(timePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시 m분"
        let selectedTime = formatter.string(from: timePicker.date)
        

        
        // 지정한 시간에 알림 보내기 위한 시, 분 데이터 변수에 저장
        let time = timePicker.date
        let hour = Calendar.current.component(.hour, from: time)
        let minute = Calendar.current.component(.minute, from: time)
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // 시간 값 배열에 넣기
        notificationTimeComponents.append(dateComponents)
        
        // 텍스트필드 데이터 입력되면 보이게끔
        if editTimeTextField.isEditing {
            editTimeTextField.text = selectedTime
        }
    }

    
    @objc func timeDismissPicker() {
        self.showTime(timePicker: editTimePicker)
        view.endEditing(true)
    }

    
    //MARK: - 로컬 노티피케이션 사용을 위한 함수
    func editNotificationSet(title: String) -> [String] {
        
        let content = UNMutableNotificationContent()
        content.title = "약 먹었니?"
        content.body = "\(title)을 먹을 시간입니다💊"
        content.sound = .default

        notificationIds = notificationTimeComponents.compactMap{ timeComponents in
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            let uuidString = UUID().uuidString
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            notificationRequests.append(request)
            
            notificationCenter.add(request) { error in
                if let error = error {
                    print("error: \(error)")
                }
            }
            editAddedTimeComponents.insert(timeComponents)
            return uuidString
        }
    
        return notificationIds
        
    }
    
    
    @IBAction func btnEdited(_ sender: UIButton) {
        
        // 여기서 기존의 알림이 삭제가 되어야 함
        PV.deleteNotification(existedNotiIds)

        
        let title = editNameTextField.text ?? ""
        
        let time = editTimeTextField.text ?? ""
        
        editMedicineData?.title = title
        editMedicineData?.time = time
        
        let editScheduledIds = editNotificationSet(title: title)
        
        editMedicineData?.notiIds = editScheduledIds
        
        self.editDelegate?.update(uuid: editMedicineData!.id, editMedicineData!)

        self.dismiss(animated: true)
        
    }
    
    @IBAction func editCanceled(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension EditViewController: UITextFieldDelegate {
    // 키보드 리턴시 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editNameTextField {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}
