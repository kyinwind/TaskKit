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

    private var rewards: [Reward] = []

    public func loadRewards(_ rewards: [Reward]) {
        self.rewards = rewards
    }

    public func evaluate() {
        for reward in rewards {
            switch reward.condition {
            case .allTasksDone(let ids):
                if ids.allSatisfy({ TaskStore.shared.isDone($0) }) {
                    NotificationCenter.default.post(name: .rewardUnlocked, object: reward)
                }
            }
        }
    }
}
