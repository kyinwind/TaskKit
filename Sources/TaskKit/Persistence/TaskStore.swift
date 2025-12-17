//
//  TaskStore.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//
import SwiftData
import Foundation

@MainActor
public final class TaskStore {

    public static let shared = TaskStore()
    private init() { load() }

    private let key = "task_progress_store"

    // taskId -> completedAt
    private var completed: [String: Date] = [:]

    // MARK: - Public API

    public func isDone(_ id: String) -> Bool {
        completed[id] != nil
    }

    public func completedAt(_ id: String) -> Date? {
        completed[id]
    }

    public func markDone(_ id: String) {
        guard completed[id] == nil else { return }
        completed[id] = Date()
        save()
    }

    public func reset(_ id: String) {
        if completed.removeValue(forKey: id) != nil {
            save()
        }
    }

    public func resetAll() {
        completed.removeAll()
        save()
    }

    // MARK: - Persistence

    private func save() {
        let data = completed.mapValues { $0.timeIntervalSince1970 }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard
            let raw = UserDefaults.standard.dictionary(forKey: key) as? [String: TimeInterval]
        else { return }

        completed = raw.mapValues { Date(timeIntervalSince1970: $0) }
    }
    
    // 用于从原来的swfitdata方案迁移过来
    public func migrateDone(taskId: String, completedAt: Date) {
        guard completed[taskId] == nil else { return }
        completed[taskId] = completedAt
        save()
    }

}
