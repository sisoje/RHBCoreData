import CoreData
import RHBFoundation

public extension NSPersistentContainer {
    convenience init(inMemory model: NSManagedObjectModel) {
        self.init(name: NSInMemoryStoreType, managedObjectModel: model)
        persistentStoreDescriptions.first?.type = NSInMemoryStoreType
    }

    convenience init(storeUrl: URL, model: NSManagedObjectModel) {
        self.init(name: storeUrl.deletingPathExtension().lastPathComponent, managedObjectModel: model)
        persistentStoreDescriptions.first?.url = storeUrl
    }

    func destroyPersistentStores() throws {
        try persistentStoreDescriptions.forEach { try persistentStoreCoordinator.destroyPersistentStore(description: $0) }
    }

    func createPersistentStoreDirectories() throws {
        try persistentStoreDescriptions
            .compactMap { $0.url?.deletingLastPathComponent() }
            .forEach { try FileManager().createDirectory(at: $0, withIntermediateDirectories: true) }
    }

    func loadPersistentStoresSync() throws {
        var error: Error?
        loadPersistentStores {
            $1.map {
                error = $0
            }
        }
        try error.map {
            throw $0
        }
    }

    func loadPersistentStoresAsync(_ block: @escaping (Error?) -> Void) {
        persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = true
        }
        loadPersistentStores {
            block($1)
        }
    }
}
