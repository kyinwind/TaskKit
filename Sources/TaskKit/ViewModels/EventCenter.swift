//
//  EventCenter.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//

import Foundation

public enum TaskEvent: Codable {
    case openPage(String)
    case finishFeature(String)
    case tapButton(String)

    private enum CodingKeys: String, CodingKey {
        case type, value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .openPage(let v):
            try container.encode("openPage", forKey: .type)
            try container.encode(v, forKey: .value)

        case .finishFeature(let v):
            try container.encode("finishFeature", forKey: .type)
            try container.encode(v, forKey: .value)

        case .tapButton(let v):
            try container.encode("tapButton", forKey: .type)
            try container.encode(v, forKey: .value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let value = try container.decode(String.self, forKey: .value)

        switch type {
        case "openPage": self = .openPage(value)
        case "finishFeature": self = .finishFeature(value)
        case "tapButton": self = .tapButton(value)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown event type: \(type)"
            )
        }
    }
}


// MARK: - Subscriber Wrapper（弱引用）
private class Subscriber {
    weak var object: AnyObject?
    let handler: (TaskEvent) -> Void

    init(object: AnyObject, handler: @escaping (TaskEvent) -> Void) {
        self.object = object
        self.handler = handler
    }
}


// MARK: - 最终版 EventCenter
@MainActor
public final class EventCenter: @unchecked Sendable {
    public static let shared = EventCenter()
    private init() {}

    private var subscribers: [Subscriber] = []

    /// 订阅事件（自动弱引用，不会泄漏）
    public func subscribe(_ owner: AnyObject,
                          handler: @escaping (TaskEvent) -> Void) {

        subscribers.append(Subscriber(object: owner, handler: handler))
    }

    /// 分发事件（保证一定在主线程执行 subscribers）
    public func send(_ event: TaskEvent) {

        // 清理已经释放的订阅者
        subscribers.removeAll { $0.object == nil }

        // 保证所有事件处理在主线程上
        DispatchQueue.main.async {
            for s in self.subscribers {
                s.handler(event)
            }
        }
    }
}
