//
//  ViewModel.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/3/7.
//

import Combine

final class ViewModel {
    
    private(set) var tabs: [TabModel] = []
    
    private(set) var currentTab: TabModel?
    
//    private func fetchModels() async throws -> [TabModel] {
    private func fetchModels() -> [TabModel] {
        return [
            TabModel(title: "Yoga", curations: [
                CurationModel(title: "Beginner", items: [
                    ItemModel(title: "Sleeping Yoga", image: nil),
                    ItemModel(title: "22", image: nil),
                    ItemModel(title: "33", image: nil),
                    ItemModel(title: "44", image: nil)
                ]),
                CurationModel(title: "Advanced", items: [
                    ItemModel(title: "11", image: nil),
                    ItemModel(title: "Jam", image: nil),
                    ItemModel(title: "33", image: nil),
                    ItemModel(title: "44", image: nil)
                ]),
            ]),
            TabModel(title: "Workout", curations: []),
            TabModel(title: "Meditation", curations: []),
        ]
    }
    
    struct Output {
        let reloadPage = PassthroughSubject<Void, Never>()
    }
    
    enum Input {
        case viewDidLoad
    }
    
    private let output = Output()
    
    private var cancellables = Set<AnyCancellable>()
    
    func binding(_ event: AnyPublisher<Input, Never>) -> Output {
        event.sink { [weak self] input in
            guard let self = self else {
                return
            }
            switch input {
            case .viewDidLoad:
                self.tabs = self.fetchModels()
                self.currentTab = self.tabs.first
                self.output.reloadPage.send(())
//                Task {
//                    do {
//                        self.tabs = try await self.fetchModels()
//                        self.currentTab = self.tabs.first
//                        self.output.reloadPage.send(())
//                    } catch {
//                        print("log fetchModels error \(error)")
//                    }
//                }
            }
        }
        .store(in: &cancellables)
        
        return output
    }
}
