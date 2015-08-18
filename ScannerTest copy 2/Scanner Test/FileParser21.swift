    //
//  FileParser21.swift
//  Scanner Test
//
//  Created by Elliot Taylor Garner on 4/25/15.
//  Copyright (c) 2015 CILS. All rights reserved.
//

import Foundation

class FileParser21 : NSObject {
    
    let custodianName = "Elliot Garner"
    
    var fileName: String!
    let fileNameToWriteTo = "DownloadedFromDrive.csv"
    var Dict1_Inventory_Record = [String: Record]()
    var Dict2_Serial_Inventory = [String: String]()
    var Dict3_Mac_Inventory = [String: String]()
    var al = [String]()
    
    
    
    func addToHash() {
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let dir = dirs[0]
            self.fileName = dir.stringByAppendingPathComponent(self.fileNameToWriteTo)
        }
        if var aStreamReader = StreamReader(path: fileName) {
            while let line = aStreamReader.nextLine() {
                if line != "" {
                    var record = Record(s: line)
                    if record.str[0] == "C78317" {
                        println("here")
                    }
                    Dict1_Inventory_Record[record.str[0]] = record
                    Dict2_Serial_Inventory[record.str[1]] = record.str[0]
                    Dict3_Mac_Inventory[record.str[2]] = record.str[0]
                    al.append(record.str[0])
                }
            }
        }
    }
    
    func writeToFile() {
        println("writing")
        var max = al.count
        var file = NSFileHandle(forUpdatingAtPath: self.fileName)!
        for var i = 0; i < max; i++ {
            if i == 2467 {
                var record = Dict1_Inventory_Record[al[i]]!
                var recordString = record.makeString() as NSString
                var recordLength = recordString.length
                let data = recordString.dataUsingEncoding(NSUTF8StringEncoding)
                file.writeData(data!)
            }
            else {
                var record = Dict1_Inventory_Record[al[i]]!
                var recordString = record.makeString() as NSString
                var recordLength = recordString.length
                let data = recordString.dataUsingEncoding(NSUTF8StringEncoding)
                file.writeData(data!)
            }
        }
        var data = file.readDataToEndOfFile()
        var string = NSString(data: data, encoding: NSUTF8StringEncoding)
        file.closeFile()
    }
    
    func addItem(inventory: String, serial: String, mac: String, stock: String, buildID: String, buildName: String, abbrev: String, room: String, model: String, description: String) {
        var newRecord = Record(inventory, serial: serial, mac: mac, stock: stock, buildID: buildID, buildName: buildName, abbrev: abbrev, room: room, model: model, description: description)
        var nsArray = al as NSArray
        if !nsArray.containsObject(inventory) {
            al.append(inventory)
        }
        Dict1_Inventory_Record[inventory] = newRecord
    }
    
    func update(inventory: String, serial: String, mac: String, stock: String, buildID: String, buildName: String, abbrev: String, room: String, model: String) {
        updateMacAddress(inventory, update: mac)
        updateStockNumber(inventory, update: stock)
        updateBuildingID(inventory, update: buildID)
        updateBuildingName(inventory, update: buildName)
        updateAbbreviation(inventory, update: abbrev)
        updateRoom(inventory, update: room)
        updateModel(inventory, update: model)
        updateDescription(inventory, update: description)
        
    }
    
    func updateMacAddress(item: String, update: String) {
        updateHash(item, update: update, t: Title.MAC_ADDRESS)
    }
    
    func updateHash(item: String, update: String, t: Title) {
        Dict1_Inventory_Record[item] = Dict1_Inventory_Record[item]?.updateRecord(update, t: t)
    }
    
    func updateStockNumber(item: String, update: String) {
        updateHash(item, update: update, t: Title.STOCK_NUMBER)
    }
    
    func updateCustodian(item: String, update: String) {
        updateHash(item, update: update, t: Title.CUSTODIAN)
    }
    
    func updateBuildingID(item: String, update: String) {
        updateHash(item, update: update, t: Title.BUILDING_ID)
    }
    
    func updateBuildingName(item: String, update: String) {
        updateHash(item, update: update, t: Title.NAME)
    }
    
    func updateAbbreviation(item: String, update: String) {
        updateHash(item, update: update, t: Title.ABBREVIATION)
    }
    
    func updateRoom(item: String, update: String) {
        updateHash(item, update: update, t: Title.ROOM)
    }
    
    func updateModel(item: String, update: String) {
        updateHash(item, update: update, t: Title.MODEL)
    }
    
    func updateDescription(item: String, update: String) {
        updateHash(item, update: update, t: Title.DESCRIPTION)
    }
    
    
    func exit() {
        self.writeToFile()
    }
    
}
