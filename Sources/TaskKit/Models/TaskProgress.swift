//
//  Untitled.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

import Foundation
import SwiftData

@Model
public final class TaskProgress :Identifiable,ObservableObject{
    public var taskId: String
    public var isDone: Bool
    public var completedAt: Date?

    public init(taskId: String, isDone: Bool = false, completedAt: Date? = nil) {
        self.taskId = taskId
        self.isDone = isDone
        self.completedAt = completedAt
    }
}
