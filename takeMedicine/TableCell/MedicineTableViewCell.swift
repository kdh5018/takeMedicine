//
//  MedicineTableViewCell.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/02/09.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var medicineDate: UILabel!
    @IBOutlet weak var medicineTime1: UILabel!
    @IBOutlet weak var medicineTime2: UILabel!
    @IBOutlet weak var medicineTime3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
