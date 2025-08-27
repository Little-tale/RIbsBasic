//
//  RouterScope.swift
//  RibsBasic
//
//  Created by Jae hyung Kim on 8/27/25.
//

import RxSwift

enum RouterLifecycle {

    /// Router did load.
    case didLoad
}

protocol RouterScope: AnyObject {
    
    var lifecycle: Observable<RouterLifecycle> { get }
}

protocol Routing: RouterScope {
    
    var interactable: Interactable { get }

    var children: [Routing] { get }

    func load()

    func attachChild(_ child: Routing)

    func detachChild(_ child: Routing)
}
