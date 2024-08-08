//
//  RecipeView.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ScrollView { // Allow vertical scrolling for content
            VStack() {
                // Image
                if let imageURL = viewModel.searchResult.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .clipped()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .clipped()
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 120)
                        .clipped()
                }
                
                // Title
                Text(viewModel.searchResult.title)
                    .font(.largeTitle)                
                
                // readyInMinutes
                if let readyInMinutes = viewModel.recipeResult?.readyInMinutesFormatted {
                    Text(readyInMinutes)
                        .padding(.vertical)
                }
                
                Divider()

                // Ingredients
                if let ingredients = viewModel.recipeResult?.extendedIngredients {
                    Text("Ingredients")
                        .font(.title3)
                        .padding(.vertical)
                    VStack(alignment: .leading) {

                        ForEach(ingredients, id: \.self) { item in
                            Text(item.originalName)
                        }
                    }
                    .padding(.vertical)
                }
                
                Divider()

                // Summary
                if let summary = viewModel.recipeResult?.summary.formatHTML {
                    Text("summary")
                        .font(.title3)
                        .padding()
                    Text(summary)
                        .padding(.vertical)
                }

                Divider()

                // Instructions
                if let instructions = viewModel.recipeResult?.instructions.formatHTML {
                    Text("Instructions")
                        .font(.title3)
                        .padding()
                    Text(instructions)
                        .padding(.vertical)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(viewModel.searchResult.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
