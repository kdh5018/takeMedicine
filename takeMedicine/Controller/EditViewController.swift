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
    
    var editMedicineData: MedicineData?

    var editDelegate: MedicineDelegate? = nil
    
    
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
//        if editDayTimeTextField.text == nil {
//            editDayTimeTextField.isHidden = true
//            editDayDelButton.isHidden = true
//        }
//        if editNightTimeTextField.text == nil {
//            editNightTimeTextField.isHidden = true
//            editNightDelButton.isHidden = true
//        }
        
        
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
        
        let editMedicine = MedicineData(title: title, date: date, morningTime: morningTime, dayTime: dayTime, nightTime: nightTime)
        

        print(#fileID, #function, #line, "- editMedicine : \(editMedicine)")
        self.editDelegate?.update(index: tableIndex, editMedicine)
        

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
