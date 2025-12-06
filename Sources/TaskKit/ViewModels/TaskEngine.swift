//
//  TaskEvent.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//
import Foundation
@MainActor
public final class TaskEngine : @unchecked Sendable  {
    public static let shared = TaskEngine()

    private var tasks: [Task] = []

    private init() {
        EventCenter.shared.subscribe(handle(_:))
    }

    public func loadTasks(_ tasks: [Task]) {
        self.tasks = tasks
    }

    private func handle(_ event: TaskEvent) {
        for task in tasks {
            if match(event, task.event) {
                TaskStore.shared.markDone(task.id)
                RewardEngine.shared.evaluate()
            }
        }
    }

    private func match(_ event: TaskEvent, _ type: TaskEventType) -> Bool {
        switch (event, type) {
        case (.openPage, .openPage),
             (.finishFeature, .finishFeature),
             (.tapButton, .tapButton):
            return true
        default:
            return false
        }
    }
}
