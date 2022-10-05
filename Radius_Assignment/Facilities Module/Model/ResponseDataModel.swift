//
//  ResponseDataModel.swift
//  Radius_Assignment
//
//  Created by Adwait Barkale on 02/08/22.
//

import Foundation

/// This Struct will be used to parse Response Received from Api
struct ResponseDataModel : Codable {
    var facilities : [Facilities]?
    let exclusions : [[Exclusions]]?

    enum CodingKeys: String, CodingKey {

        case facilities = "facilities"
        case exclusions = "exclusions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        facilities = try values.decodeIfPresent([Facilities].self, forKey: .facilities)
        exclusions = try values.decodeIfPresent([[Exclusions]].self, forKey: .exclusions)
    }

}

/// This Struct will be used to parse Response Received from Api
struct Facilities : Codable {
    let facility_id : String?
    let name : String?
    var options : [Options]?
    var isSelectionDone = false

    enum CodingKeys: String, CodingKey {

        case facility_id = "facility_id"
        case name = "name"
        case options = "options"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        facility_id = try values.decodeIfPresent(String.self, forKey: .facility_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        options = try values.decodeIfPresent([Options].self, forKey: .options)
    }

}

/// This Struct will be used to parse Response Received from Api
struct Options : Codable {
    let name : String?
    let icon : String?
    let id : String?
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {

        case name = "name"
        case icon = "icon"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

/// This Struct will be used to parse Response Received from Api
struct Exclusions : Codable {
    let facility_id : String?
    let options_id : String?

    enum CodingKeys: String, CodingKey {

        case facility_id = "facility_id"
        case options_id = "options_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        facility_id = try values.decodeIfPresent(String.self, forKey: .facility_id)
        options_id = try values.decodeIfPresent(String.self, forKey: .options_id)
    }

}
