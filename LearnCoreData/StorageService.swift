//
//  StorageService.swift
//  LearnCoreData
//
//  Created by roder on 2020/6/4.
//  Copyright © 2020 roder. All rights reserved.
//

import Foundation
import AlecrimCoreData
import CoreData
import HandyJSON

public final class StorageService: NSObject {
    @objc public static let shared = StorageService()
    private override init() {}
    private lazy var container = PersistentContainer(name: "DataModel", bundle: nil)
}

extension NSManagedObjectContext {
    fileprivate var dataModel: Query<DataModel> { return Query(in: self) }
}

extension StorageService {
    public func set<T>(_ value: T, forKey defaultName: String) {
        let v: String = {
            switch value {
            case let value as String:
                return value
            case let value as Int:
                return String(value)
            case let value as Float:
                return String(value)
            case let value as Double:
                return String(value)
            case let value as Bool:
                return String(value)
            case let value as URL:
                return value.absoluteString
            default:
                fatalError("无效的类型")
            }
        }()

        container.performBackgroundTask { context in
            let query = context.dataModel.where { \.key == defaultName }
            if let model = query.first() {
                model.value = v
            } else {
                let model = DataModel(context: context)
                model.key = defaultName
                model.value = v
            }

            if context.hasChanges {
                try? context.save()
            }
        }
    }

    private func _get(forKey defaultName: String) -> String? {
        //        步骤一：获取总代理和托管对象总管
        let context = container.viewContext

        //        步骤二：建立一个获取的请求
        let query = context.dataModel.where { \.key == defaultName }
        if let result = query.first() {
            return result.value
        }

        return nil
    }

    @objc public func remove(forKey defaultName: String) {
        container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<DataModel> = DataModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "key==%@", defaultName)
            if let results = try? context.fetch(fetchRequest) {
                for result in results {
                    context.delete(result)
                }

                if context.hasChanges {
                    try? context.save()
                }
            }
        }
    }

    // MARK: - 普通类型

    @objc public func isExist(forKey defaultName: String) -> Bool {
        return _get(forKey: defaultName) != nil
    }

    @objc public func integer(forKey defaultName: String) -> Int {
        let value = _get(forKey: defaultName)
        return Int(value ?? "0") ?? 0
    }

    @objc public func float(forKey defaultName: String) -> Float {
        let value = _get(forKey: defaultName)
        return Float(value ?? "0") ?? 0
    }

    @objc public func double(forKey defaultName: String) -> Double {
        let value = _get(forKey: defaultName)
        return Double(value ?? "0") ?? 0
    }

    @objc public func string(forKey defaultName: String) -> String {
        let value = _get(forKey: defaultName)
        return value ?? ""
    }

    @objc public func bool(forKey defaultName: String) -> Bool {
        let value = _get(forKey: defaultName)
        return Bool(value ?? "") ?? false
    }

    @objc public func url(forKey defaultName: String) -> URL? {
        let value = _get(forKey: defaultName)
        return URL(string: value ?? "")
    }
}

// MARK: - HandyJSON

extension StorageService {
    public func set<T>(_ value: T, forKey defaultName: String) where T: HandyJSON {
        set(value.toJSONString()!, forKey: defaultName)
    }

    public func model<T>(forKey defaultName: String) -> T where T: HandyJSON {
        let text: String = _get(forKey: defaultName) ?? ""
        return T.deserialize(from: text) ?? T()
    }

    public func set<T>(_ value: [T], forKey defaultName: String) where T: HandyJSON {
        set(value.toJSONString()!, forKey: defaultName)
    }

    public func models<T>(forKey defaultName: String) -> [T] where T: HandyJSON {
        let text: String = _get(forKey: defaultName) ?? ""
        return ([T].deserialize(from: text) ?? []) as! [T]
    }
}

// MARK: - 仅用于OC

extension StorageService {
    @available(*, deprecated, message: "仅用于OC")
    @objc public func setString(_ value: String, forKey defaultName: String) {
        set(value, forKey: defaultName)
    }
}
