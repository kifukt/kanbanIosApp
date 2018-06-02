//
//  GroupObject.swift
//  kanban
//
//  Created by Oleksii Furman on 02/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct GroupDatas: Codable {
    let id: Int
    let name: String
    let leader_id: Int
}

//GetGroups
struct GroupsObject: Codable {
    let data: [GroupDatas]
}
//CreateGroup
struct CreateGroupObject: Codable {
    let data: UserGroups
}

struct UserGroups: Codable {
    let group: GroupDatas
}
//Change Leader
struct ChangeLeaderObject: Codable {
    let data: ChangeLeaderGroup
}

struct ChangeLeaderGroup: Codable {
    let group: GroupDatas
}
//Add user to group, Show Group, Remove User from Group
struct GroupDataObject: Codable {
    var data: GroupObject
}

struct GroupObject: Codable {
    var group: UserDataGroup
}

struct UserDataGroup: Codable {
    let id: Int
    var name: String
    var members: [Members]
    var leader: Members?
}

struct Members: Codable {
    let id: Int
    let email: String
}



