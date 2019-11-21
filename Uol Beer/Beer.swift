//
//  Beer.swift
//  Uol Beer
//
//  Created by Jaber Vieira Da Silva Shamali on 20/11/19.
//  Copyright © 2019 Jaber Vieira Da Silva Shamali. All rights reserved.
//

import UIKit

class Beers:Codable{
    let beer: [Beer]
    
    init(beer: [Beer]) {
        self.beer = beer
    }
}


class Beer:Codable{
    
    let id : Int
    let name : String
    let tagline: String
    let description: String
    let image_url : String
    let abv: Double
    var ibu: Double?
   
    init(id : Int, name : String,tagline: String,description: String, image_url : String,abv: Double, ibu: Double?){
        self.id = id
        self.name = name
        self.tagline = tagline
        self.description = description
        self.image_url = image_url
        self.abv = abv
        self.ibu = ibu
    }
}
