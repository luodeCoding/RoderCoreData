//
//  NSArrayController+Extensions.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2015-07-28.
//  Copyright (c) 2015 Alecrim. All rights reserved.
//

#if os(macOS)
    
    import Foundation
    
    extension Query {
        
        public func toArrayController() -> NSArrayController {
            let fetchRequest = self.fetchRequest.toRaw() as NSFetchRequest<Entity>
            
            let arrayController = NSArrayController(content: nil)
            
            arrayController.managedObjectContext = self.context
            arrayController.entityName = fetchRequest.entityName
            
            arrayController.fetchPredicate = fetchRequest.predicate
            if let sortDescriptors = fetchRequest.sortDescriptors {
                arrayController.sortDescriptors = sortDescriptors
            }
            
            arrayController.automaticallyPreparesContent = true
            arrayController.automaticallyRearrangesObjects = true
            arrayController.usesLazyFetching = true
            
            return arrayController
        }
        
    }
    
#endif

