//
//  Reward.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

public struct AppReward: Identifiable, Codable {
    public let id: String
    public let name:String     //解锁礼物的名称
    public let title: String   //可以是等级名称
    public let description: String
    public let condition: RewardCondition
    public let iconName: String  //图标

    public init(id: String,name:String, title: String, description: String, condition: RewardCondition,iconName:String) {
        self.id = id
        self.name = name
        self.title = title
        self.description = description
        self.condition = condition
        self.iconName = iconName
    }
}

public enum RewardCondition: Codable {
    case allTasksDone(taskIds: [String])
}
