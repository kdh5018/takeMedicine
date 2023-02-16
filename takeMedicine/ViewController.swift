//
//  ViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import UIKit

class ViewController: UIViewController {
    
//    var medicineDataList: [MedicineData] = []
//    {
//        didSet{
//            print(#fileID, #function, #line, "- medicineDataList: \(medicineDataList.count)")
//            DispatchQueue.main.async {
//                self.medicineTableView.reloadData()
//            }
//        }
//    }
    var medicineDataManager = DataManager()

    
    @IBOutlet weak var medicineTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        medicineTableView.estimatedRowHeight = UITableView.automaticDimension
        
        // 빈 배열에 데이터 생성
        medicineDataManager.makeMedicineData()
        // 데이터 불러오기
        medicineDataManager.getMedicineData()
        
        // 더미데이터를 이용하여 초기 화면 체크
//        self.medicineDataList = MedicineData.getDummies()
    }
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineDataManager.getMedicineData().count
//        return medicineDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicineTableViewCell.reuseId, for: indexPath) as? MedicineTableViewCell else {
            return UITableViewCell()
        }
        
        let array = medicineDataManager.getMedicineData()
        
        let cellData = array[indexPath.row]
        
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


