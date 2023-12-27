//
//  EventsViewModel.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation
import Combine

enum EventsViewModelState: Equatable {
    case initState
    case loading
    case finishedLoading
    case error(ErrorResponse)
}


final class EventsViewModel {
    @Published private(set) var events: [Event] = []
    @Published private(set) var state: EventsViewModelState = .initState

    private let discoveryRequestFactory: DiscoveryServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    let eventsModel = EventsModel(
        title: "Simple TM Events List",
        searchBarPlaceholder: "Search by Artist, Event or Venue",
        monitorLabel: "Monitor"
    )

    init(discoveryRequestFactory: DiscoveryServiceProtocol = DiscoveryRequestFactory()) {
        self.discoveryRequestFactory = discoveryRequestFactory
    }

    func search(keyword: String) {
        searchEventsBy(with: keyword)
    }
}

extension EventsViewModel {
    private func searchEventsBy(with keyword: String) {
        state = .loading
        discoveryRequestFactory.searchEventsBy(keyword: keyword) { [weak self] result in
            switch result {
            case .success(let response):
                self?.state = .finishedLoading
                guard let eventsResponse = response?.embedded.events else { return }
                self?.events = eventsResponse
            case .failure(let errorResponse):
                self?.state = .error(errorResponse)
            }
        }
    }
}
