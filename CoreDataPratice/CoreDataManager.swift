//
//  CoreDataManager.swift
//  CoreDataPratice
//
//  Created by 하연주 on 2023/12/08.
//


import UIKit
import CoreData


class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    //NSPersistentContainer으로부터 NSManagedObjectContext를 가져옴
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //Entity를 가져옴 - 내가 원하는 데이터들을 어떤 Entity에 attribute로 저장하고 싶은데!
    lazy var entity = NSEntityDescription.entity(forEntityName: "Row", in: context)
    
    // 값 삽입
    func insertRowNum(num : Int) {
        if let entity = entity {
            let row = NSManagedObject(entity: entity, insertInto: context)
            row.setValue(num, forKey: "number")
            
            saveToContext()
        }
    }
    
    //Create : 저장하기
    func saveToContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Read : 불러오기
    func fetchRow() -> [Row] {
        do {
            let request = Row.fetchRequest()
            let results = try context.fetch(request) //as! [Row]
            results.forEach {
                print("Row Entity - number", $0.number)
          }
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }

    //Update : 업데이트하기
    func updateRowNum(num : Int) {
        let fetchResults = fetchRow()
        fetchResults[0].number = Int16(num)
        
        saveToContext()
    }
    
    //Delete : 삭제하기
    func deleteRowNum() {
        let fetchResults = fetchRow()
        context.delete(fetchResults[0])
        saveToContext()
    }
    
    //우리가 실제 필요한 타입 형태로 받아주기
    func getBookmarks() -> Int {
        let fetchResults = fetchRow()
        return Int(fetchResults[0].number)

    }
    
}
