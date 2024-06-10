

import Foundation
import CoreData


extension Joke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Joke> {
        return NSFetchRequest<Joke>(entityName: "Joke")
    }

    @NSManaged public var error: String?
    @NSManaged public var category: String?
    @NSManaged public var type: String?
    @NSManaged public var joke: String?
    @NSManaged public var safe: Bool
    @NSManaged public var id: String?
    @NSManaged public var lang: String?
    @NSManaged public var setup: String?
    @NSManaged public var delivery: String?
    @NSManaged public var isRated: Bool
    @NSManaged public var rating: Int16
    @NSManaged public var comment: String?
    @NSManaged public var isUserCreated: Bool
    @NSManaged public var flags: Flags?

}

extension Joke : Identifiable {

}
