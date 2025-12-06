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

    public var container: ModelContainer!
    public var context: ModelContext {
        container.mainContext
    }

    private init() {}

    // 初始化 SwiftData 容器
    // 外部注入 SwiftData 的 ModelContainer
    public func setup(container: ModelContainer) {
        self.container = container
    }

    // 查询某个 task 用户完成了吗
    public func isDone(_ id: String) -> Bool {
        let descriptor = FetchDescriptor<TaskProgress>(predicate: #Predicate { $0.taskId == id })
        let result = try? context.fetch(descriptor)
        return result?.first?.isDone ?? false
    }

    // 修改某个 task 用户已经完成
    public func markDone(_ id: String) {
        let descriptor = FetchDescriptor<TaskProgress>(predicate: #Predicate { $0.taskId == id })
        if let result = try? context.fetch(descriptor), let progress = result.first {
            progress.isDone = true
            progress.completedAt = Date()
        } else {
            context.insert(TaskProgress(taskId: id, isDone: true, completedAt: Date()))
        }

        try? context.save()
    }
}
