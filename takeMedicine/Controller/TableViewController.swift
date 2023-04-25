//
//  TableViewController.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/04/25.
//

import UIKit

class TableViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditViewController" {
            let editViewController = segue.destination as! EditViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let cell = tableView.cellForRow(at: indexPath)!
            
            if editViewController.editDayTimeTextField.text?.isEmpty ?? true {
                editViewController.shouldHideTextField = true
            }
        }
    }

}
