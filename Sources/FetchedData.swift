import CoreData

public class FetchedData<T: NSFetchRequestResult> {
    public let controller: NSFetchedResultsController<T>
    public let blocks: FetchedDataBlocks<T>

    public init(_ controller: NSFetchedResultsController<T>) {
        self.controller = controller
        self.blocks = FetchedDataBlocks(controller)
    }
}

public extension FetchedData {
    subscript(_ indexPath: IndexPath) -> T {
        return controller.object(at: indexPath)
    }
}
