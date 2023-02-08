//
//  MedicineData.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import Foundation

struct MedicineData {
    

    let title: String
    let date: String
    let time: String
    
    init() {
        self.title = "약 이름"
        self.date = "복용 날짜"
        self.time = "복용 시간"
    }
    
    static func getMedicine(_ count: Int = 100) -> [MedicineData] {
        return (1...count).map{ _ in MedicineData() }
    }
}
