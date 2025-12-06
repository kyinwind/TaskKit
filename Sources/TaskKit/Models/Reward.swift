//
//  Reward.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

public struct Reward: Identifiable, Codable {
    public let id: String
    public let title: String
    public let description: String
    public let condition: RewardCondition

    public init(id: String, title: String, description: String, condition: RewardCondition) {
        self.id = id
        self.title = title
        self.description = description
        self.condition = condition
    }
}

public enum RewardCondition: Codable {
    case allTasksDone(taskIds: [String])
}
