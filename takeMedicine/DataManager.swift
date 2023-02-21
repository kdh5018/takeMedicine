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
        medicineDataArray = [
            MedicineData(title: "유산균", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
            MedicineData(title: "비타민", date: "2월28일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
            MedicineData(title: "감기약", date: "2월29일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시")
        ]
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
