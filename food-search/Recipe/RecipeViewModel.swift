//
//  RecipeViewModel.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    @Published var searchResult: SearchResult
    @Published var recipeResult: RecipeResult?

    private var cancellables = Set<AnyCancellable>()
    
    init(searchResult: SearchResult) {
        self.searchResult = searchResult
        getRecipeResults(id: searchResult.id)
    }
    
    private func getRecipeResults(id: Int) {
        recipeResult = RecipeResult(
            id: id,
            extendedIngredients: [
                ExtendedIngredients(id: 1, originalName: "Red"),
                ExtendedIngredients(id: 1, originalName: "Blue"),
                ExtendedIngredients(id: 1, originalName: "Orange"),
                ExtendedIngredients(id: 1, originalName: "sdlkmclskmd lkmslkm slkml kmlskm"),
            ],
            readyInMinutes: 100,
            summary: "Cook and stir for 2 minutes more. Transfer to a small bowl; cover and cool to room temperature.</li><li>In a small mixing bowl stir together yogurt and pudding.</li><li>Split pastry rounds horizontally. Spread about 1 teaspoon of the yogurt mixture on the bottom half of each round. Arrange fresh fruit atop pudding. Brush the fruit with orange juice mixture. Replace tops. Cover and chill for 1 to 24 hours.</li><li>To tote, arrange the tarts in single layers in shallow covered plastic containers or baking pans. Cover the pans with foil. Stack the pans in a cooler. Makes about 45.</li></ol>",
            instructions: "<li>To tote, arrange the tarts in single layers in shallow covered plastic containers or baking pans. Cover the pans with foil. Stack the pans in a cooler. Makes about 45.</li>")
        return
        
//        FoodAPI.shared.fetchRecipeResult(id: id)
//            .receive(on: RunLoop.main)
//            .map { result in
//                print("Search results received")
//                return result
//            }
//            .catch { error -> Just<RecipeResult?> in
//                print("Error fetching search results: \(error)")
//                return Just(nil)
//            }
//            .sink(receiveValue: { [weak self] result in
//                self?.recipeResult = result
//            })
//            .store(in: &cancellables)
    }
}
