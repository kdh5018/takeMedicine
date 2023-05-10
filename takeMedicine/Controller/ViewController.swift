//
//  ViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/08.
//

import UIKit

//MARK: - 메인 페이지
class ViewController: UIViewController {
    
    var medicineDataManager = DataManager()
    
    var medicineData: MedicineData?
    
    let EV = EditViewController()
    
    let PV = PlusViewController()
    
    // 기간이 지난 날짜를 자동으로 삭제하기 위한 딕셔너리
    var deleteDate: [Int : DateComponents] = [:]
    
    @IBOutlet weak var navToPlusVCBtn: UIButton!
    
    @IBOutlet weak var medicineTableView: UITableView!
    
    let medicineCell = MedicineTableViewCell()
    
    // 테이블뷰셀 클릭시 버튼 보임/숨김을 위한 행 번호 변수
    var selectedRows: Set<UUID> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastDateDeleted()

        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        medicineTableView.estimatedRowHeight = UITableView.automaticDimension
        
        
        // 더미데이터를 이용하여 초기 화면 체크
        //        self.medicineDataList = MedicineData.getDummies()
    }
    
    // 지정한 날짜보다 기간이 지나면 자동으로 삭제해주는 함수
    func pastDateDeleted() {
            
        let today = Date()
        let calendar = Calendar.current
        let dateKeys = Array(deleteDate.keys)
        let dateComponentsArray = Array(deleteDate.values)
        let dateArray = dateComponentsArray.compactMap { calendar.date(from: $0) }
            
        for (index, date) in dateArray.enumerated() {
            if today > date {
                let key = dateKeys[index]
                deleteDate.removeValue(forKey: key)
            }
        }
        
        UserDefaultsManager.shared.clearMedicineList()
        medicineTableView.reloadData()
    }



    
    
    //MARK: - 메모리 연결
    // 서로의 메모리를 연결하기 위해 반드시 필요함⭐️
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationVC = segue.destination as? PlusViewController {
            
            // PlusViewController(destinationVC)과 ViewController를 델리겟으로 연결⭐️
            // extension으로 ViewController에 뷰컨트롤러를 정의했기 때문에 ViewController가 Delegate를 준수하기 때문에 self로 연결이 됨
            destinationVC.plusDelegate = self
        }
        if let editDestinationVC = segue.destination as? EditViewController,
           let selectedData = sender as? (medicineData: MedicineData, indexPath: IndexPath){
            
            // EditViewController(editDestinationVC)과 ViewController를 델리겟으로 연결⭐️
            // extension으로 ViewController에 뷰컨트롤러를 정의했기 때문에 ViewController가 Delegate를 준수하기 때문에 self로 연결이 됨
            editDestinationVC.editDelegate = self
            
            let editMedicineData = selectedData.medicineData
            let indexPath = selectedData.indexPath
            
            editDestinationVC.editMedicineData = editMedicineData
            editDestinationVC.tableIndex = indexPath.row
            
            editDestinationVC.prepareName = editMedicineData.title
            editDestinationVC.prepareDate = editMedicineData.date
            editDestinationVC.prepareMorningTime = editMedicineData.morningTime
            editDestinationVC.prepareDayTime = editMedicineData.dayTime
            editDestinationVC.prepareNightTime = editMedicineData.nightTime
        }
        
    }
    
    // 약 추가하기 VC 로드
    @IBAction func plusVCLoaded(_ sender: UIButton) {
        guard let plusVC = self.storyboard?.instantiateViewController(identifier: "PlusViewController") as? PlusViewController else { return }
        plusVC.plusDelegate = self
        self.present(plusVC, animated: true, completion: nil)
    }
    
}


//MARK: - 데이터 소스 관련
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
        
        
        /// MedicineTableVeiwCell에 configureCell에서 업데이트를 해주기 때문에 뷰컨에서 다시 데이터를 받아올 필요 없이 configureCell만 호출해주면 됨
        //        cell.medicineName?.text = cellData.title
        //        cell.medicineDate?.text = cellData.date
        //        cell.medicineMorningTime?.text = cellData.morningTime
        //        cell.medicineDayTime?.text = cellData.dayTime
        //        cell.medicineNightTime?.text = cellData.nightTime
        
        // 테이블뷰셀 on/off를 위해 선택 여부 가져옴
        let isSelected = selectedRows.contains(cellData.id)
        cell.configureCell(cellData: cellData, isSelected: isSelected, indexPath: indexPath)
        
        // 수정하기 버튼 클릭시 EditViewController 띄워줌
        cell.onCellEditBtnClicked = {
            [weak self] (selectedMedicineData: MedicineData, indexPath: IndexPath) in
            
            guard let self = self else { return }
            
            let data = (medicineData: selectedMedicineData, indexPath: indexPath)
            
            self.performSegue(withIdentifier: "EditViewController", sender: data)
            print(#fileID, #function, #line, "- 수정하기 화면 넘어감")
        }
        
        // 삭제하기 버튼 클릭하면 해당하는 테이블뷰셀 삭제
        // 넘기거나 하는 다음 과정이 없기 때문에 여기서 바로 지워도 됨
        cell.onCellDeleteBtnClicked = {
            [weak self] (indexPath: IndexPath) in
            guard let self = self else { return }
            
            
            // 알림 삭제
            PV.deleteNotification(array[indexPath.row].notiIds)
            
            self.medicineDataManager.deleteMedicine(index: indexPath.row)
            self.medicineTableView.reloadData()
        }
        
        return cell
        
    }
}
//MARK: - 테이블뷰 델리겟 관련
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataList = medicineDataManager.getMedicineData()
        
        let selectedData = dataList[indexPath.row]
        
        // 테이블뷰셀 선택시 버튼 보여주기/숨기기
        if selectedRows.contains(selectedData.id) {
            selectedRows.remove(selectedData.id)
        } else {
            selectedRows.insert(selectedData.id)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - 뷰컨트롤러 델리겟
extension ViewController: MedicineDelegate {
    func addNewMedicine(_ medicineData: MedicineData) {
        medicineDataManager.makeNewMedicine(medicineData)
        medicineTableView.reloadData()
    }
    
    func getMedicine() {
        medicineDataManager.getMedicineData()
        medicineTableView.reloadData()
    }
    
    func update(index: Int, _ medicineData: MedicineData) {
        medicineDataManager.updateMedicine(index: index, medicineData)
        medicineTableView.reloadData()
    }
    func delete(index: Int) {
        medicineDataManager.deleteMedicine(index: index)
        medicineTableView.reloadData()
    }
    
}

//MARK: - 화면 터치시 키보드 내리기
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - 텍스트필드 관련
extension UIToolbar {
    /// 복용 기간 텍스트필드
    func dateToolbarPicker(select: Selector) -> UIToolbar {
        let dateToolbar = UIToolbar()
        
        dateToolbar.barStyle = .default
        dateToolbar.isTranslucent = true
        dateToolbar.tintColor = .black
        dateToolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "날짜 선택", style: .done, target: self, action: select)
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        dateToolbar.setItems([doneBtn, spaceBtn], animated: false)
        dateToolbar.isUserInteractionEnabled = true
        
        return dateToolbar
    }
    
    /// 복용 시간 텍스트필드
    func TimetoolbarPicker(select: Selector) -> UIToolbar {
        let timeToolbar = UIToolbar()
        
        timeToolbar.barStyle = .default
        timeToolbar.isTranslucent = true
        timeToolbar.tintColor = .black
        timeToolbar.sizeToFit()
        
        let timeDoneBtn = UIBarButtonItem(title: "시간 선택", style: .done, target: self, action: select)
        let timeSpaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        timeToolbar.setItems([timeDoneBtn, timeSpaceBtn], animated: false)
        timeToolbar.isUserInteractionEnabled = true
        
        return timeToolbar
    }
}
