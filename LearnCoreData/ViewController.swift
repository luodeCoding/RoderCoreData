//
//  ViewController.swift
//  LearnCoreData
//
//  Created by roder on 2020/6/3.
//  Copyright © 2020 roder. All rights reserved.
//

import UIKit
import CoreData
import AlecrimCoreData

class ViewController: UIViewController {

//    let persistentContainer = PersistentContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inssertClasses()
//        deleteClass(className: "name1")
        StorageService.shared.set("ccccc", forKey: "kkkkk")
    }
    
    func alecrimTest() {
//        let query = persistentContainer.viewContext
        
    }
}

extension ViewController {
    //获取存储器上下文
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    //插入数据
    func inssertClasses() {
        for i in 1...100 {
            let classId = Int16(i)
            let name = "name"+"\(i)"
            insertClass(classId: classId, name: name)
        }
    }
    
    func insertClass(classId:Int16,name:String) {

        //获取上下文对象

        let context = getContext()

        //两种方式创建数据
    
        //1.创建一个实例并赋值
        let personEntity = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
        //Person对象赋值
        personEntity.id = classId
        personEntity.name = name

        //2.通过指定实体名 得到对象实例
        let Entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let classEntity = NSManagedObject(entity: Entity!, insertInto: context)
        classEntity.setValue(classId, forKey: "id")
        classEntity.setValue(name, forKey: "name")

        //保存实体对象
        do {
            try context.save()
        } catch  {
            let nserror = error as NSError
            fatalError("错误:\(nserror),\(nserror.userInfo)")
        }
        
        //获取Model缓存文件路径
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) )
    }
    
    //删除实体对象
    func deleteClass(className: String) {
        let context = getContext()
        let fetchRequest:NSFetchRequest = Person.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", className)
        do {
            let result: [Person] = try context.fetch(fetchRequest)
            for one in result {
                context.delete(one)
            }
            try context.save()
        } catch {
            fatalError()
        }
        
    }
    
    //修改实体对象
    func modifClass(className: String) {
        let context = getContext()
        let fetchRequest:NSFetchRequest = Person.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", className)
        do {
            let result: [Person] = try context.fetch(fetchRequest)
            for one in result {
                one.name = "修改后的名字"
            }
            try context.save()
        } catch {
            fatalError()
        }
    }
    
}

