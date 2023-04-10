//
//  MedicineTableViewCell.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {
    
    
    // 테이블뷰는 메모리를 재사용한다 - 그렇기 때문에 cellForRowAt에서 dequeueReusableCell 키워드를 사용하는 것이다
    // 뷰컨 cellForRowAt에서 dequeueReusableCell에 withIdentifier가 MedicineTableViewCell.reuseId인 이유
    static let reuseId = "medicineCell"
    
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var medicineDate: UILabel!
    @IBOutlet weak var medicineMorningTime: UILabel!
    @IBOutlet weak var medicineDayTime: UILabel!
    @IBOutlet weak var medicineNightTime: UILabel!
    
    // 테이블 뷰 셀에 있는 수정,삭제 버튼 스택뷰
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    var onCellEditBtnClicked: ((_ cellData: MedicineData, _ indexPath: IndexPath) -> Void)? = nil
    //    var onCellDeleteBtnClicked: ((_ cellData: MedicineData, _ indexPath: IndexPath) -> Void)? = nil
    
    var medicineData: MedicineData? = nil
    var currentIndex: IndexPath? = nil
    
    
    // 수정, 삭제 버튼 스택뷰 숨기기 함수
    // 셀 데이터 업데이트
    func configureCell(cellData: MedicineData, isSelected: Bool, indexPath: IndexPath){
        
        self.medicineData = cellData
        self.currentIndex = indexPath
        
        medicineName.text = cellData.title
        medicineDate.text = cellData.date
        medicineMorningTime.text = cellData.morningTime
        medicineDayTime.text = cellData.dayTime
        medicineNightTime.text = cellData.nightTime
        
        buttonStackView.isHidden = !isSelected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onEditBtnClicked(_ sender: UIButton) {
        
        guard let cellData = self.medicineData,
              let indexPath = self.currentIndex else { return }
        onCellEditBtnClicked?(cellData, indexPath)
    }
    
    //    @IBAction func onDeleteBtnClicked(_ sender: UIButton) {
    //        guard let cellData = self.medicineData,
    //              let indexPath = self.currentIndex else { return }
    //        onCellDeleteBtnClicked?(cellData, indexPath)
    //    }
    
    
}
