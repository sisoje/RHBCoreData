import CoreData


public class FetchedDataBlocks<T: NSFetchRequestResult> {
    public var didChangeObject: [NSFetchedResultsChangeType: (T, IndexPath, IndexPath) -> Void] = [:]
    public var didChangeSection: [NSFetchedResultsChangeType: (NSFetchedResultsSectionInfo, Int) -> Void] = [:]
    public var willChange: (() -> Void)?
    public var didChange: (() -> Void)?
    public var sectionIndexTitle: ((String) -> String?)?

    weak var controller: NSFetchedResultsController<T>?
    var delegate: FetchedResultsControllerDelegateWithBlocks<T>!

    init(_ controller: NSFetchedResultsController<T>) {
        self.controller = controller
        self.delegate = FetchedResultsControllerDelegateWithBlocks(self)
        controller.delegate = delegate
    }

    deinit {
        controller?.delegate = nil
    }
}

class FetchedResultsControllerDelegateWithBlocks<T: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate {
    let blocks: FetchedDataBlocks<T>

    init(_ blocks: FetchedDataBlocks<T>) {
        self.blocks = blocks
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        blocks.didChange?()
    }

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        blocks.willChange?()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        blocks.didChangeObject[type]?(anObject as! T, indexPath ?? newIndexPath!, newIndexPath ?? indexPath!)
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return blocks.sectionIndexTitle?(sectionName)
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        blocks.didChangeSection[type]?(sectionInfo, sectionIndex)
    }
}