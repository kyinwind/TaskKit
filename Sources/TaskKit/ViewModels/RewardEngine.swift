//
//  EventReward.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//
import Foundation

public extension Notification.Name {
    static let rewardUnlocked = Notification.Name("rewardUnlocked")
}
@MainActor
public final class RewardEngine {
    public static let shared = RewardEngine()

    public var rewards: [AppReward] = []

    public func loadRewards(_ rewards: [AppReward]) {
        self.rewards = rewards
    }

    public func evaluate() {
        for reward in rewards {
            // 已获得，不需要重复触发
            if RewardStore.shared.has(reward.id) {
                continue
            }
            switch reward.condition {
            case .allTasksDone(let ids):
                if ids.allSatisfy({ TaskStore.shared.isDone($0) }) {
                    // 记录
                    RewardStore.shared.markUnlocked(reward.id)
                    // 发通知
                    NotificationCenter.default.post(name: .rewardUnlocked, object: reward)
                }
            }
        }
    }
}
