//
//  EditViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit
protocol EditDelegate: AnyObject {
    func getMedicine()
    func update(index: Int, _ medicineData: MedicineData)
}

// 약 수정하기 페이지
class EditViewController: UIViewController {
    
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editDateTextField: UITextField!
    @IBOutlet weak var editMorningTimeTextField: UITextField!
    @IBOutlet weak var editDayTimeTextField: UITextField!
    @IBOutlet weak var editNightTimeTextField: UITextField!
    
    @IBOutlet weak var editDayDelButton: UIButton!
    @IBOutlet weak var editNightDelButton: UIButton!
    
    var editMedicineDataManager = DataManager()
    var VC = ViewController()
    var editMedicineData: MedicineData?
    var editDataManager: DataManager?
    
    var EditDelegate: EditDelegate?
    
    var titleValue: String = "" {
        didSet{
            guard let editMedicineData = editMedicineData else {
                return
            }
            editNameTextField.text = editMedicineData.title
            editDateTextField.text = editMedicineData.date
            editMorningTimeTextField.text = editMedicineData.morningTime
            editDayTimeTextField.text = editMedicineData.dayTime
            editNightTimeTextField.text = editMedicineData.nightTime
        }
    }
    
    
    let editDatePicker = UIDatePicker()
    let editTimePicker = UIDatePicker()
    
    /// 시간 추가하기 버튼 클릭 시 복용 시간 추가 기능 구현
    var clickCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNameTextField.text = titleValue
        editDateTextField.text = titleValue

        editDayTimeTextField.isHidden = true
        editDayDelButton.isHidden = true
        editNightTimeTextField.isHidden = true
        editNightDelButton.isHidden = true
        
        self.showDatePicker()
        self.showTimePicker()
        
        self.editHideKeyboardWhenTappedAround()
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
        dateFormatter.dateFormat = "M월 dd일까지"
        self.editDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func showTime(timePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "H시 mm분"
        let selectedTime = formatter.string(from: timePicker.date)
        
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
    }
    
    @IBAction func editNightDelBtn(_ sender: UIButton) {
        editNightTimeTextField.isHidden = true
        editNightDelButton.isHidden = true
        clickCount = 1
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
        
        let updateMedicine = MedicineData(title: title, date: date, morningTime: morningTime, dayTime: dayTime, nightTime: nightTime)
        
        // 🥲여기 인덱스에 들어갈 변수 찾는 법..
        EditDelegate?.update(index: 0, updateMedicine)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func editCanceled(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}


extension EditViewController {
    // 화면 터치시 키보드 내리기
    func editHideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension EditViewController: UITextFieldDelegate {
    // 키보드 return 시 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editNameTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension UIToolbar {
    // 복용 기간 텍스트필드
    func editDateToolbarPicker(select: Selector) -> UIToolbar {
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
    func editTimetoolbarPicker(select: Selector) -> UIToolbar {
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
