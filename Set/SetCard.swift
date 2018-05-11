//
//  SetCard.swift
//  Set
//
//  Created by YinYifei on 2018-05-08.
//  Copyright © 2018 Yifei Yin. All rights reserved.
//

import Foundation

struct SetCard: CustomStringConvertible, Equatable {
    
    var description: String {
        var output = ""
        output += "number :\(number)"
        output += " / color  :\(color)"
        output += " / symbol:\(symbol)"
        output += " / shading:\(shading)\n"
        return output
    }
    
    enum Property: Int, CustomStringConvertible {
        var description: String { return "\(rawValue)"}
        case a = 1
        case b = 2
        case c = 3
        
        static let all = [a, b, c]
    }
    
    var properties: [Property] {
            return [number, color, symbol, shading]
    }
    
    var number: Property
    var color: Property
    var symbol: Property
    var shading: Property
}






























