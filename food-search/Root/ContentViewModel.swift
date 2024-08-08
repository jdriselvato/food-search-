//
//  ContentViewModel.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var searchResults: [SearchResult] = []

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                print("Query updated: \(searchText)")
                self?.getSearchResults(query: searchText.lowercased())
            }
            .store(in: &cancellables)
    }
    
    private func getSearchResults(query: String) {
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        
        FoodAPI.shared.fetchComplexSearchResults(query: query)
            .receive(on: RunLoop.main)
            .map { complexSearch in
                print("Search results received: \(complexSearch.results)")
                return complexSearch.results
            }
            .catch { error -> Just<[SearchResult]> in
                print("Error fetching search results: \(error)")
                return Just([])
            }
            .assign(to: &$searchResults)
    }
}
