//
//  ViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    
    // 서로의 메모리를 연결하기 위해 반드시 필요함⭐️
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationVC = segue.destination as? PlusViewController {
            destinationVC.delegate = self
        }
    }
    
}

extension ViewController : UITableViewDataSource {
    // 입력한 약 종류 개수만큼 row출력
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineDataManager.getMedicineData().count
        //        return medicineDataList.count
    }
    // 입력한 약에 필요한 각각의 내용이 들어가는 내용
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
        // 현재 선택된 셀의 높이 가져오기
        let currentHeight = tableView.cellForRow(at: indexPath)?.frame.size.height ?? 0
        
        // 새로운 높이 계산하기
        let newHeight = currentHeight == 200 ? 100 : 200
        
        // 애니메이션 효과 적용하여 높이 변경하기
        UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)?.frame.size.height = CGFloat(newHeight)
        }
    }
}

extension ViewController: MedicineDelegate {
    func addNewMedicine(_ medicineData: MedicineData) {
        medicineDataManager.makeNewMedicine(medicineData)
        medicineTableView.reloadData()
    }
    func update(index: Int, _ medicineData: MedicineData) {
        medicineDataManager.updateMedicine(index: index, medicineData)
        medicineTableView.reloadData()
    }
}
