//
//  TemplateApplicationTests.swift
//  TemplateApplicationTests
//
//  Created by Kyle Pointer on 30.06.21.
//

import XCTest
@testable import Gymder

class ContainerTests: XCTestCase {

    override class func setUp() {
        Container.shared.register(for: ExampleProtocol.self) { _ in
            ExampleImpl()
        }

        Container.shared.register(for: ExampleProtocol2.self) { _ in
            ExampleImpl2()
        }

        Container.shared.register(for: ChildProtocol.self) { _ in
            ChildImpl()
        }

        Container.shared.register(for: ParentProtocol.self) { container in
            ParentImpl(child: container.get(instanceOf: ChildProtocol.self))
        }
    }

    func testGet() throws {
        XCTAssertNotNil(
            Container.shared.get(instanceOf: ExampleProtocol.self)
        )

        XCTAssertNotNil(
            Container.shared.get(instanceOf: ExampleProtocol2.self)
        )

        XCTAssertNotNil(
            Container.shared.get(instanceOf: ChildProtocol.self)
        )

        XCTAssertNotNil(
            Container.shared.get(instanceOf: ParentProtocol.self)
        )
    }

    func testFactoriesCreateNewObjects() {
        XCTAssertNotIdentical(
            Container.shared.get(instanceOf: ExampleProtocol.self),
            Container.shared.get(instanceOf: ExampleProtocol.self)
        )
    }
}

protocol ExampleProtocol: AnyObject {}
class ExampleImpl: ExampleProtocol {}

protocol ExampleProtocol2 {}
class ExampleImpl2: ExampleProtocol2 {
}

protocol ParentProtocol {}
class ParentImpl: ParentProtocol {
    let child: ChildProtocol

    init(child: ChildProtocol) {
        self.child = child
    }
}

protocol ChildProtocol {}
class ChildImpl: ChildProtocol {}
