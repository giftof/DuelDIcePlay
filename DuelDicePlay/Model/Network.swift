//
//  JsonParser.swift
//  DuelDicePlay
//
//  Created by kyuhkim on 2021/10/17.
//

import Foundation

protocol NetworkDelegate {
    
    func myData() -> Data
    func someoneData(name: String, tag: String) -> Data
    func diceData() -> Data
    func diceHistory(with uuid: String) -> Data
}

struct Network: NetworkDelegate {
    var token: String?
    
    init () {
        token = GetToken().getToken()
        guard token != nil else { assert(false) }
    }

    func myData() -> Data {
        guard let user = GetUserInfo().getUser(with: token!).data(using: .utf8) else { assert(false) }
        return user
    }
    
    func someoneData(name: String, tag: String) -> Data {
        guard let user = GetSomeoneInfo().getUser(with: token!, who: name, by: tag).data(using: .utf8) else { assert(false) }
        return user
    }
    
    func diceData() -> Data {
        guard let dice = GetDiceInfo().getDice(with: token!).data(using: .utf8) else { assert(false) }
        return dice
    }
    
    func diceHistory(with uuid: String) -> Data {
        guard let history = GetHistory().getHistory(with: uuid).data(using: .utf8) else { assert(false) }
        print(GetHistory().getHistory(with: uuid))
        return history
    }
    
    func convert<T: Decodable>(from data: Data, to: T) -> T {
        guard let result = try? JSONDecoder().decode(T.self, from: data) else { assert(false) }
        return result
    }
}


