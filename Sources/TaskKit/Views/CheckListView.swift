//
//  CheckListView.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

import SwiftUI

public struct ChecklistView: View {
    let tasks: [Task]

    public init(tasks: [Task]) {
        self.tasks = tasks
    }

    public var body: some View {
        List(tasks) { task in
            CheckRow(task: task)
        }
    }
}

public struct CheckRow: View {
    let task: Task

    public var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            Image(systemName: TaskStore.shared.isDone(task.id) ? "checkmark.circle.fill" : "circle")
        }
    }
}
