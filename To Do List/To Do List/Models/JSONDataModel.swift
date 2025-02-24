//
//  JSONDataModel.swift
//  To Do List
//
//  Created by Alina Kazantseva on 2/20/25.
//

import Foundation

struct JSONDataModel: Codable {
    struct Task: Codable, Identifiable {
        let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
    }
    let todos: [Task]
    let total: Int
    let skip: Int
    let limit: Int
}
