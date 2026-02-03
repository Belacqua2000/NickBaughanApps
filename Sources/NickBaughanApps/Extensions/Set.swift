//
//  Set.swift
//  NickBaughanApps
//
//  Created by Nick Baughan on 03/02/2026.
//

public extension Set {
    /// Toggle the membership of a given object within the set.
    /// - Parameter element: The element for which you wish to remove or insert into the set.
    /// - Returns: ``Bool.true`` if the element has been inserted. ``Bool.true`` if the element has been removed.
    @discardableResult
    mutating func toggle(_ element: Element) -> Bool {
        if contains(element) {
            remove(element)
            return false // removed
        } else {
            insert(element)
            return true // inserted
        }
    }
}
