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
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    var body: some View {
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
                NavigationLink(destination: SearchResultDetailView(result: result)) {
                    SearchResultView(searchResult: result)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            .padding(0)
        }
        .navigationTitle("Search")
    }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
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
                    isFavorited.toggle()
                }) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red : .white)
                        .padding(8)
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
