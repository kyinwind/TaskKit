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
    public static var rewards: [AppReward] = []
    /// 初始化 TaskKit：设置可用任务
    public static func configure(tasks: [AppTask],rewards:[AppReward]) {
        self.tasks = tasks
        self.rewards = rewards
        TaskEngine.shared.loadTasks(tasks)
        RewardEngine.shared.loadRewards(rewards)
    }
}
