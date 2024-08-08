//
//  Persistence.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "food_search")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "food_search")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save a favorite recipe
    func saveFavorite(recipe: SearchResult) {
        let favorite = FavoriteRecipe(context: context)
        favorite.id = Int64(recipe.id)
        saveContext()
    }

    // Fetch favorite recipes
    func fetchFavorites() -> [FavoriteRecipe] {
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }

    // Check if a recipe is favorited
    func isFavorited(recipeId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", recipeId)
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to check if favorited: \(error)")
            return false
        }
    }

    // Remove a favorite recipe
    func removeFavorite(recipeId: Int) {
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", recipeId)
        do {
            let results = try context.fetch(fetchRequest)
            for favorite in results {
                context.delete(favorite)
            }
            saveContext()
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }

    // Save context
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
