//
//  Medicine.swift
//  takeMedicine
//
//  Created by 김도훈 on 2023/03/21.
//

import Foundation
import RealmSwift

class Medicine: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var date: String? = ""
    @objc dynamic var morningTime: String = ""
    @objc dynamic var dayTime: String? = ""
    @objc dynamic var nightTime: String? = ""
    
    override static func primaryKey() -> String {
        return "title"
    }
    
}
