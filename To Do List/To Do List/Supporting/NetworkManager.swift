//
//  NetworkManager.swift
//  To Do List
//
//  Created by Alina Kazantseva on 2/20/25.
//

import Foundation

class NetworkManager {
    func fetchAllTasks(_ completionHandler: @escaping ([JSONDataModel.Task]) -> ()) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data, error == nil else { return }
            if let tasks = try? JSONDecoder().decode(JSONDataModel.self, from: data) {
                completionHandler(tasks.todos)
            }
        }.resume()
    }
}
