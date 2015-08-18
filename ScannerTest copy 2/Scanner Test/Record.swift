//
//  Record.swift
//  Scanner Test
//
//  Created by Elliot Taylor Garner on 4/25/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import Foundation

// array is as follows [inventory number, serial Number, Mac Address, Building ID, Building Name, Abbreviation, Room Number, Stock Number,
//Model, Discription]


class Record {
    
    var str = [String]()
    
    init(s: String) {
        str = split(s) {$0 == ","}
    }
    
    init(_ inventory: String, serial: String, mac: String, stock: String, buildID: String, buildName: String, abbrev: String, room: String, model: String, description: String) {
            str.append(inventory)
            str.append(serial)
            str.append(mac)
            str.append(buildID)
            str.append(buildName)
            str.append(abbrev)
            str.append(room)
            str.append(stock)
            str.append(model)
            str.append(description)
    }
    
    func updateRecord(update: String, t: Title) -> Record {
        str[self.title2Int(t)] = update
        return self
    }
    
    func makeString() -> String {
        var concatenatedString = ""
        for var i = 0; i < str.count - 1; i++ {
            concatenatedString = concatenatedString + str[i] + ","
        }
        concatenatedString += str[str.count - 1] + "\r"
        return concatenatedString
    }
    
    func title2Int(t: Title) -> Int {
        switch t {
        case .INVENTORY_NUMBER:
            return 0;
        case .SERIAL_NUMBER:
            return 1;
        case .MAC_ADDRESS:
            return 2;
        case .BUILDING_ID:
            return 3;
        case .NAME:
            return 4;
        case .ABBREVIATION:
            return 5;
        case .ROOM:
            return 6;
        case .STOCK_NUMBER:
            return 7;
        case .MODEL:
            return 8;
        case .DESCRIPTION:
            return 9;
        default:
            return -1;
        }
    }

    //TO DO
    //GETTERS
    
}
