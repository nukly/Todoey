//
//  Category.swift
//  Todoey
//
//  Created by Klemen Brecko on 17/04/2021.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    
}
