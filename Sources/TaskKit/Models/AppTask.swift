//
//  Task.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

public struct AppTask: Identifiable, Codable {
    public let id: String
    public let title: String
    public let description: String
    public let event: TaskEvent
    public let rewardId: String?

    public init(id: String, title: String, description: String, event: TaskEvent, rewardId: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.event = event
        self.rewardId = rewardId
    }
}
