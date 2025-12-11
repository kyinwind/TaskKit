//
//  RewardStore.swift
//  GongKe
//
//  Created by xuehui yang on 2025/12/8.
//
import Foundation

@MainActor
public final class RewardStore {

    public static let shared = RewardStore()
    private init() { load() }

    private let key = "reward_store"
    private(set) var unlocked: Set<String> = []

    public func markUnlocked(_ id: String) {
        if unlocked.insert(id).inserted {
            save()
        }
    }

    public func has(_ id: String) -> Bool {
        unlocked.contains(id)
    }

    private func save() {
        UserDefaults.standard.set(Array(unlocked), forKey: key)
    }

    private func load() {
        if let arr = UserDefaults.standard.array(forKey: key) as? [String] {
            unlocked = Set(arr)
        }
    }
}
