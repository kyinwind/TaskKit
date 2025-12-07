//
//  CheckListView.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

import SwiftUI

public struct ChecklistView: View {
    let title: String?  //放在 list 上面
    let tasks: [AppTask]
    let remarks:String?  //放在 list 下面

    // 对外公开且三个参数都有默认值
    public init(
        title: String? = nil,
        tasks: [AppTask],
        remarks: String? = nil
    ) {
        self.title = title
        self.tasks = tasks
        self.remarks = remarks
    }

    public var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .padding()
            }
            List {
                ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                    CheckRow(index: index + 1, task: task)
                }
            }
            if let remarks = remarks {
                Text(remarks)
                    .font(.headline)
                    .padding()
            }
            Spacer()
        }
    }

    public struct CheckRow: View {
        let index: Int
        let task: AppTask

        public var body: some View {
            HStack {
                Text("\(index).")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: 24, alignment: .leading) // 对齐更整齐
                VStack(alignment: .leading){
                    Text(task.title)
                        .font(.headline)
                    Text(task.description)
                        .font(.caption)
                }
                Spacer()
                Image(systemName: TaskStore.shared.isDone(task.id) ? "checkmark.circle.fill" : "circle")
            }
        }
    }
}

#Preview {
    let title = "完成如下任务，可以获得奖励哦"
    let remarks = "所有任务完成后，即可解锁佛学知识测验入口"
    let tasks = [
        AppTask(
            id: "create_gongke",
            title: "创建功课计划",
            description: "根据功课向导完成了功课的创建",
            event: TaskEvent.finishFeature("create_gongke"),
            rewardId: ""
        ),
        AppTask(
            id: "finish_songdujingshu",
            title: "完成一部经书的诵读",
            description: "打开一部经书，并完成了诵读",
            event: TaskEvent.finishFeature("finish_songdujingshu"),
            rewardId: ""
        ),
        AppTask(
            id: "finish_readshanshu",
            title: "完成一次阅读善书",
            description: "打开一本善书并阅读",
            event: TaskEvent.finishFeature("finish_readshanshu"),
            rewardId: ""
        ),
        AppTask(
            id: "finish_baichan",
            title: "完成一次拜忏",
            description: "新建一个拜忏，并完成",
            event: TaskEvent.finishFeature("finish_baichan"),
            rewardId: ""
        ),
    ]
    ChecklistView(title: title,tasks: tasks, remarks: remarks)
}
