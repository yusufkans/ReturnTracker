//
//  ToastScheduler.swift
//  ReturnTracker
//
//  Created by Yusufkan Sürmelioğlu on 06.02.2026.
//

import Foundation

protocol ToastScheduler {
    func schedule(after delayNanoseconds: UInt64, action: @escaping @MainActor () -> Void) -> Task<Void, Never>
}

struct DefaultToastScheduler: ToastScheduler {
    func schedule(after delayNanoseconds: UInt64, action: @escaping @MainActor () -> Void) -> Task<Void, Never> {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: delayNanoseconds)
            guard !Task.isCancelled else { return }
            action()
        }
    }
}
