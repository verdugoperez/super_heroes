//
//  SuperHeroesController.swift
//  super_heroes
//
//  Created by Manuel Alejandro Verdugo Pérez on 04/06/20.
//  Copyright © 2020 Manuel Alejandro Verdugo Pérez. All rights reserved.
//

import Foundation
import Alamofire
import SCLAlertView

protocol SuperHeroesControllerDelegate {
    func actualizaSuperHeroes(_ superHeroeController: SuperHeroesController, superHeroes: [SuperHeroeModel], id: Int)
    func alertSuperHeroes(tipo: SCLAlertViewStyle, titulo: String, subTitulo: String, color: UInt)
}

class SuperHeroesController {
    init(id: Int) {
        self.id = id
    }
    
    private var id = 0
    private let superHeroesURL = "https://superheroapi.com/api/10156112965520834/"
    private var pagina = 0
    var delegate: SuperHeroesControllerDelegate?
    private let group = DispatchGroup()
    private var listadoHeroes: [SuperHeroeModel] = []
    
    func getSuperHeroes(total:Int = 10) {
        let idsPorPagina =  Array(1...total).map({$0 + (pagina * total)})
       
         for id in idsPorPagina {
             let urlString = "\(superHeroesURL)\(id)"
             self.group.enter()
    
            AF.request(urlString).responseJSON { (response) in
               switch response.result {
                  case .success(let value):
                      if let JSON = value as? [String: Any] {
                         let id = JSON["id"] as! String
                         let name = JSON["name"] as! String
                         let image = JSON["image"] as! [String: Any]
                         let imageUrl = image["url"] as! String
                         let biography = JSON["biography"] as! [String: Any]
                         let publisher = biography["publisher"] as! String
                        
                        let superHeroe = SuperHeroeModel(id: id, name: name, fullName: nil, publisher: publisher, gender: nil, race: nil, powerstats: nil, imageUrl: imageUrl)

                         self.listadoHeroes.append(superHeroe)
                         self.group.leave()
                   }
                  case .failure(_):
                     self.delegate?.alertSuperHeroes(tipo: .warning, titulo: "Disculpa las molestias 🤖", subTitulo: "Estamos trabajando para regresar!", color: 0xFF0000)
                  }
             }
         }
        
        group.notify(queue: .main) {
            self.delegate?.actualizaSuperHeroes(self, superHeroes: self.listadoHeroes, id: self.id)
        }
    }
    
    func getMoreHeroes(total:Int = 10){
        pagina += 1
        getSuperHeroes(total: total)
    }
    
    func getSuperHeroePorId(id: Int)  {
        let urlString = "\(superHeroesURL)\(id)"
       
        AF.request(urlString).responseJSON { (response) in
          switch response.result {
             case .success(let value):
                 if let JSON = value as? [String: Any] {
                    let id = JSON["id"] as! String
                    let name = JSON["name"] as! String
                    let image = JSON["image"] as! [String: Any]
                    let imageUrl = image["url"] as! String
                    let biography = JSON["biography"] as! [String: Any]
                    let fullName = biography["full-name"] as! String
                    let publisher = biography["publisher"] as! String
                    let appearance = JSON["appearance"] as! [String: Any]
                    let gender = appearance["gender"] as! String != "null" ? appearance["gender"] as! String : "Desconocido"
                    let race = appearance["race"] as! String != "null" ? appearance["race"] as! String : "Desconocido"  
                    
                    let powers = JSON["powerstats"] as! [String: Any]
                    
                    let intelligence = Double(powers["intelligence"] != nil ? powers["intelligence"] as! String : "0.0")!
                    let strength = Double(powers["strength"] != nil ? powers["strength"] as! String : "0.0")!
                    let speed = Double(powers["speed"] != nil ? powers["speed"] as! String : "0.0")!
                    let durability = Double(powers["durability"] != nil ? powers["durability"] as! String : "0.0")!
                    let power = Double(powers["power"] != nil ? powers["power"] as! String : "0.0")!
                    let combat =  Double(powers["combat"] != nil ? powers["combat"] as! String : "0.0")!
                    
                    var powerstats = [Double]()
                    
                    powerstats.append(intelligence)
                    powerstats.append(strength)
                    powerstats.append(speed)
                    powerstats.append(durability)
                    powerstats.append(power)
                    powerstats.append(combat)
                    
                    let superHeroe = SuperHeroeModel(id: id, name: name, fullName: fullName, publisher: publisher, gender: gender, race: race, powerstats: powerstats, imageUrl: imageUrl)

                    self.listadoHeroes.append(superHeroe)
                     self.delegate?.actualizaSuperHeroes(self, superHeroes: self.listadoHeroes, id: self.id)
                   // self.group.leave()
              }
             case .failure(_):
                self.delegate?.alertSuperHeroes(tipo: .warning, titulo: "Disculpa las molestias 🤖", subTitulo: "Estamos trabajando para regresar!", color: 0xFF0000)
             }
        }
    }
        
    func getSuperHeroesPorNombre(nombre: String){
         let urlString = "\(superHeroesURL)search/\(nombre)"

         AF.request(urlString).responseJSON { (response) in
          
            switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                      
                        let heroes = JSON["results"] as? Array<[String: Any]> ?? []
                      
                        self.listadoHeroes = []
                    
                        for heroe in heroes {
                            let id = heroe["id"] as! String
                            let name = heroe["name"] as! String
                            let image = heroe["image"] as! [String: Any]
                            let imageUrl = image["url"] as! String
                            let biography = heroe["biography"] as! [String: Any]
                            let publisher = biography["publisher"] as! String
                            
                            let superHeroe = SuperHeroeModel(id: id, name: name, fullName: nil, publisher: publisher, gender: nil, race: nil, powerstats: nil, imageUrl: imageUrl)
                           
                            self.listadoHeroes.append(superHeroe)
                        }
                        
                        self.delegate?.actualizaSuperHeroes(self, superHeroes: self.listadoHeroes, id: self.id)
                    }

                case .failure(_):
                    self.delegate?.alertSuperHeroes(tipo: .warning, titulo: "Disculpa las molestias 🤖", subTitulo: "Estamos trabajando para regresar!", color: 0xFFB816)
            }
        }
    }
    
    func getNumeroPagina() -> Int {
        return pagina
    }
    
    func resetNumeroPagina(){
        pagina = 1
    }
}

