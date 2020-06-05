//
//  PersistentContainer+App.swift
//  LearnCoreData
//
//  Created by roder on 2020/6/4.
//  Copyright © 2020 roder. All rights reserved.
//

import Foundation
import AlecrimCoreData

extension PersistentContainer {
    public convenience init(name: String? = nil, bundle: Bundle? = nil) {
        try! self.init(name: name,
                       managedObjectModel: type(of: self).managedObjectModel(withName: name,
                                                                             in: bundle ?? Bundle.main),
                       storageType: .disk,
                       persistentStoreURL: try! type(of: self).persistentStoreURL(withName: name, inPath: ""),
                       persistentStoreDescriptionOptions: nil,
                       ubiquitousConfiguration: nil)
    }
}
