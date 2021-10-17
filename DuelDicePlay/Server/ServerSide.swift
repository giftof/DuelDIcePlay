//
//  ServerSide.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/17.
//

import Foundation

//struct GetRandomNumberOfDice {
//    var dice: [DiceModel]
//    
//}

struct GetDiceResult {
    func getResult() -> String {
        let diceRollJsonString = """
        {
            "numbers"       : [ \(Int.random(in: 1...6)), \(Int.random(in: 1...6)), \(Int.random(in: 1...6)) ]
        }
        """
        return diceRollJsonString
    }
}

struct GetDiceInfo {
    func getDice(with token: String) -> String {
        let diceJsonString = """
        {
            "uuid"          : "diceUUID",
            "name"          : "diceName",
            "faceCount"     : 6,
            "startNumber"   : 1,
            "step"          : 1,
            "imagePath"     : "diceImagePath",
            "history"       : []
        }
        """
        return diceJsonString
    }
}

struct GetUserInfo {
    func getUser(with token: String) -> String {
        let userJsonString = """
        {
            "name"          : "noname",
            "identify"      : "2021",
            "thumbNailPath" : "myURL",
            "level"         : 1,
            "diceUUIDArray" : [ "dice0", "dice1", "dice2" ]
        }
        """
        return userJsonString
    }
}

struct GetSomeoneInfo {
    func getUser(with token: String, who name: String, by tag: String) -> String {
        let userJsonString = """
        {
            "name"          : "enemy",
            "identify"      : "2022",
            "thumbNailPath" : "someoneURL",
            "level"         : 1,
            "diceUUIDArray" : [ "dice10", "dice11", "dice12" ]
        }
        """
        return userJsonString
    }
}

struct GetHistory {
    func getHistory(with diceUUID: String) -> String {
        let diceHistory = """
        {
            "nameHistory"   : ["name0", "tag0", "name1", "tag1", "name2", "tag2"]
        }
        """
        return diceHistory
    }
}

struct GetToken {
    func getToken() -> String? {
        return "myTokenString"
    }
}
