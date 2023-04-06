//
//  Delegate.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/04/04.
//

import Foundation

protocol Delegate: AnyObject {
    func addNewMedicine(_ medicineData: MedicineData)
    func getMedicine()
    func update(index: Int, _ medicineData: MedicineData)
}
