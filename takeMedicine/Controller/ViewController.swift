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
    
    var pastDateArray: [DateComponents] = []
    var notiIds: [String] = []
    
    // 각 시간 구성 요소에 대한 알림 요청 생성
    var notificationRequests: [UNNotificationRequest] = []
    var notificationIds: [String] = []
    
    // 시간 값 저장하는 배열
    var notificationTimeComponents: [DateComponents] = []
    
    var addedTimeComponents = Set<DateComponents>()
    
    @IBOutlet weak var medicineTableView: UITableView!
    
    
    let medicineCell = MedicineTableViewCell()
    
    // 테이블뷰셀 클릭시 버튼 보임/숨김을 위한 행 번호 변수
    var selectedRows: Set<UUID> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineTableView.dataSource = self
        medicineTableView.delegate = self
        
        medicineTableView.estimatedRowHeight = UITableView.automaticDimension
        
        
        // 더미데이터를 이용하여 초기 화면 체크
        //        self.medicineDataList = MedicineData.getDummies()
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
           let data = sender as? ([String], (medicineData: MedicineData, indexPath: IndexPath)){
            
            // EditViewController(editDestinationVC)과 ViewController를 델리겟으로 연결⭐️
            // extension으로 ViewController에 뷰컨트롤러를 정의했기 때문에 ViewController가 Delegate를 준수하기 때문에 self로 연결이 됨
            editDestinationVC.editDelegate = self
            
            let editMedicineData = data.1.medicineData
            
            editDestinationVC.editMedicineData = editMedicineData
            
            editDestinationVC.prepareName = editMedicineData.title
            editDestinationVC.prepareTime = editMedicineData.time
            
            let existedNotiIds = data.0
            editDestinationVC.existedNotiIds = existedNotiIds
            
        }
        
    }
    
    /// 로컬 노티피케이션 사용을 위한 함수
    /// - Parameter title: 알림 이름
    /// - Returns: 스케줄링 처리가 된 알림 ID들
    func notificationSet(title: String) -> [String] {
        let content = UNMutableNotificationContent()
        content.title = "약 먹었니?"
        content.body = "\(title)을 먹을 시간입니다💊"
        content.sound = .default
        
        let notificationCenter = UNUserNotificationCenter.current()

        notificationIds = notificationTimeComponents.compactMap { timeComponents in

            let uuidString = UUID().uuidString

            // 트리거 반복 이벤트 만들기
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
            // 요청 생성
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            notificationRequests.append(request)
            print(#fileID, #function, #line, "- uuidString: \(uuidString)")

            notificationCenter.add(request) { (error) in
                if error != nil {
                    print("error: \(error)")
                }
            }
            // 추가된 시간대의 정보를 addedTimeComponents에 추가
            addedTimeComponents.insert(timeComponents)
            return uuidString
        }
        return notificationIds
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

            let existedNotiIds = array[indexPath.row].notiIds
            self.performSegue(withIdentifier: "EditViewController", sender: (existedNotiIds, data))
            
            print(#fileID, #function, #line, "- 추가된 노티 아이디: \(array[indexPath.row].notiIds)")
            print(#fileID, #function, #line, "- 에딧뷰컨으로 넘긴 아이디: \(existedNotiIds)")
            
            
            print(#fileID, #function, #line, "- 수정하기 화면 넘어감")
        }
        
        // 삭제하기 버튼 클릭하면 해당하는 테이블뷰셀 삭제
        // 넘기거나 하는 다음 과정이 없기 때문에 여기서 바로 지워도 됨
        cell.onCellDeleteBtnClicked = {
            [weak self] (indexPath: IndexPath) in
            guard let self = self else { return }
            
            
            // 알림 삭제
            PV.deleteNotification(array[indexPath.row].notiIds)
            
            let currentList = medicineDataManager.getMedicineData()
            let itemToBeDeleted = currentList[indexPath.row]
            
            // 데이터 삭제
            self.medicineDataManager.deleteMedicineWithUUID(uuid: itemToBeDeleted.id)
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
    
    func update(uuid: UUID, _ medicineData: MedicineData) {
        
        // 1. 현재 해당 아이디를 가진 데이터 찾기
//        guard let foundMedicineData: MedicineData = medicineDataManager.getMedicineData().first(where: { $0.id == uuid }) else { return }
//
//        // 2. 해당하는 데이터의 알림 [ID]
//        let notiIdsToBeDeleted: [String] = foundMedicineData.notiIds
        

        // 3. 기존 알림들 지우기
//        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: notiIdsToBeDeleted)
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notiIdsToBeDeleted)

        
        // 4. 추가된 알림 등록하기
        medicineDataManager.updateMedicine(uuid: uuid, medicineData)
        medicineTableView.reloadData()
    }

    func delete(uuid: UUID) {
        medicineDataManager.deleteMedicineWithUUID(uuid: uuid)
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
        let timeSpaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        timeToolbar.setItems([timeDoneBtn, timeSpaceBtn], animated: false)
        timeToolbar.isUserInteractionEnabled = true
        
        return timeToolbar
    }
}
