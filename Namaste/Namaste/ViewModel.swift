//
//  ViewModel.swift
//  Namaste
//
//  Created by 陳憶婷 on 2025/3/7.
//

import Combine

@MainActor
final class ViewModel {
    
    private(set) var tabs: [TabModel] = []
    
    private(set) var currentTab: TabModel?
    
    private func fetchModels() async throws -> [TabModel] {
        try? await Task.sleep(nanoseconds: 1)
        return [
            TabModel(title: "Yoga", curations: [
                CurationModel(title: "Beginner", items: [
                    ItemModel(title: "Hatha", image: nil),
                    ItemModel(title: "Yin", image: nil),
                    ItemModel(title: "Restorative", image: nil),
                    ItemModel(title: "Vinyasa", image: nil),
                    ItemModel(title: "Gentle", image: nil),
                    ItemModel(title: "Flow", image: nil)
                ]),
                CurationModel(title: "Advanced", items: [
                    ItemModel(title: "Bikram", image: nil),
                    ItemModel(title: "Power", image: nil),
                    ItemModel(title: "Iyengar", image: nil),
                    ItemModel(title: "Ashtanga", image: nil),
                    ItemModel(title: "Intensive", image: nil),
                    ItemModel(title: "Precision", image: nil)
                ]),
            ]),
            TabModel(title: "Workout", curations: [
                CurationModel(title: "Bodyweight Training", items: [
                    ItemModel(title: "Push-ups", image: nil),
                    ItemModel(title: "Squats", image: nil),
                    ItemModel(title: "Lunges", image: nil),
                    ItemModel(title: "Plank", image: nil)
                ]),
                CurationModel(title: "Cardio & Endurance Training", items: [
                    ItemModel(title: "Jump Rope", image: nil),
                    ItemModel(title: "Jumping Jacks", image: nil),
                    ItemModel(title: "Mountain Climbers", image: nil),
                    ItemModel(title: "Shadow Boxing", image: nil)
                ])
            ]),
            TabModel(title: "Meditation", curations: [
                CurationModel(title: "Breath Awareness", items: [
                    ItemModel(title: "Mantra", image: nil),
                    ItemModel(title: "Trataka", image: nil),
                    ItemModel(title: "Lunges", image: nil),
                    ItemModel(title: "Chakra", image: nil)
                ]),
                CurationModel(title: "Open Monitoring", items: [
                    ItemModel(title: "Mindfulness", image: nil),
                    ItemModel(title: "Vipassana", image: nil),
                    ItemModel(title: "Zen", image: nil),
                    ItemModel(title: "Noting", image: nil),
                    ItemModel(title: "Body Scan", image: nil)
                ])
            ]),
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
            self.handleEvent(input)
        }
        .store(in: &cancellables)
        
        return output
    }
    
    private func handleEvent(_ input: Input) {
        switch input {
        case .viewDidLoad:
            Task {
                do {
                    self.tabs = try await self.fetchModels()
                    self.currentTab = self.tabs.first
                    self.output.reloadPage.send(())
                } catch {
                    print("log fetchModels error \(error)")
                }
            }
        }
    }
}
