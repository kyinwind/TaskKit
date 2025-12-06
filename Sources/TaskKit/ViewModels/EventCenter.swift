//
//  EventCenter.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//
public enum TaskEvent {
    case openPage(String)
    case finishFeature(String)
    case tapButton(String)
}

@MainActor
public final class EventCenter : @unchecked Sendable {
    public static let shared = EventCenter()
    private init() {}

    private var subscribers: [(TaskEvent) -> Void] = []

    public func send(_ event: TaskEvent) {
        for s in subscribers {
            s(event)
        }
    }

    public func subscribe(_ handler: @escaping (TaskEvent) -> Void) {
        subscribers.append(handler)
    }
}
