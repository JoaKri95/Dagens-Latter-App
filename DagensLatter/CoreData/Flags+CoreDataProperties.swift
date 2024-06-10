

import Foundation
import CoreData


extension Flags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flags> {
        return NSFetchRequest<Flags>(entityName: "Flags")
    }

    @NSManaged public var nsfw: Bool
    @NSManaged public var religious: Bool
    @NSManaged public var political: Bool
    @NSManaged public var racist: Bool
    @NSManaged public var sexist: Bool
    @NSManaged public var explicit: Bool
    @NSManaged public var joke: Joke?

}

extension Flags : Identifiable {

}
