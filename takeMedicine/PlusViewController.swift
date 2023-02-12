//
//  PlusViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit

class PlusViewController: UIViewController {

    
    @IBOutlet weak var textFieldDatePicker: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showDatePicker()
        self.hideKeyboardWhenTappedAround()

    }
    func showDatePicker() {
//        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
//        datePicker.addTarget(self, action: #selector(showDate(datePicker:)), for: .valueChanged)
        self.textFieldDatePicker.inputView = datePicker
        
        let toolbar = UIToolbar().toolbarPicker(select: #selector(dismissPicker))
        self.textFieldDatePicker.inputAccessoryView = toolbar
    }
    
    @objc func dismissPicker() {
        self.showDate(datePicker: datePicker)
        view.endEditing(true)
    }
    
    @objc func showDate(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일까지"
        self.textFieldDatePicker.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    
    @IBAction func addBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}


extension PlusViewController {
    // 키보드 내리기
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIToolbar {
    // 복용기간 텍스트필드
    func toolbarPicker(select: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = .black
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "날짜 선택", style: .done, target: self, action: select)
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([doneBtn, spaceBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
}
