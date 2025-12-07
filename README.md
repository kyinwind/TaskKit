# TaskKit

为用户设置 app 的完成任务，并记录用户完成情况

2025-12-06:发布 0.1 版

使用方法：

1. 初始化 checkpoint 方法
```swift
@main
struct MyApp: App {
    init() {
            let schema = Schema([
                TaskProgress.self,   // ⭐ 加入 TaskKit 的 entity
            ])
        do {
            modelContainer = try ModelContainer(for: schema)
            modelContainer.mainContext.autosaveEnabled = false
        } catch {
            fatalError("初始化ModelContainer失败。\(URL.applicationSupportDirectory.path(percentEncoded: false))")
        }
        initTaskKit()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func initTaskKit() {
    //初始化 package 的持久化数据库
    TaskStore.shared.setup(container: modelContainer)
    //初始化 app 有多少 checkpoint
    TaskKit.configure(
        tasks: [
            AppTask(
                id: "create_gongke",
                title: "创建功课计划",
                description: "根据功课向导完成了功课的创建",
                event: TaskEvent.finishFeature("create_gongke"),
                rewardId: "佛学知识测试题"
            ),
            AppTask(
                id: "finish_songdujingshu",
                title: "完成一部经书的诵读",
                description: "打开一部经书，并完成了诵读",
                event: TaskEvent.finishFeature("finish_songdujingshu"),
                rewardId: "佛学知识测试题"
            ),
            AppTask(
                id: "finish_readshanshu",
                title: "完成一次阅读善书",
                description: "打开一本善书并阅读",
                event: TaskEvent.finishFeature("finish_readshanshu"),
                rewardId: "佛学知识测试题"
            ),
            AppTask(
                id: "finish_baichan",
                title: "完成一次拜忏",
                description: "新建一个拜忏，并完成",
                event: TaskEvent.finishFeature("finish_baichan"),
                rewardId: "佛学知识测试题"
            ),
            AppTask(
                id: "finish_oneweek",
                title: "连续一周完成功课",
                description: "坚持连续一周完成功课，中间没有间断",
                event: TaskEvent.finishFeature("finish_oneweek"),
                rewardId: "佛学入门书籍下载链接"
            ),
            AppTask(
                id: "finish_onemonth",
                title: "连续一个月完成功课",
                description: "坚持连续一个月完成功课，中间没有间断",
                event: TaskEvent.finishFeature("finish_onemonth"),
                rewardId: "海量佛学视频下载链接"
            ),
        ]
    )
    let appRewards = [
        Reward(
            id: "r1",
            title: "新手礼包",
            description: "完成前 4 个新手任务即可领取奖励",
            condition: .allTasksDone(taskIds: [
                "create_gongke",
                "finish_songdujingshu",
                "finish_readshanshu",
                "finish_baichan"
            ])
        ),

        Reward(
            id: "r2",
            title: "精进小达人",
            description: "连续一周完成功课即可解锁",
            condition: .allTasksDone(taskIds: [
                "finish_oneweek"
            ])
        ),

        Reward(
            id: "r3",
            title: "精进大师",
            description: "连续一个月完成功课即可解锁",
            condition: .allTasksDone(taskIds: [
                "finish_onemonth"
            ])
        )
    ]
    RewardEngine.shared.loadRewards(appRewards)

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
```
TaskKit
 ├── Task.swift                // 任务定义
 ├── TaskEvent.swift           // 事件类型
 ├── EventCenter.swift         // 上报事件
 ├── TaskEngine.swift          // 匹配任务并标记完成
 ├── RewardEngine.swift        // 判断是否全部完成
 ├── TaskStore.swift           // SwiftData 持久化用户完成状态
 └── TaskKit.swift             // 对外 API （configure）
```
