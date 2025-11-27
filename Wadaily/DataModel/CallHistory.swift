//
//  CallHistory.swift
//  Wadaily
//
//  Created by 浦山秀斗 on 2025/11/28.
//

import Foundation

struct CallHistory: Identifiable {
    let id = UUID()
    let partnerName: String
    let partnerImageUrl: String?
    let backgroundImageUrl: String?
    let callDate: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: callDate)
    }
}
