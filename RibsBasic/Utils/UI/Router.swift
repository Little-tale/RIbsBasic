//
//  Router.swift
//  RibsBasic
//
//  Created by Jae hyung Kim on 8/27/25.
//

import RxSwift

class Router<InteractorType>: Routing {
    
    // MARK: MEMBER
    let interactor: InteractorType
    
    let interactable: Interactable
    
    final var children: [Routing] = []
    
    let deinitDisposable = CompositeDisposable()
    
    private let lifecycleSubject = PublishSubject<RouterLifecycle>()
    private var didLoadFlag: Bool = false
    
    // MARK: Init
    init(interactor: InteractorType) {
        self.interactor = interactor
        guard let interactable = interactor as? Interactable else {
            fatalError("\(interactor) should conform to \(Interactable.self)")
        }
        self.interactable = interactable
    }
    
    var lifecycle: Observable<RouterLifecycle> {
        return lifecycleSubject.asObservable()
    }
    
    func internalDidLoad() {
        bindSubtreeActiveState()
        lifecycleSubject.onNext(.didLoad)
    }
    
    
    func load() {
        guard !didLoadFlag else {
            return
        }
        
        didLoadFlag = true
        internalDidLoad()
        didLoad()
    }
    
    func didLoad() {}
    
    func attachChild(_ child: Routing) {
        children.append(child)
        
        child.interactable.activate()
        child.load()
    }
    
    func detachChild(_ child: Routing) {
        child.interactable.activate()
        
        guard let target = children.firstIndex(where: {$0 as AnyObject === child }) else { return }
        children.remove(at: target)
    }
    
    // MARK: Private Function
    private func bindSubtreeActiveState() {

        let disposable = interactable.isActiveStream
            .subscribe(onNext: { [weak self] (isActive: Bool) in
                self?.setSubtreeActive(isActive)
            })
        _ = deinitDisposable.insert(disposable)
    }
    
    private func setSubtreeActive(_ active: Bool) {

        if active {
            iterateSubtree(self) { router in
                if !router.interactable.isActive {
                    router.interactable.activate()
                }
            }
        } else {
            iterateSubtree(self) { router in
                if router.interactable.isActive {
                    router.interactable.deactivate()
                }
            }
        }
    }
    
    private func iterateSubtree(_ root: Routing, closure: (_ node: Routing) -> ()) {
        closure(root)

        for child in root.children {
            iterateSubtree(child, closure: closure)
        }
    }
}
