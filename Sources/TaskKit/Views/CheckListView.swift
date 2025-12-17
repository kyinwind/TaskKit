//
//  CheckListView.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

import SwiftUI

public struct ChecklistView: View {
    let title: String?
    let tasks: [AppTask]
    let remarks: String?
    let rewards: [AppReward]

    public init(
        title: String? = nil,
        tasks: [AppTask],
        remarks: String? = nil,
        rewards: [AppReward] = []
    ) {
        self.title = title
        self.tasks = tasks
        self.remarks = remarks
        self.rewards = rewards   // ← 正确赋值
    }

    public var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
            }

            List {
                // 按 rewards 的顺序，逐个显示属于该 rewardId 的任务
                ForEach(rewards, id: \.id) { reward in
                    let tasksForReward = tasks.filter { $0.rewardId == reward.id }
                    if !tasksForReward.isEmpty {
                        Section(header: RewardSectionHeader(reward: reward)) {
                            ForEach(tasksForReward, id: \.id) { task in
                                CheckRow(index: indexOf(task: task, in: tasksForReward),
                                         task: task)
                            }
                        }
                    }
                }

                // 最后显示：没有匹配到 rewards 的任务（或 rewardId 为空）
                let others = tasks.filter { task in
                    guard let rid = task.rewardId else { return true }
                    return !rewards.contains(where: { $0.id == rid })
                }

                if !others.isEmpty {
                    Section(header: Text("其他任务").font(.headline)) {
                        ForEach(others, id: \.id) { task in
                            CheckRow(index: indexOf(task: task, in: others),
                                     task: task)
                        }
                    }
                }
            }
            .platformListStyle()

            if let remarks = remarks {
                Text(remarks)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding([.horizontal, .bottom])
            }
        }
    }

    // 计算任务在该组内的序号（从 1 开始）
    private func indexOf(task: AppTask, in array: [AppTask]) -> Int {
        guard let idx = array.firstIndex(where: { $0.id == task.id }) else { return 0 }
        return idx + 1
    }

    // MARK: - 任务行
    public struct CheckRow: View {
        let index: Int
        let task: AppTask

        public var body: some View {
            HStack {
                Text("\(index).")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: 28, alignment: .leading)

                VStack(alignment: .leading) {
                    Text(task.title).font(.headline)
                    Text(task.description).font(.caption)
                }

                Spacer()

                Image(systemName: TaskStore.shared.isDone(task.id) ? "checkmark.circle.fill" : "circle")
            }
            .padding(.vertical, 6)
        }
    }

    // MARK: - 奖励 Section Header
    public struct RewardSectionHeader: View {
        let reward: AppReward

        public var body: some View {
            HStack(spacing: 12) {
                Image(reward.iconName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .overlay {
                        Image(systemName: "gift.fill")
                            .opacity(0.6)
                    }


                VStack(alignment: .leading, spacing: 2) {
                    Text(reward.title.isEmpty ? reward.name : reward.title)
                        .font(.subheadline)
                        .bold()
                    Text(reward.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

extension View {
    @ViewBuilder
    func platformListStyle() -> some View {
        #if os(iOS)
        self.listStyle(.insetGrouped)
        #else
        self.listStyle(.inset)
        #endif
    }
}


#Preview {
    let title = "完成如下任务，可以获得奖励哦"
    let remarks = "所有任务完成后，即可解锁奖励"
    let tasks =  [
        AppTask(
            id: "create_gongke",
            title: "任务：创建功课计划",
            description: "根据功课向导完成了功课的创建",
            event: TaskEvent.finishFeature("create_gongke"),
            rewardId: "r1"
        ),
        AppTask(
            id: "finish_songdujingshu",
            title: "任务：完成一部经书的诵读",
            description: "打开一部经书，并完成了诵读",
            event: TaskEvent.finishFeature("finish_songdujingshu"),
            rewardId: "r1"
        ),
        AppTask(
            id: "finish_readshanshu",
            title: "任务：完成一次阅读善书",
            description: "打开一本善书并阅读",
            event: TaskEvent.finishFeature("finish_readshanshu"),
            rewardId: "r1"
        ),
        AppTask(
            id: "finish_baichan",
            title: "任务：完成一次拜忏",
            description: "新建一个拜忏，并完成",
            event: TaskEvent.finishFeature("finish_baichan"),
            rewardId: "r1"
        ),
        AppTask(
            id: "finish_share",
            title: "任务：完成一次分享",
            description: "完成一次分享",
            event: TaskEvent.finishFeature("finish_share"),
            rewardId: "r1"
        ),
        AppTask(
            id: "finish_oneweek",
            title: "任务：连续一周完成功课",
            description: "坚持连续一周完成功课，中间没有间断",
            event: TaskEvent.finishFeature("finish_oneweek"),
            rewardId: "r2"
        ),
        AppTask(
            id: "finish_onemonth",
            title: "任务：连续一个月完成功课",
            description: "坚持连续一个月完成功课，中间没有间断",
            event: TaskEvent.finishFeature("finish_onemonth"),
            rewardId: "r3"
        ),
        AppTask(
            id: "finish_100days",
            title: "任务：连续100天完成功课",
            description: "坚持连续100 天完成功课，中间没有间断",
            event: TaskEvent.finishFeature("finish_100days"),
            rewardId: "r4"
        ),
        AppTask(
            id: "finish_365days",
            title: "任务：连续365天完成功课",
            description: "坚持连续365天完成功课，中间没有间断",
            event: TaskEvent.finishFeature("finish_365days"),
            rewardId: "r5"
        ),
    ]
    let rewards = [
        AppReward(
            id: "r1",
            name: "新手礼包，解锁学佛基础资料",
            title: "初发心",
            description: "完成前 5 个新手任务即可解锁《学佛基础资料》，荣获‘初发心’菩萨称号",
            condition: .allTasksDone(taskIds: [
                "create_gongke",
                "finish_songdujingshu",
                "finish_readshanshu",
                "finish_baichan",
                "finish_share"
            ]),
            iconName: "r1"
        ),

        AppReward(
            id: "r2",
            name: "净土宗佛学知识测试试题",
            title: "初精进",
            description: "连续一周完成功课即可解锁《净土宗佛学知识测试试题》，荣获‘初精进’菩萨称号",
            condition: .allTasksDone(taskIds: [
                "finish_oneweek"
            ]),
            iconName: "r2"
        ),

        AppReward(
            id: "r3",
            name: "禅宗佛学知识测试试题",
            title: "入佳境",
            description: "连续一个月完成功课即可解锁《禅宗佛学知识测试试题》，荣获‘入佳境’菩萨称号",
            condition: .allTasksDone(taskIds: [
                "finish_onemonth"
            ]),
            iconName: "r3"
        ),
        AppReward(
            id: "r4",
            name: "学佛资料分享",
            title: "稳精进",
            description: "连续100天完成功课即可解锁《学佛资料分享》，荣获‘稳精进’菩萨称号",
            condition: .allTasksDone(taskIds: [
                "finish_100days"
            ]),
            iconName: "r4"
        ),
        AppReward(
            id: "r5",
            name: "学佛资料分享",
            title: "常精进",
            description: "连续365天完成功课即可解锁《学佛资料分享》，荣获‘常精进’菩萨称号",
            condition: .allTasksDone(taskIds: [
                "finish_365days"
            ]),
            iconName: "r5"
        )
    ]
    ChecklistView(title: title, tasks: tasks, remarks: remarks, rewards: rewards)
}
