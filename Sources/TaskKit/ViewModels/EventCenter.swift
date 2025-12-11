//
//  EventCenter.swift
//  TaskKit
//
//  Created by xuehui yang on 2025/12/6.
//
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


@MainActor
public final class EventCenter : @unchecked Sendable {
    public static let shared = EventCenter()
    private init() {}

    private var subscribers: [@MainActor (TaskEvent) -> Void] = []

    public func send(_ event: TaskEvent) {
        for handler in subscribers {
            handler(event)
        }
    }

    public func subscribe(_ handler: @escaping @MainActor @Sendable (TaskEvent) -> Void) {
        subscribers.append(handler)
    }
}
