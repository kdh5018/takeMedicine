//
//  DataManager.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/16.
//

import UIKit

class DataManager {
    var medicineDataArray: [MedicineData] = []
    
    func makeMedicineData() {
        medicineDataArray = []
    }
    
    func makeNewMedicine(_ medicineData: MedicineData) {
        medicineDataArray.append(medicineData)
    }
    
    func getMedicineData() -> [MedicineData] {
        return medicineDataArray
    }
    
    func updateMedicine(index: Int, _ medicineData: MedicineData) {
        medicineDataArray[index] = medicineData
    }
    
}

protocol MedicineDelegate{
    func addNewMedicine(_ medicineData: MedicineData)
    func getMedicine()
    func update(index: Int, _ medicineData: MedicineData)
}
