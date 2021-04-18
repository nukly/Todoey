//
//  Item.swift
//  Todoey
//
//  Created by Klemen Brecko on 17/04/2021.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
     
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
