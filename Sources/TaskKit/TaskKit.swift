//
//  TaskKit.swift
//  TaskKit
//
//  Swift Package: TaskKit
//

import Foundation

/// TaskKit 是应用中管理任务与奖励的入口
///
/// 使用方法：
/// 1. 调用 `TaskKit.configure(tasks:rewards:)` 初始化任务和奖励
/// 2. 通过 `TaskKit.tasks` 和 `TaskKit.rewards` 获取当前状态
/// 3. TaskEngine 和 RewardEngine 会自动处理任务完成与奖励解锁逻辑
@MainActor
public enum TaskKit {
    
    /// 当前应用可用任务列表（只读）
    public private(set) static var tasks: [AppTask] = []
    
    /// 当前应用可用奖励列表（只读）
    public private(set) static var rewards: [AppReward] = []
    
    /// 初始化 TaskKit，设置可用任务和奖励
    /// - Parameters:
    ///   - tasks: 当前 app 可用任务列表
    ///   - rewards: 当前 app 可用奖励列表
    public static func configure(tasks: [AppTask], rewards: [AppReward]) {
        
        // 检查任务 ID 是否唯一
        let taskIDs = tasks.map { $0.id }
        guard Set(taskIDs).count == tasks.count else {
            print("⚠️ TaskKit Warning: Duplicate task IDs found.")
            return
        }
        
        // 检查奖励 ID 是否唯一
        let rewardIDs = rewards.map { $0.id }
        guard Set(rewardIDs).count == rewards.count else {
            print("⚠️ TaskKit Warning: Duplicate reward IDs found.")
            return
        }
        
        // 配置状态
        self.tasks = tasks
        self.rewards = rewards
        
        // 加载到引擎
        TaskEngine.shared.loadTasks(tasks)
        RewardEngine.shared.loadRewards(rewards)
    }
}
