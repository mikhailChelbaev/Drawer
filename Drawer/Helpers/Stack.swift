//
//  Stack.swift
//  Drawer
//
//  Created by Mikhail on 12.10.2021.
//

import Foundation

struct Stack<T> {
    
    private var items: [T] = []
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    mutating func push(_ value: T) {
        items.append(value)
    }
    
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    mutating func clear() {
        items = []
    }
    
}
