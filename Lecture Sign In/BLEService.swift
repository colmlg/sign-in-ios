//
//  BLEService.swift
//  Lecture Sign In
//
//  Created by Colm Le Gear on 07/10/2018.
//  Copyright © 2018 Colm Le Gear. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEService: NSObject {
    
    static let shared = BLEService()
    private override init() {
        super.init()
    }
}

extension BLEService: CBPeripheralDelegate {
    
}
