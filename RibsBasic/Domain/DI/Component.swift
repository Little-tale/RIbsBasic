//
//  Component.swift
//  RibsBasic
//
//  Created by Jae hyung Kim on 8/26/25.
//

import Foundation

class Component<DependencyType>: Dependency {
    
    private var sharedInstances = [String: Any]()
    private let lock = NSRecursiveLock()
    
    let dependency: DependencyType
    
    init(dependency: DependencyType) {
        self.dependency = dependency
    }
    
    final func shared<T>(__function: String = #function, _ factory: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        if let instance = (sharedInstances[__function] as? T?) ?? nil {
            return instance
        }
        let intance = factory()
        sharedInstances[__function] = intance
        
        return intance
    }
}
