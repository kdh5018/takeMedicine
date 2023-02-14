//
//  PlusViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit

class PlusViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldDatePicker: UITextField!
    @IBOutlet weak var textFieldTimePicker: UITextField!
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        self.showDatePicker()
        self.showTimePicker()
        self.hideKeyboardWhenTappedAround()

    }
    
    
    func showDatePicker() {
//        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
//        datePicker.addTarget(self, action: #selector(showDate(datePicker:)), for: .valueChanged)
        self.textFieldDatePicker.inputView = datePicker
        
        let dateToolbar = UIToolbar().dateToolbarPicker(select: #selector(dateDismissPicker))
        self.textFieldDatePicker.inputAccessoryView = dateToolbar
    }
    
    func showTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        self.textFieldTimePicker.inputView = timePicker
        
        let timeToolbar = UIToolbar().TimetoolbarPicker(select: #selector(timeDismissPicker))
        self.textFieldTimePicker.inputAccessoryView = timeToolbar
    }
    
    @objc func dateDismissPicker() {
        self.showDate(datePicker: datePicker)
        view.endEditing(true)
    }
    
    @objc func timeDismissPicker() {
        self.showTime(timePicker: timePicker)
        view.endEditing(true)
        
    }
    
    @objc func showDate(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일까지"
        self.textFieldDatePicker.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    @objc func showTime(timePicker: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH시 mm분"
        self.textFieldTimePicker.text = timeFormatter.string(from: timePicker.date)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
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
