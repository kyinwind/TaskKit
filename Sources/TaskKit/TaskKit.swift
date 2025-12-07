// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  TaskKit.swift
//  TaskKit
//

import Foundation

@MainActor
public enum TaskKit {
    public static var tasks: [AppTask] = []

    /// 初始化 TaskKit：设置可用任务
    public static func configure(tasks: [AppTask]) {
        self.tasks = tasks
        TaskEngine.shared.loadTasks(tasks)
    }
}
