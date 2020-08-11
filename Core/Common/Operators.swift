//
//  Operators.swift
//  Core
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

infix operator <>= : AssignmentPrecedence
infix operator ??= : AssignmentPrecedence

/// Operator <>= means assign if operands are not equal
public func <>= <T: Equatable>(lhs: inout T, rhs: T) {
    if lhs != rhs {
        lhs = rhs
    }
}

/// Operator `??=` is used to assign Optional value to non Optional.
/// It works like `<>=` but first checks if right operand != nil.
public func ??= <T: Equatable>(lhs: inout T, rhs: T?) {
    guard let rhs: T = rhs else {
        return
    }
    
    if lhs != rhs {
        lhs = rhs
    }
}
