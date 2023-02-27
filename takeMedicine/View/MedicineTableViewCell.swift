//
//  MedicineTableViewCell.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {
    
    static let reuseId = "medicineCell"
    
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var medicineDate: UILabel!
    @IBOutlet weak var medicineMorningTime: UILabel!
    @IBOutlet weak var medicineDayTime: UILabel!
    @IBOutlet weak var medicineNightTime: UILabel!
    
    var medicineData: MedicineData? {
        // 값이 변화할 때마다 자동으로 업데이트가 되도록 구현하는 didSet(속성 감시자)
        didSet{
            guard let medicineData = medicineData else { return }
            medicineName.text = medicineData.title
            medicineDate.text = medicineData.date
            medicineMorningTime.text = medicineData.morningTime
            medicineDayTime.text = medicineData.dayTime
            medicineNightTime.text = medicineData.nightTime
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
