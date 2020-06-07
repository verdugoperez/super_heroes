//
//  SuperHeroeModel.swift
//  super_heroes
//
//  Created by Manuel Alejandro Verdugo Pérez on 04/06/20.
//  Copyright © 2020 Manuel Alejandro Verdugo Pérez. All rights reserved.
//

import Foundation

// MARK: - SuperHeroe
struct SuperHeroeModel: Codable {
   let id, name: String
   let fullName: String?
   let publisher: String
   let gender: String?
   let race: String?
   let powerstats: [Double]?
   let imageUrl: String
}
