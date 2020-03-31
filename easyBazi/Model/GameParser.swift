//
//  Game.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/27/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import Foundation
struct GameObject: Decodable{
    var status : Int
    var message:String
    var data:DataObject
}
struct DataObject: Decodable{
    var current_page:Int?
    var data:[Game]
    var next_page_url:String?
}

struct Game:Decodable{
    var id:Int!
    var price:Int!
//    var is_pending:String?
    var game_info:gameInfo
    var region:String
    var count:Int
}

struct gameInfo:Decodable{
    var id:Int
     var name:String?
     var console_type_id:Int?
     var age_class:Int
     var created_at:String!
     var production_date:String!
     var description:String?
     var company_name:String?
     var photos:[photo] = []
     var videos: [video] = []
     var genres:[genre] = []
     var console:console!
}
//struct Post:Decodable {
//    var id:Int!
//}

struct photo:Decodable {
    var type:String?
    var url:String!
}
struct video:Decodable {
    var url:String!
}
struct genre:Decodable {
    var name:String!
}
struct console:Decodable {
    var name:String
}
struct rentTypes:Decodable  {
    var status:Int!
    var message:String?
    var data:[rentType] = []
    
}
struct addressObject:Decodable{
    var status:Int!
    var message:String?
    var data:address
}

struct address:Decodable{
    var id:Int!
}

