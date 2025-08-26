//
//  Builder.swift
//  RibsBasic
//
//  Created by Jae hyung Kim on 8/26/25.
//

import Foundation

protocol Buildable: AnyObject {
    
}

class Builder<DependencyType>: Buildable {
    
    let dependency: DependencyType
    
    init(dependency: DependencyType) {
        self.dependency = dependency
    }
}
