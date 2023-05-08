//
//  PlusViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit


//MARK: - 약 추가하기 페이지
class PlusViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldDatePicker: UITextField!
    @IBOutlet weak var textFieldTimeMorningPicker: UITextField!
    @IBOutlet weak var textFieldTimeDayPicker: UITextField!
    @IBOutlet weak var textFieldTimeNightPicker: UITextField!
    
    @IBOutlet weak var plusBtn: UIButton!
    
    @IBOutlet weak var dayDelButton: UIButton!
    @IBOutlet weak var nightDelButton: UIButton!
    
    var plusDelegate: MedicineDelegate?
    
    // 설정한 날짜가 지나면 그 데이터를 지우기 위한 날짜 값 저장하는 배열
    var deleteDateComponents: [DateComponents] = []
    
    // 시간 값 저장하는 배열
    var notificationTimeComponents: [DateComponents] = []
    
    // 각 날짜 구성 요소에 대한 알림 요청 생성
    var notificationRequests: [UNNotificationRequest] = []
    var notificationIds: [String] = []
    
    var hour = 0
    var minute = 0
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    /// 시간 추가하기 버튼 클릭 시 복용 시간 추가 기능 구현
    var clickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 복용 시간 미입력시 약 추가 동작 안 되게끔 구현
        plusBtnEnabled()
        
        print(#fileID, #function, #line, "- deleteDateComponents타입: \(type(of: deleteDateComponents))")
        
        // 키보드 return시 내려가게 하기 위해 델리겟 설정
        nameTextField.delegate = self
        
        textFieldTimeDayPicker.isHidden = true
        dayDelButton.isHidden = true
        textFieldTimeNightPicker.isHidden = true
        nightDelButton.isHidden = true
        
        self.showDatePicker()
        self.showTimePicker()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // 뷰컨트롤러에 지난 날짜 삭제하기 위한 입력한 날짜 저장한 배열 전송
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationVC = segue.destination as? ViewController {
            destinationVC.deleteDate = self.deleteDateComponents
        }
    }
    
    // 시간을 입력해야만 저장 버튼 활성화되게끔 하는 함수
    func plusBtnEnabled() {
        plusBtn.isEnabled = false
        textFieldTimeMorningPicker.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    @objc func textFieldDidChange() {
        if textFieldTimeMorningPicker.text != "" {
            plusBtn.isEnabled = true
        }
    }
    
    /// 복용 기간 설정을 위한 데이트피커
    func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        self.textFieldDatePicker.inputView = datePicker
        
        let dateToolbar = UIToolbar().dateToolbarPicker(select: #selector(dateDismissPicker))
        self.textFieldDatePicker.inputAccessoryView = dateToolbar
    }
    
    /// 복용 시간 설정을 위한 데이트피커
    private func showTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.minimumDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        timePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
        timePicker.addTarget(self, action: #selector(showTime(timePicker:)), for: .valueChanged)
        
        textFieldTimeMorningPicker.inputView = timePicker
        textFieldTimeDayPicker.inputView = timePicker
        textFieldTimeNightPicker.inputView = timePicker
        
        let timeToolbar = UIToolbar().TimetoolbarPicker(select: #selector(timeDismissPicker))
        self.textFieldTimeMorningPicker.inputAccessoryView = timeToolbar
        self.textFieldTimeDayPicker.inputAccessoryView = timeToolbar
        self.textFieldTimeNightPicker.inputAccessoryView = timeToolbar
    }
    
    @objc func showDate(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일까지"
        self.textFieldDatePicker.text = dateFormatter.string(from: datePicker.date)
        
        let date = datePicker.date
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        // 날짜 값 배열에 넣기
        deleteDateComponents.append(dateComponents)
    }
    
    @objc func showTime(timePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "H시 m분"
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
        if textFieldTimeMorningPicker.isEditing {
            textFieldTimeMorningPicker.text = selectedTime
        } else if textFieldTimeDayPicker.isEditing {
            textFieldTimeDayPicker.text = selectedTime
        } else if textFieldTimeNightPicker.isEditing {
            textFieldTimeNightPicker.text = selectedTime
        }
    }
    
    @objc func dateDismissPicker() {
        self.showDate(datePicker: datePicker)
        view.endEditing(true)
    }
    
    @objc func timeDismissPicker() {
        self.showTime(timePicker: timePicker)
        view.endEditing(true)
    }
    
    
    @IBAction func timeAdded(_ sender: UIButton) {
        clickCount += 1
        if clickCount == 1 {
            textFieldTimeDayPicker.isHidden = false
            dayDelButton.isHidden = false
        } else {
            textFieldTimeNightPicker.isHidden = false
            nightDelButton.isHidden = false
        }
    }
    
    @IBAction func dayDelBtn(_ sender: UIButton) {
        textFieldTimeDayPicker.isHidden = true
        dayDelButton.isHidden = true
        clickCount = 0
    }
    
    @IBAction func nightDelBtn(_ sender: UIButton) {
        textFieldTimeNightPicker.isHidden = true
        nightDelButton.isHidden = true
        // 2번째 시간 넣기 있으면 클릭카운트 1 , 2번째 시간 넣기 없으면 클릭카운트 0
        if textFieldTimeDayPicker.isHidden == false {
            clickCount = 1
        } else {
            clickCount = 0
        }
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
        notificationCenter.removeAllPendingNotificationRequests()
        
        for timeComponents in notificationTimeComponents {
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
            notificationIds.append(uuidString)
        }
        
        return notificationIds
    }
    
    func deleteNotification(_ notiIds: [String]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: notiIds)
        
    }
    
    
    
    
    @IBAction func btnAdded(_ sender: UIButton) {
        
        // 새로운 약 추가
        let title = nameTextField.text ?? ""
        
        // 복용 날짜 비어있으면 매일 출력 아니면 입력 날짜 출력
        guard let dateInput = textFieldDatePicker.text else {
            return
        }
        
        let date = dateInput.isEmpty ? "매일" : dateInput
        let morningTime = textFieldTimeMorningPicker.text ?? ""
        let dayTime = textFieldTimeDayPicker.text ?? ""
        let nightTime = textFieldTimeNightPicker.text ?? ""
        
        let scheduledNotiIds = notificationSet(title: title)
        
        let newMedicine = MedicineData(title: title, date: date, morningTime: morningTime, dayTime: dayTime, nightTime: nightTime, notiIds: scheduledNotiIds)
        
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
