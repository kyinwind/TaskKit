//
//  TaskEvent.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//
import Foundation
@MainActor
public final class TaskEngine: @unchecked Sendable {
    public static let shared = TaskEngine()

    private var tasks: [AppTask] = []

    private init() {
        EventCenter.shared.subscribe(handle(_:))
    }

    public func loadTasks(_ tasks: [AppTask]) {
        self.tasks = tasks
    }

    private func handle(_ event: TaskEvent) {
        var changed = false

        for task in tasks {
            if !TaskStore.shared.isDone(task.id),
               match(event, with: task.event) {

                TaskStore.shared.markDone(task.id)
                changed = true
            }
        }

        if changed {
            RewardEngine.shared.evaluate()
        }
    }

    private func match(_ event: TaskEvent, with taskEvent: TaskEvent) -> Bool {
        switch (event, taskEvent) {
        case let (.openPage(a), .openPage(b)):
            return a == b
        case let (.finishFeature(a), .finishFeature(b)):
            return a == b
        case let (.tapButton(a), .tapButton(b)):
            return a == b
        default:
            return false
        }
    }
}

