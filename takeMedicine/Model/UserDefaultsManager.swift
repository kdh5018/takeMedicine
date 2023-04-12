//
//  UserDefaultsManager.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/04/01.
//

import Foundation

/// 로컬 데이터 저장 매니저
/// 싱글톤 객체
class UserDefaultsManager {
    
    enum Key: String, CaseIterable {
        case medicineList
    }
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
    
    //MARK: - 약 데이터 관련
    /// 약 목록 추가 및 저장하기(encode)
    /// - Parameter newValue: 저장할 값
    func setMedicineList(with newValue: [MedicineData]) {
        print(#fileID, #function, #line, "- newValue.count: \(newValue.count)")
        do {
            let data = try PropertyListEncoder().encode(newValue)
            newValue.forEach{ print("저장될 데이터: \($0.info)") }
            UserDefaults.standard.set(data, forKey: Key.medicineList.rawValue)
            UserDefaults.standard.synchronize()
            print("UserDefaultsManager - setMedicineList() 메모리 저장됨")
        } catch { 
            print("에러 발생 setMedicineList - error: \(error)")
        }
    }// setMedicineList()
    
    /// 저장된 약 목록 가져오기(decode)
    /// - Returns: 저장된 값
    func getMedicineList() -> [MedicineData]? {
        print("UserDefaultsManager - getMedicineList() called")
        if let data = UserDefaults.standard.object(forKey: Key.medicineList.rawValue) as? NSData {
            print("저장된 데이터: \(data)")
            do {
                let medicineList = try PropertyListDecoder().decode([MedicineData].self, from: data as Data)
                return medicineList
            } catch {
                print("에러 발생 getMedicineList - error: \(error)")
            }
        }
        return nil
    } // getMedicineList()

    
    /// 약 목록 삭제
    func clearMedicineList() {
        print("UserDefaultsManager - clearMedicineList() called")
        UserDefaults.standard.removeObject(forKey: Key.medicineList.rawValue)
    }// clearMedicineList()
    
}
