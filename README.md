# TaskKit

为用户设置 app 的完成任务，并记录用户完成情况

2025-12-06:发布 0.1 版

使用方法：

1. 初始化 checkpoint 方法
```python
@main
struct MyApp: App {
    init() {
        //初始化 package 的持久化数据库
        TaskStore.shared.setup()
        //初始化 app 有多少 checkpoint
        TaskKit.configure(tasks: [
                Task(
                    id: "create_gongke",
                    title: "创建功课计划",
                    description: "根据功课向导完成了功课的创建",
                    event: .finishFeature,
                    rewardId: ""
                ),
                Task(
                    id: "finish_songdujingshu",
                    title: "完成一部经书的诵读",
                    description: "打开一部经书，并完成了诵读",
                    event: .finishFeature,
                    rewardId: ""
                ),
                Task(
                    id: "finish_baichan",
                    title: "完成一次拜忏",
                    description: "新建一个拜忏，并完成",
                    event: .finishFeature,
                    rewardId: ""
                ),
        ])
        //初始化奖励，如果有
        RewardEngine.shared.loadRewards(myRewards)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

3. 监听奖励：
```
.onReceive(NotificationCenter.default.publisher(for: .rewardUnlocked)) { note in
    if let reward = note.object as? Reward {
        print("奖励解锁: \(reward.title)")
    }
}
```
4. 发送事件：
```
EventCenter.shared.send(.finishFeature("create_gongke"))
```

# 包文件说明
TaskKit
 ├── Task.swift                // 任务定义
 ├── TaskEvent.swift           // 事件类型
 ├── EventCenter.swift         // 上报事件
 ├── TaskEngine.swift          // 匹配任务并标记完成
 ├── RewardEngine.swift        // 判断是否全部完成
 ├── TaskStore.swift           // SwiftData 持久化用户完成状态
 └── TaskKit.swift             // 对外 API （configure）
