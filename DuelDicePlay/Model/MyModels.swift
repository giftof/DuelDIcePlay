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


// MARK: - DiceHistory

struct DiceHistoryModel: Codable {
    var nameHistory:    [String]
}


// MARK: - User

class User {
    var instance:       UserModel?
    var dices:          [DiceModel] = []
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

// MARK: - NOT_YET

struct DecodeJson {
    
    func with<T: Decodable>(rawData: Data) -> T {
        guard let decode = try? JSONDecoder().decode(T.self, from: rawData) else { assert(false) }

        return decode
    }
    
}


