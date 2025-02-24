import UIKit
import CoreData

extension TaskMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "TaskMO")
    }
    @NSManaged public var title: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var creationDate: Date
    @NSManaged public var isCompleted: Bool
}
extension TaskMO : Identifiable {}
