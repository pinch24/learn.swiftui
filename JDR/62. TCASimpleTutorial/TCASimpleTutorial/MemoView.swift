//
//  MemoView.swift
//  TCASimpleTutorial
//
//  Created by Quasy Kei on 2023/08/06.
//

import SwiftUI
import ComposableArchitecture

struct MemoState: Equatable {
    var memos: [Memo] = []
    var selectedMemo: Memo? = nil
    var isLoading: Bool = false
}

enum MemoAction: Equatable {
    case fetchItem(_ id: String)
    case fetchItemResponse(Result<Memo, Never>)
    case fetchAll
    case fetchAllResponse(Result<[Memo], Never>)
}

struct MemoEnvironment {
    var memoClient: MemoClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let memoReducer = AnyReducer<MemoState, MemoAction, MemoEnvironment> { state, action, environment in
    switch action {
    case .fetchItem(let memoId):
        enum FetchItemId {}
        state.isLoading = true
        return environment
            .memoClient
            .fetchMemoItem(memoId)
            .debounce(id: FetchItemId.self, for: 0.3, scheduler: environment.mainQueue)
            .catchToEffect(MemoAction.fetchItemResponse)
    case .fetchItemResponse(.success(let memo)):
        state.selectedMemo = memo
        state.isLoading = false
        return EffectTask.none
    case .fetchItemResponse(.failure):
        state.selectedMemo = nil
        state.isLoading = false
        return EffectTask.none
    case .fetchAll:
        enum FetchAllId {}
        state.isLoading = true
        return environment
            .memoClient
            .fetchMemos()
            .debounce(id: FetchAllId.self, for: 0.3, scheduler: environment.mainQueue)
            .catchToEffect(MemoAction.fetchAllResponse)
    case .fetchAllResponse(.success(let memos)):
        state.memos = memos
        state.isLoading = false
        return EffectTask.none
    case .fetchAllResponse(.failure):
        state.memos = []
        state.isLoading = false
        return EffectTask.none
    }
}

struct MemoView: View {
    
    let store: Store<MemoState, MemoAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                if viewStore.state.isLoading {
                    Color
                        .black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .overlay {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.7)
                        }.zIndex(1)
                }
                
                List {
                    Section(header:
                                VStack(spacing: 8) {
                                    Button("Fetch Memo List", action: {
                                        viewStore.send(.fetchAll, animation: .default)
                                    })
                                    Text("Selected Memo Info")
                                    Text(viewStore.state.selectedMemo?.id ?? "Empty")
                                    Text(viewStore.state.selectedMemo?.title ?? "Empty")
                                }
                            , content: {
                                ForEach(viewStore.state.memos) { aMemo in
                                    Button(aMemo.title, action: {
                                        viewStore.send(.fetchItem(aMemo.id), animation: .default)
                                    })
                                }
                    })
                }
            }
        }
    }
}

struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        let memoStore = Store(initialState: MemoState(), reducer: memoReducer, environment: MemoEnvironment(memoClient: MemoClient.live, mainQueue: .main))
        MemoView(store: memoStore)
    }
}
