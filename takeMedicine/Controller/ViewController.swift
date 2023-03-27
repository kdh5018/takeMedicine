//
//  ViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import UIKit
import RealmSwift

// 메인 페이지
class ViewController: UIViewController {
    
    var medicineDataManager = DataManager()
    
    @IBOutlet weak var medicineTableView: UITableView!
    
    
    var cell = MedicineTableViewCell()
    lazy var medicineTitle = cell.medicineName
    
    var selectedRows: Set<UUID> = []
    
    
//    let realm = try! Realm()
    
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        medicineTableView.estimatedRowHeight = UITableView.automaticDimension
        
        
        // 더미데이터를 이용하여 초기 화면 체크
        //        self.medicineDataList = MedicineData.getDummies()
    }
    
    // 서로의 메모리를 연결하기 위해 반드시 필요함⭐️
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationVC = segue.destination as? PlusViewController {
            destinationVC.Delegate = self
        }
        if let editDestinationVC = segue.destination as? EditViewController {
            editDestinationVC.EditDelegate = self
            editDestinationVC.titleValue = medicineTitle?.text ?? "error"
        }
    }
    

    
    // 약 추가하기 VC 로드
    @IBAction func plusVCLoaded(_ sender: UIButton) {
        guard let plusVC = self.storyboard?.instantiateViewController(identifier: "PlusViewController") as? PlusViewController else { return }
        plusVC.modalPresentationStyle = .fullScreen
        plusVC.Delegate = self
        self.present(plusVC, animated: true, completion: nil)
    }
    
    // 약 수정하기 VC 로드
    @IBAction func editVCLoaded(_ sender: UIButton) {
        guard let editVC = self.storyboard?.instantiateViewController(identifier: "EditViewController") as? EditViewController else { return }
        editVC.modalPresentationStyle = .fullScreen
        editVC.EditDelegate = self
        self.present(editVC, animated: true, completion: nil)
    }
    
    
    // 삭제버튼
    @IBAction func delBtn(_ sender: UIButton) {
        guard let indexPath = (sender.superview?.superview as? UIView)?.indexPathInTableView(medicineTableView) else { return }
        medicineDataManager.medicineDataArray.remove(at: indexPath.row)
        medicineTableView.reloadData()
        
    }
}

extension ViewController : UITableViewDataSource {
    // 입력한 약 종류 개수만큼 row출력
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineDataManager.getMedicineData().count
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
        
        // 테이블뷰셀 on/off를 위해 선택 여부 가져옴
        let isSelected = selectedRows.contains(cellData.id)
        cell.configureCell(isSelected: isSelected)
        
        
        return cell
        
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataList = medicineDataManager.getMedicineData()
        
        let selectedData = dataList[indexPath.row]
        
        
        if selectedRows.contains(selectedData.id) {
            selectedRows.remove(selectedData.id)
        } else {
            selectedRows.insert(selectedData.id)
        }
        
        
//        print("Selected cell at index: \(selectedData.id)")
        
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController: Delegate {
    func addNewMedicine(_ medicineData: MedicineData) {
        medicineDataManager.makeNewMedicine(medicineData)
        medicineTableView.reloadData()
    }

}
extension ViewController: EditDelegate {
    func getMedicine() {
        medicineDataManager.getMedicineData()
        medicineTableView.reloadData()
    }
    func update(index: Int, _ medicineData: MedicineData) {
        medicineDataManager.updateMedicine(index: index, medicineData)
        medicineTableView.reloadData()
    }
}


// 주어진 뷰에서 시작하여 해당 뷰의 superview를 차례대로 올라가며 UITableViewCell을 찾고, UITableViewCell을 찾으면 해당 셀의 indexPath를 UITableView의 indexPath(for:) 메소드를 사용하여 반환
extension UIView {
    func indexPathInTableView(_ tableView: UITableView) -> IndexPath? {
        var view: UIView? = self
        while view != nil && !(view is UITableViewCell) {
            view = view?.superview
        }
        guard let cell = view as? UITableViewCell else { return nil }
        return tableView.indexPath(for: cell)
    }
}
