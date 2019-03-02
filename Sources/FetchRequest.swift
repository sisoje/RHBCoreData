import CoreData
import RHBFoundation

public class FetchRequest<T: NSManagedObject> {
    public static func fetchRequest() -> NSFetchRequest<T> {
        return T.fetchRequest() as! NSFetchRequest<T>
    }

    public let request = FetchRequest.fetchRequest()

    public init() {}
}

extension FetchRequest {
    func addUnconstrainedSort<V>(by keyPath: KeyPath<T, V>, ascending: Bool) -> Self {
        let desc = NSSortDescriptor(keyPath: keyPath, ascending: ascending)
        request.sortDescriptors = (request.sortDescriptors ?? []) + [desc]
        return self
    }
}

public extension FetchRequest {
    convenience init<P: NSPredicate & TypedPredicateProtocol>(predicate: P) where P.Root == T {
        self.init()
        self.predicate(predicate)
    }

    convenience init<V: Comparable>(sortBy keyPath: KeyPath<T, V?>, ascending: Bool) {
        self.init()
        addSort(by: keyPath, ascending: ascending)
    }

    convenience init<V: Comparable>(sortBy keyPath: KeyPath<T, V>, ascending: Bool) {
        self.init()
        addSort(by: keyPath, ascending: ascending)
    }

    @discardableResult
    func predicate<P: NSPredicate & TypedPredicateProtocol>(_ p: P?) -> Self where P.Root == T {
        request.predicate = p
        return self
    }

    @discardableResult
    func addSort<V: Comparable>(by keyPath: KeyPath<T, V?>, ascending: Bool) -> Self {
        return addUnconstrainedSort(by: keyPath, ascending: ascending)
    }

    @discardableResult
    func addSort<V: Comparable>(by keyPath: KeyPath<T, V>, ascending: Bool) -> Self {
        return addUnconstrainedSort(by: keyPath, ascending: ascending)
    }

    var predicate: CompoundPredicate<T>? {
        return request.predicate.map {
            $0 as? CompoundPredicate<T> ?? CompoundPredicate(type: .and, subpredicates: [$0])
        }
    }
}
