//
//  Row+CoreDataClass.swift
//  CoreDataPratice
//
//  Created by 하연주 on 2023/12/16.
//
//

import Foundation
import CoreData

@objc(Row)
public class Row: NSManagedObject {

    static let name = "Row"
    
    var currentRowNumberNotice : String {
        return "지금 row의 갯수는 \(String(self.number))입니다"
    }
    
//    var fullName: String {
//        return "\(firstName) \(lastName)"
//    }
}
