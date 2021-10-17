//
//  JsonParser.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/17.
//

import Foundation
import Alamofire

protocol NetworkDelegate {
    
    func from(server url: String, who name: String, by tag: String) -> Data
    func from(server url: String, dice uuid: String) -> Data
    func from(server url: String, my token: String) -> Data
    func from(server url: String, action diceAmount:Int) -> Data
    func auth(server url: String) -> Data

    func myData() -> Data
    func someoneData(name: String, tag: String) -> Data
    func diceData() -> Data
    func diceRoll() -> Data
    func diceHistory(with uuid: String) -> Data
}

struct Network: NetworkDelegate {
    var token: String?
    
    init () {
        token = GetToken().getToken()
        guard token != nil else { assert(false) }
    }

    func from(server url: String, who name: String, by tag: String) -> Data {
//        <#code#>
        let dummy: Data? = "dummy".data(using: .utf8)
        return dummy!
    }
    
    func from(server url: String, dice uuid: String) -> Data {
//        <#code#>
        let dummy: Data? = "dummy".data(using: .utf8)
        return dummy!
    }
    
    func from(server url: String, my token: String) -> Data {
//        <#code#>
        let dummy: Data? = "dummy".data(using: .utf8)
        return dummy!
    }
    
    func from(server url: String, action diceAmount: Int) -> Data {
//        <#code#>
        let dummy: Data? = "dummy".data(using: .utf8)
        return dummy!
    }
    
    func auth(server url: String) -> Data {
//        <#code#>
        let dummy: Data? = "dummy".data(using: .utf8)
        return dummy!
    }
    

    func myData() -> Data {
        guard let user = GetUserInfo().getUser(by: token!).data(using: .utf8) else { assert(false) }
        return user
    }
    
    func someoneData(name: String, tag: String) -> Data {
        guard let user = GetSomeoneInfo().getUser(by: token!, who: name, by: tag).data(using: .utf8) else { assert(false) }
        return user
    }
    
    func diceData() -> Data {
        guard let dice = GetDiceInfo().getDice(by: token!).data(using: .utf8) else { assert(false) }
        return dice
    }
    
    func diceHistory(with uuid: String) -> Data {
        guard let history = GetHistory().getHistory(by: uuid).data(using: .utf8) else { assert(false) }
        return history
    }
    
    func diceRoll() -> Data {
        guard let roll = GetDiceResult().getResult().data(using: .utf8) else { assert(false) }
        return roll
    }
    
    func convert<T: Decodable>(from data: Data, to: T) -> T {
        guard let result = try? JSONDecoder().decode(T.self, from: data) else { assert(false) }
        return result
    }
}


