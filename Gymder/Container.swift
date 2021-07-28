//
//  Container.swift
//  TemplateApplication
//
//  Created by Kyle Pointer on 30.06.21.
//

import Foundation

/**

 Extremely simple DI container.

 Register a dependency using `register(for:factory)`
 and use the completion to request any registered collaborators from
 the container.

 Get a component via the `get(instanceOf:)` method.
 Any attempt to instantiate an unregistered component will
 intentionally cause an immediate and fatal error.

 Each call so `get(instanceOf:)` will construct a *new*
 object and not a singelton (given that an object type is requested).

 All of the errors thrown by this container are intentionally
 fatal and not catchable for a few reasons:
 - I would like to keep the interface as simple to use as possible
   so I would like to avoid having to unwrap an optional each time
   a component is requested or  handle a checked exception.
 - I would prefer that the system *fail fast* in the event that
   the dependencies are misconfigured.
 - I conceed that there may be good reasons to change this
   behavior in the future that I haven't considered yet.

 */

class Container {
    private var components = [String: () -> Any]()
    private init() {}

    static let shared = Container()

    func get<T>(instanceOf type: T.Type) -> T {
        guard let factory = components["\(type)"] else {
            fatalError("No factory registered for type \"\(type)\"")
        }

        guard let component = factory() as? T else {
            fatalError(
                "Factory registered for protocol `\(type)` returned" +
                " instance that could not be cast to `\(type)`"
            )
        }

        return component
    }

    func register<T>(for protocol: T, factory: @escaping (Container) -> Any) {
        components["\(`protocol`)"] = {
            factory(self)
        }
    }
}
