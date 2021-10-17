//
//  User.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/17.
//

import Foundation

// MARK: - DiceModel

struct DiceModel : Codable {
    var uuid:           String
    var name:           String
    var faceCount:      Int
    var startNumber:    Int
    var step:           Int
    var imagePath:      String
    var history:        [String]
}


// MARK: - UserModel

struct UserModel: Codable {
    var name:           String
    var identify:       String
    var thumbNailPath:  String
    var level:          Int
    var diceUUIDArray:  [String]
}


// MARK: - Decode

struct DiceRoll: Codable {
    var numbers:        [Int]
}


// MARK: - DiceHistory

struct DiceHistoryModel: Codable {
    var nameHistory:    [String]
}


// MARK: - User

class User: NSObject {
    var instance:       UserModel?
    var dices:          [DiceModel] = []
    var network         = Network()
    @objc dynamic var rollResult    = 0
    
    func createUserInstance() {
        guard let instance:UserModel = DecodeJson().to(rawData: network.myData()) else { assert(false) }
        self.instance = instance
    }

    func createUserInstanceBy(name: String, tag: String) {
        guard let instance:UserModel = DecodeJson().to(rawData: network.someoneData(name: name, tag: tag)) else { assert(false) }
        self.instance = instance
    }

    func createDiceModel() -> DiceModel {
        let dice:DiceModel = DecodeJson().to(rawData: network.diceData())
        return dice
    }

    func addDiceModel() {
        guard (instance != nil) else { assert(false) }
        var amount = 0
        while amount < self.instance?.diceUUIDArray.count ?? 0 {
            let dice = createDiceModel()
            self.dices.append(dice)
            amount += 1
        }
    }

    func requestRollingDices() {
        self.rollResult = 0
        let roll: DiceRoll = DecodeJson().to(rawData: network.diceRoll())
        for element in roll.numbers {
#if DEBUG
            print(element)
#endif
            self.rollResult += element
        }
    }
}


// MARK: - PairData (array by step 2)

struct MakePair {
    
    func with<T>(arraySource input:[T]) -> [(T, T)] {
        let pair = stride(from: 0, to: input.count - 1, by: 2).map {
            (input[$0], input[$0 + 1])
        }
        return pair
    }
}


// MARK: - Decode

struct DecodeJson {
    
    func to<T: Decodable>(rawData: Data) -> T {
        guard let decode = try? JSONDecoder().decode(T.self, from: rawData) else { assert(false) }

        return decode
    }
    
}


// MARK: - Both played

class RollingCountUserAndEnemy {
    var user     = 0
    var enemy    = 0
}


// MARK: - NOT_YET
