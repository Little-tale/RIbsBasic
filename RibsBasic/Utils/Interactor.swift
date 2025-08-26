//
//  Interactor.swift
//  RibsBasic
//
//  Created by Jae hyung Kim on 8/26/25.
//

import Foundation
import RxSwift

protocol InteractorScope: AnyObject {
    
    var isActive: Bool { get }
    
    var isActiveStream: Observable<Bool> { get }
}


protocol Interactable: InteractorScope {
    func activate()
    func deactivate()
}

class Interactor: Interactable {
    
    private let isActiveSubject = BehaviorSubject<Bool>(value: false)
    private var activenessDisposable: CompositeDisposable?
    
    final var isActive: Bool {
        do {
            return try isActiveSubject.value()
        } catch {
            return false
        }
    }
    
    final var isActiveStream: Observable<Bool> {
        return isActiveSubject.asObservable().distinctUntilChanged()
    }
    
    
    func activate() {
        guard !isActive else {
            return
        }
        
        activenessDisposable = CompositeDisposable()

        isActiveSubject.onNext(true)

        didBecomeActive()
    }
    
    func didBecomeActive() {}
    
    
    func deactivate() {
        guard isActive else {
            return
        }
        
        willResignActive()

        activenessDisposable?.dispose()
        activenessDisposable = nil

        isActiveSubject.onNext(false)
    }
    
    func willResignActive() {}
    
    deinit {
        if isActive {
            deactivate()
        }
        isActiveSubject.onCompleted()
    }
}
