//
//  Chat.swift
//  GraduationProject
//
//  Created by a mystic on 4/9/24.
//

import Foundation

struct Chat: Identifiable, Equatable {
    var id = UUID()
    var message: String
    var isSender: Bool
}
