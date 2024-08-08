//
//  ContentView.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    @State private var searchText: String = "corn"
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search...", text: $searchText, onCommit: {
                        viewModel.query = searchText
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                    
                    Button(action: {
                        viewModel.query = searchText
                    }) {
                        Text("Search")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical)
                
                List(viewModel.searchResults) { result in
                    ZStack {
                        SearchResultView(searchResult: result)
                        NavigationLink(destination: RecipeView(viewModel: RecipeViewModel(searchResult: result))) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .padding(0)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct SearchResultView: View {
    var searchResult: SearchResult
    @State private var isFavorited: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                // Image
                if let imageURL = searchResult.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .clipped()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .clipped()
                    }
                } else {
                    // Placeholder image if the URL is nil or invalid
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 120)
                        .clipped()
                }
                
                // Favorite Button
                Button(action: {
                    // No-op
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red : .white)
                        .padding(8)
                }
                .onAppear {
                    isFavorited = CoreDataManager.shared.isFavorited(recipeId: searchResult.id)
                }
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
                .padding()
            }
            
            // Title
            Text(searchResult.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 8)
                .padding(.horizontal, 16)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
