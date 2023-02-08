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

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")

        let cellData : MedicineData = medicineDataList[indexPath.row]

        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.date

        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath: \(indexPath.row)")
    }
}


