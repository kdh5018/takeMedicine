//
//  DataManager.swift
//  takeMedicine
//
//  Created by κΉλν on 2023/02/16.
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
