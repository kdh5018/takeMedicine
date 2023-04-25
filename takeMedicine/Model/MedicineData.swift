//
//  MedicineData.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import Foundation
//import Fakery


class MedicineData: NSObject, NSCoding, NSSecureCoding, Codable {
    
    static var supportsSecureCoding: Bool = true
    
    var id : UUID = UUID()
    
    private (set) var title: String
    private (set) var date: String?
    private (set) var morningTime: String
    private (set) var dayTime: String?
    private (set) var nightTime: String?
    
    
    //    let title: String
    //    let date: String?
    //    let morningTime: String
    //    let dayTime: String?
    //    let nightTime: String?
    
    /// medicineData 생성자
    /// - Parameters:
    ///   - title: 약 이름
    ///   - date: 복용 기간
    ///   - morningTime: 복용 시간1
    ///   - dayTime: 복용 시간2
    ///   - nightTime: 복용 시간3
    init(title: String, date: String, morningTime: String, dayTime: String?, nightTime: String?) {
        
        self.title = title
        self.date = date
        self.morningTime = morningTime
        self.dayTime = dayTime
        self.nightTime = nightTime
        
    }
    //MARK: - 모델 데이터 확인용
    var info : String {
        get{
            return "title: \(title), date: \(date), morningTime: \(morningTime), dayTime: \(dayTime), nightTime: \(nightTime)"
        }
    }
    
    //MARK: - hashable 프로토콜 준수용
    static func == (lhs: MedicineData, rhs: MedicineData) -> Bool {
        lhs.id == rhs.id
    }
    
    //MARK: - NSCoding을 사용할 때 필요한 것들
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.morningTime, forKey: "morningTime")
        coder.encode(self.dayTime, forKey: "dayTime")
        coder.encode(self.nightTime, forKey: "nightTime")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObject(forKey: "title") as? String,
              let date = decoder.decodeObject(forKey: "date") as? String,
              let morningTime = decoder.decodeObject(forKey: "morningTime") as? String,
              let dayTime = decoder.decodeObject(forKey: "dayTime") as? String,
              let nightTime = decoder.decodeObject(forKey: "nightTime") as? String
        else { return nil }
        self.init(title: title, date: date, morningTime: morningTime, dayTime: dayTime, nightTime: nightTime)
    }
    
    static func createNewMedicine(with newValue: String) -> MedicineData{
        print(#fileID, #function, #line, "- createNewMedicine() called / newValue: \(newValue)")
        return MedicineData(title: newValue, date: newValue, morningTime: newValue, dayTime: newValue, nightTime: newValue)
    }
    
}

//MARK: - 목업데이터 헬퍼
//extension MedicineData {
//
//    static let dummyTitles : [String] = ["감기약", "목감기약", "유산균", "비타민"]
//    static let dummyDates : [String] = ["2월27일까지", "2월20일까지", "1월30일까지", "3월01일까지"]
//    static let dummyTimes : [String] = ["2시", "3시", "12시", "5시"]
//
//    static func getDummy() -> Self {
//
//        let dummyTitle = dummyTitles.randomElement()!
//        let dummyDate = dummyDates.randomElement()!
//        let dummyMorningTime = dummyTimes.randomElement()!
//        let dummyDayTime = dummyTimes.randomElement()!
//        let dummyNightTime = dummyTimes.randomElement()!
//
//        return MedicineData(title: dummyTitle,
//                            date: dummyDate,
//                            morningTime: dummyMorningTime,
//                            dayTime: dummyDayTime,
//                            nightTime: dummyNightTime)
//    }
//
//    static func getDummies(count: Int = 10) -> [MedicineData] {
//
//        var results : [MedicineData] = []
//
//        for _ in 0..<count {
//            results.append(MedicineData.getDummy())
//        }
//        return results
//    }

//    static func getDummyWithFakery() -> Self {
//        let faker = Faker(locale: "ko")
//
//        let firstName = faker.name.firstName()  //=> "Emilie"
//        let lastName = faker.name.lastName()    //=> "Hansen"
//        let city = faker.address.city()         //=> "Oslo"
//
//        let dayformatter = DateFormatter()
//        dayformatter.dateFormat = "yyyy-MM-dd"
//
//        let timeformatter = DateFormatter()
//        timeformatter.dateFormat = "HH:mm:ss"
//
//        let randomDate = faker.date.birthday(0, 10)
//
//        let dummyData = MedicineData(title: faker.lorem.words(amount: 3),
//                                     date: dayformatter.string(from: randomDate),
//                                     morningTime: timeformatter.string(from: randomDate),
//                                     dayTime: timeformatter.string(from: randomDate),
//                                     nightTime: timeformatter.string(from: randomDate))
//        return dummyData
//    }
//
//
//    static func getDummiesWithFakery(count: Int = 10) -> [MedicineData] {
//
//        var results : [MedicineData] = []
//
//        for _ in 0..<count {
//            results.append(MedicineData.getDummyWithFakery())
//        }
//        return results
//    }
//}
