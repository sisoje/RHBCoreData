import CoreData
import RHBFoundation

public enum FetchRequest<T: NSManagedObject> {}

public extension FetchRequest {
    static var request: NSFetchRequest<T> {
        // swiftlint:disable force_cast
        return T.fetchRequest() as! NSFetchRequest<T>
        // swiftlint:enable force_cast
    }
}

public class FetchRequestBuilder<T: NSManagedObject> {
    public let request = FetchRequest<T>.request
}

public extension FetchRequestBuilder {
    convenience init<P: NSPredicate & TypedPredicateProtocol>(predicate: P) where P.Root == T {
        self.init()
        self.request.predicate = predicate
    }

    convenience init<V: Comparable>(sortBy keyPath: KeyPath<T, V?>, ascending: Bool) {
        self.init()
        addSort(by: keyPath, ascending: ascending)
    }

    convenience init<V: Comparable>(sortBy keyPath: KeyPath<T, V>, ascending: Bool) {
        self.init()
        addSort(by: keyPath, ascending: ascending)
    }

    func addSort<V: Comparable>(by keyPath: KeyPath<T, V?>, ascending: Bool) {
        request.addsort(NSSortDescriptor(keyPath: keyPath, ascending: ascending))
    }

    func addSort<V: Comparable>(by keyPath: KeyPath<T, V>, ascending: Bool) {
        request.addsort(NSSortDescriptor(keyPath: keyPath, ascending: ascending))
    }
}

// MARK: - internal

@objc extension NSFetchRequest {
    func addsort(_ desc: NSSortDescriptor) {
        sortDescriptors = (sortDescriptors ?? []) + [desc]
    }
}
