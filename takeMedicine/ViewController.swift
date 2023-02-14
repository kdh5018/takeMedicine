//
//  ViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import UIKit

class ViewController: UIViewController {
    
    var medicineDataList: [MedicineData] = [
        MedicineData(title: "유산균", date: "2월20일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
        MedicineData(title: "감기약", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
        MedicineData(title: "감기약", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
        MedicineData(title: "감기약", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
        MedicineData(title: "감기약", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
        MedicineData(title: "감기약", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
        MedicineData(title: "감기약", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
        MedicineData(title: "감기약", date: "2월27일까지", morningTime: "8시", dayTime: "12시", nightTime: "18시"),
 
    ]
    
    @IBOutlet weak var medicineTableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        medicineTableView.rowHeight = 200
    }
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as? MedicineTableViewCell else {
//            return UITableViewCell()
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicineTableViewCell
        
        let cellData = medicineDataList[indexPath.row]
        
        cell.medicineName?.text = cellData.title
        cell.medicineDate?.text = cellData.date
        cell.medicineMorningTime?.text = cellData.morningTime
        cell.medicineDayTime?.text = cellData.dayTime
        cell.medicineNightTime?.text = cellData.nightTime
        
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 테이블셀 누르면 수정하기/삭제하기 버튼 보이고 숨기고 기능 넣기
        
    }
}


