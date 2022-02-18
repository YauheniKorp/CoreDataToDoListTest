//
//  ToDoListItem+CoreDataProperties.swift
//  CoreDataToDoList
//
//  Created by Admin on 17.02.2022.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var check: Bool

}

extension ToDoListItem : Identifiable {

}
