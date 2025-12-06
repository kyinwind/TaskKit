# TaskKit

为用户设置 app 的完成任务，并记录用户完成情况

2025-12-06:发布 0.1 版

使用方法：

1. 初始化 checkpoint 方法：
```python
@main
struct MyApp: App {
    init() {
        TaskKit.configure(tasks: [
            Task(id: "feature_home", event: .openPage("home")),
            Task(id: "feature_detail", event: .openPage("detail")),
            Task(id: "feature_settings", event: .tapButton("settings")),
            Task(id: "feature_profile", event: .finishFeature("profile")),
            Task(id: "feature_finish", event: .finishFeature("fullFlow"))
        ])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```
3. App 启动：
```
TaskStore.shared.setup()

TaskEngine.shared.loadTasks(myTasks)
RewardEngine.shared.loadRewards(myRewards)
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
EventCenter.shared.send(.openPage("Meditation"))
```
