import CoreData

public extension NSPersistentContainer {
    convenience init(storeUrl: URL, model: NSManagedObjectModel) {
        self.init(name: storeUrl.deletingPathExtension().lastPathComponent, managedObjectModel: model)
        persistentStoreDescriptions.first?.url = storeUrl
    }

    func destroyPersistentStores() throws {
        try persistentStoreDescriptions.forEach { try persistentStoreCoordinator.destroyPersistentStore(description: $0) }
    }

    func loadPersistentStoresSync() -> [(NSPersistentStoreDescription, Error)] {
        persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = false
        }
        var errors: [(NSPersistentStoreDescription, Error)] = []
        loadPersistentStores { storeDescription, error in
            if let error = error {
                errors.append((storeDescription, error))
            }
        }
        return errors
    }

    func loadPersistentStoresAsync(completionQueue: DispatchQueue = .main, _ block: @escaping ([(NSPersistentStoreDescription, Error)]) -> Void) {
        let group = DispatchGroup()
        persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = true
            group.enter()
        }
        var errors: [(NSPersistentStoreDescription, Error)] = []
        loadPersistentStores { storeDescription, error in
            if let error = error {
                errors.append((storeDescription, error))
            }
            group.leave()
        }
        group.notify(queue: completionQueue) {
            block(errors)
        }
    }
}
