//
//  TaskListObject.swift
//  kanban
//
//  Created by Oleksii Furman on 09/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct TaskListObject: Codable {
    let data: [TaskListDatas]
}

struct CreateTaskListObject: Codable {
    let data: TaskListType
}

struct TaskObject: Codable {
    let data: [TaskDatas]
}

struct CreateTaskObject: Codable {
    let data: TaskType
}

struct TaskType: Codable {
    let task: TaskDatas
}

struct TaskListType: Codable {
    let task_list: TaskListDatas
}

struct TaskListDatas: Codable {
    let id: Int
    let name: String
    let tasks: [TaskDatas]?
}

struct TaskDatas: Codable {
    let id: Int
    let content: String
    let is_finished: Bool
    let assigned_to: User
}
