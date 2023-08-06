//
//  MemoClient.swift
//  TCASimpleTutorial
//
//  Created by Quasy Kei on 2023/08/06.
//

import Foundation
import ComposableArchitecture

struct MemoClient {
    var fetchMemoItem: (_ id: String) -> EffectTask<Memo>
    var fetchMemos: () -> EffectTask<[Memo]>
    
    struct Failure : Error, Equatable {}
}

extension MemoClient {
    static let live = Self { id in
        EffectTask.task {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://test.mockapi.io/api/01/todos/\(id)")!)
            return try JSONDecoder().decode(Memo.self, from: data)
        }
        .mapError { _ in
            fatalError("Fetch Memo Item Error!")
        }
        .eraseToEffect()
    } fetchMemos: {
        EffectTask.task {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://test.mockapi.io/api/01/todos/")!)
            return try JSONDecoder().decode([Memo].self, from: data)
        }
        .mapError { _ in
            fatalError("Fetch Memo List Error!")
        }
        .eraseToEffect()
    }

}
