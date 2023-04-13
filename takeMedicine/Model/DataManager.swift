//
//  DataManager.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/16.
//

import UIKit

class DataManager {
    var medicineDataArray: [MedicineData] = []
    
    init(){
        print(#fileID, #function, #line, "- ")
        if let storedMedicineDataArray = UserDefaultsManager.shared.getMedicineList() {
            self.medicineDataArray = storedMedicineDataArray
        }
    }
    
    /// 새 데이터 추가
    /// - Parameter medicineData:
    func makeNewMedicine(_ medicineData: MedicineData) {
        medicineDataArray.append(medicineData)
        
        UserDefaultsManager.shared.setMedicineList(with: medicineDataArray)
        
    }
    
    func getMedicineData() -> [MedicineData] {
        return medicineDataArray
    }
    
    func updateMedicine(index: Int, _ medicineData: MedicineData) {
        medicineDataArray[index] = medicineData
        
        UserDefaultsManager.shared.setMedicineList(with: medicineDataArray)
    }
    func deleteMedicine(index: Int) {
        medicineDataArray.remove(at: index)
        
        UserDefaultsManager.shared.clearMedicineList()
        UserDefaultsManager.shared.setMedicineList(with: medicineDataArray)
    }

}

protocol MedicineDelegate{
    func addNewMedicine(_ medicineData: MedicineData)
    func getMedicine()
    func update(index: Int, _ medicineData: MedicineData)
    func delete(index: Int)
}
