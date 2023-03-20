//
//  PlusViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit

protocol PlusDelegate: AnyObject {
    func addNewMedicine(_ medicineData: MedicineData)
}

class PlusViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldDatePicker: UITextField!
    @IBOutlet weak var textFieldTimeMorningPicker: UITextField!
    @IBOutlet weak var textFieldTimeDayPicker: UITextField!
    @IBOutlet weak var textFieldTimeNightPicker: UITextField!
    
    @IBOutlet weak var dayDelButton: UIButton!
    @IBOutlet weak var nightDelButton: UIButton!
    

    var medicineDataManager = DataManager()
    var viewController = ViewController()
    var plusDelegate: PlusDelegate?
    var medicineData: MedicineData?
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    /// 시간 추가하기 버튼 클릭 시 복용 시간 추가 기능 구현
    var clickCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        textFieldTimeDayPicker.isHidden = true
        dayDelButton.isHidden = true
        textFieldTimeNightPicker.isHidden = true
        nightDelButton.isHidden = true
        
        self.showDatePicker()
        self.showTimePicker()
        
        self.hideKeyboardWhenTappedAround()
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
        dateFormatter.dateFormat = "M월 dd일까지"
        self.textFieldDatePicker.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func showTime(timePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "H시 mm분"
        let selectedTime = formatter.string(from: timePicker.date)
        
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
        
        let newMedicine = MedicineData(title: title, date: date, morningTime: morningTime, dayTime: dayTime, nightTime: nightTime)
        
        plusDelegate?.addNewMedicine(newMedicine)
        
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func btnCanceled(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}

extension PlusViewController {
    // 화면 터치시 키보드 내리기
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PlusViewController: UITextFieldDelegate {
    // 키보드 return 시 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}


extension UIToolbar {
    // 복용 기간 텍스트필드
    func dateToolbarPicker(select: Selector) -> UIToolbar {
        let dateToolbar = UIToolbar()
        
        dateToolbar.barStyle = .default
        dateToolbar.isTranslucent = true
        dateToolbar.tintColor = .black
        dateToolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "날짜 선택", style: .done, target: self, action: select)
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        dateToolbar.setItems([doneBtn, spaceBtn], animated: false)
        dateToolbar.isUserInteractionEnabled = true
        
        return dateToolbar
    }
    
    // 복용 시간 텍스트필드
    func TimetoolbarPicker(select: Selector) -> UIToolbar {
        let timeToolbar = UIToolbar()
        
        timeToolbar.barStyle = .default
        timeToolbar.isTranslucent = true
        timeToolbar.tintColor = .black
        timeToolbar.sizeToFit()
        
        let timeDoneBtn = UIBarButtonItem(title: "시간 선택", style: .done, target: self, action: select)
        let timeSpaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        timeToolbar.setItems([timeDoneBtn, timeSpaceBtn], animated: false)
        timeToolbar.isUserInteractionEnabled = true
        
        return timeToolbar
    }
}
