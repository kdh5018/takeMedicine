//
//  ViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var medicineTableView: UITableView!
    
    
    var medicineDataList: [MedicineData] = MedicineData.getMedicine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                medicineTableView.dataSource = self
                medicineTableView.delegate = self
            }
        
    }
    
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell : MedicineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MedicineTableViewCell else {
            return UITableViewCell()
        }

        let cellData : MedicineData = medicineDataList[indexPath.row]

        cell.medicineName?.text = cellData.title
        cell.medicineDate?.text = cellData.date
        cell.medicineTime1?.text = cellData.time

        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 테이블셀 누르면 수정하기/삭제하기 버튼 보이고 숨기고 기능 넣기
        print(#fileID, #function, #line, "- indexPath: \(indexPath.row)")
    }
}


