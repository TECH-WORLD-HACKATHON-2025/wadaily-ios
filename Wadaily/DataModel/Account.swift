//
//  Account.swift
//  Wadaily
//
//  Created by 浦山秀斗 on 2025/11/30.
//

import Foundation

struct Account: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let intro: String
    let iconUrl: String
    let backgroundUrl: String
}
