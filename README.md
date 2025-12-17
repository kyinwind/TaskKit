# TaskKit

介绍：
当我们的app需要设置一些任务，用来引导用户完成这些学习任务，逐步熟悉app功能的时候，可以考虑使用TaskKit。
当需要针对用户完成任务的情况，为用户划分不同level的时候，也可以考虑使用TaskKit。

主要功能：  
- 支持用户在app初始化的时候定义引导任务，以及激活的奖励。
- 当任务完成时，自动写入UserDefaults
- 当一个或多个任务完成，触发解锁奖励时，NotificationCenter.default.post(name: .rewardUnlocked, object: reward)，通知主app
- 提供一个展示任务和奖励的view：CheckListView  


2025-12-06:发布 0.1 版  
2025-12-17:发布0.2版  

使用方法：

1. 初始化 checkpoint 方法
```swift
@main
struct MyApp: App {
    init() {
        //原有代码
        。。。
        //初始化 TaskKit
        initTaskKit()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func initTaskKit() {
    //初始化 app 有多少 task
    let tasks = [
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

    //有多少奖励，以及奖励和task对应关系
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
    //配置 TaskKit
    TaskKit.configure(tasks:tasks,rewards: appRewards)
        
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

5. 展示任务列表：
```
//显示一个代表当前用户等级的图片，点击后进入CheckListView
struct UserLevelView: View {
    @State var userLevel: String = "r0"
    var body: some View {
        let title = "完成 app 使用体验，解锁奖励"
        let remarks = "奖励包括：佛学知识测试题，资料、佛学小游戏等"
        
        NavigationLink(
            destination: ChecklistView(
                title:title,
                tasks: TaskKit.tasks,
                remarks: remarks,
                rewards: TaskKit.rewards
            )
        ) {
            Image(userLevel)  //假设已经存在以用户的level命名的图片在assets
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width:45,height: 45)
                .cornerRadius(20)
        }
        
        .onAppear(){
            let unlocked = RewardStore.shared.unlocked
            var maxUnlocked: String? {
                // 1. Set 转数组
                let sortedArray = unlocked.sorted()
                // 2. 取最后一个元素（升序排序后最后一个是最大的）
                return sortedArray.last
            }
            userLevel = maxUnlocked ?? "r0"
        }
    }
}
```
![（示例）](ishot.png)
# 包文件说明
```
TaskKit 配置应用的初始化入口
AppTask 定义应用中需要引导用户完成的任务
Reward 定义完成任务后可以获得的奖励
RewardStore 封装了奖励的加载和保存
TaskStore 封装了任务的完成、查询等逻辑
EventCenter 封装了事件的发送、订阅逻辑，定义了事件的多种类型
RewardEngine 封装了奖励的解锁逻辑,解锁奖励，并通知外部app
TaskEngine 封装了任务的完成逻辑，完成任务后更新TaskProgress,并计算是否解锁奖励
CheckListView   封装了任务和奖励的展示逻辑，外部app可以基于此view展示任务列表

```
