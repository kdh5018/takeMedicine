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

    func updateMedicine(uuid: UUID, _ medicineData: MedicineData) {
        
        // 1. 고유키로 해당 데이터 찾기
        
        guard let foundIndex = medicineDataArray.firstIndex(where: { $0.id == uuid}) else { return }
        
        medicineDataArray[foundIndex] = medicineData
        
        UserDefaultsManager.shared.setMedicineList(with: medicineDataArray)
    }

    
    func deleteMedicineWithUUID(uuid: UUID) {
        guard let index = medicineDataArray.firstIndex(where: { $0.id == uuid }) else {
            return
        }
        medicineDataArray.remove(at: index)

        UserDefaultsManager.shared.clearMedicineList()
        UserDefaultsManager.shared.setMedicineList(with: medicineDataArray)
    }
}

protocol MedicineDelegate{
    func addNewMedicine(_ medicineData: MedicineData)
    func getMedicine()
    func update(uuid: UUID, _ medicineData: MedicineData)
    func delete(uuid: UUID)
}
