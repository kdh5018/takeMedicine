//
//  EditViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit

//MARK: - 약 수정하기 페이지
class EditViewController: UIViewController {
    
    var tableIndex: Int!
    
    var prepareName: String?
    var prepareDate: String?
    var prepareMorningTime: String?
    var prepareDayTime: String?
    var prepareNightTime: String?
    
    
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editDateTextField: UITextField!
    @IBOutlet weak var editMorningTimeTextField: UITextField!
    @IBOutlet weak var editDayTimeTextField: UITextField!
    @IBOutlet weak var editNightTimeTextField: UITextField!
    
    @IBOutlet weak var editDayDelButton: UIButton!
    @IBOutlet weak var editNightDelButton: UIButton!
    
    @IBOutlet weak var plusBtn: UIButton!
    
    
    var editMedicineData: MedicineData?

    var editDelegate: MedicineDelegate? = nil
    
    var notificationDateComponents: [DateComponents] = []
    
    var hour = 0
    var minute = 0
    
    let editDatePicker = UIDatePicker()
    let editTimePicker = UIDatePicker()
    
    
    /// 시간 추가하기 버튼 클릭 시 복용 시간 추가 기능 구현
    var clickCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 return시 내려가게 하기 위해 델리겟 설정
        editNameTextField.delegate = self
        
        editNameTextField.text = prepareName
        editDateTextField.text = prepareDate
        editMorningTimeTextField.text = prepareMorningTime
        editDayTimeTextField.text = prepareDayTime
        editNightTimeTextField.text = prepareNightTime

        // if EditViewController를 열었을 때, 시간 텍스트필드가 비어 있으면 비어있는 텍스트필드는 숨기고 작성된 텍스트필드만 보이게
        editDayTimeTextField.isHidden = true
        editDayDelButton.isHidden = true
        if editDayTimeTextField.text != "" {
            editDayTimeTextField.isHidden = false
            editDayDelButton.isHidden = false
        }
        editNightTimeTextField.isHidden = true
        editNightDelButton.isHidden = true
        if editNightTimeTextField.text != "" {
            editNightTimeTextField.isHidden = false
            editNightDelButton.isHidden = false
        }

        self.showDatePicker()
        self.showTimePicker()
        
        self.hideKeyboardWhenTappedAround()
    }
        
    /// 복용 기간 설정을 위한 데이트피커
    func showDatePicker() {
        editDatePicker.datePickerMode = .date
        editDatePicker.preferredDatePickerStyle = .inline
        
        self.editDateTextField.inputView = editDatePicker
        
        let dateToolbar = UIToolbar().dateToolbarPicker(select: #selector(dateDismissPicker))
        self.editDateTextField.inputAccessoryView = dateToolbar
    }
    
    /// 복용 시간 설정을 위한 데이트피커
    private func showTimePicker() {
        editTimePicker.datePickerMode = .time
        editTimePicker.preferredDatePickerStyle = .wheels
        editTimePicker.minimumDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        editTimePicker.maximumDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())
        editTimePicker.addTarget(self, action: #selector(showTime(timePicker:)), for: .valueChanged)
        
        editMorningTimeTextField.inputView = editTimePicker
        editDayTimeTextField.inputView = editTimePicker
        editNightTimeTextField.inputView = editTimePicker
        
        let timeToolbar = UIToolbar().TimetoolbarPicker(select: #selector(timeDismissPicker))
        self.editMorningTimeTextField.inputAccessoryView = timeToolbar
        self.editDayTimeTextField.inputAccessoryView = timeToolbar
        self.editNightTimeTextField.inputAccessoryView = timeToolbar
    }
    
    @objc func showDate(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일까지"
        self.editDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func showTime(timePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "H시 m분"
        let selectedTime = formatter.string(from: timePicker.date)
        
        // 지정한 시간에 알림 보내기 위한 시, 분 데이터 변수에 저장
        let time = timePicker.date
        let hour = Calendar.current.component(.hour, from: time)
        let minute = Calendar.current.component(.minute, from: time)
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        notificationDateComponents.append(dateComponents)
        
        // 텍스트필드 데이터 입력되면 보이게끔
        if editMorningTimeTextField.isEditing {
            editMorningTimeTextField.text = selectedTime
        } else if editDayTimeTextField.isEditing {
            editDayTimeTextField.text = selectedTime
        } else if editNightTimeTextField.isEditing {
            editNightTimeTextField.text = selectedTime
        }
    }
    
    @objc func dateDismissPicker() {
        self.showDate(datePicker: editDatePicker)
        view.endEditing(true)
    }
    
    @objc func timeDismissPicker() {
        self.showTime(timePicker: editTimePicker)
        view.endEditing(true)
    }
    
    @IBAction func editTimeAdded(_ sender: UIButton) {
        clickCount += 1
        if clickCount == 1 {
            editDayTimeTextField.isHidden = false
            editDayDelButton.isHidden = false
        } else {
            editNightTimeTextField.isHidden = false
            editNightDelButton.isHidden = false
        }
    }
    
    
    @IBAction func editDayDelBtn(_ sender: UIButton) {
        editDayTimeTextField.isHidden = true
        editDayDelButton.isHidden = true
        clickCount = 0
        editDayTimeTextField.text = ""
        editMedicineData?.dayTime = ""
        
    }
    
    @IBAction func editNightDelBtn(_ sender: UIButton) {
        editNightTimeTextField.isHidden = true
        editNightDelButton.isHidden = true
        clickCount = 1
        editNightTimeTextField.text = ""
        editMedicineData?.nightTime = ""
    }

    
    
    @IBAction func btnEdited(_ sender: UIButton) {
        
        let title = editNameTextField.text ?? ""
        
        guard let dateInput = editDateTextField.text else {
            return
        }
    
        let date = dateInput.isEmpty ? "매일" : dateInput
        let morningTime = editMorningTimeTextField.text ?? ""
        let dayTime = editDayTimeTextField.text ?? ""
        let nightTime = editNightTimeTextField.text ?? ""
        
        let editMedicine = MedicineData(title: title, date: date, morningTime: morningTime, dayTime: dayTime, nightTime: nightTime)
        
        self.editDelegate?.update(index: tableIndex, editMedicine)
        
        //MARK: - 로컬 노티피케이션 사용을 위한 함수
        func notificationSet() {
            let content = UNMutableNotificationContent()
            content.title = "약 먹었니?"
            content.body = "\(title)을 먹을 시간입니다💊"
            content.sound = .default
            
            // 각 날짜 구성 요소에 대한 알림 요청 생성
            var notificationRequests: [UNNotificationRequest] = []
            
            for dateComponents in notificationDateComponents {
                // 트리거 반복 이벤트 만들기
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                // 요청 생성
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                notificationRequests.append(request)
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                    if error != nil {
                        print("error: \(error)")
                    }
                }
            }
        }

        notificationSet()

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
