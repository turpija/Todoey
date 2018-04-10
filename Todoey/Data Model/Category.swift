//
//  Category.swift
//  Todoey
//
//  Created by Ivan Kočiš on 04/04/2018.
//  Copyright © 2018 toorpia. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorHex: String = ""
    let items = List<Item>()
    
}
