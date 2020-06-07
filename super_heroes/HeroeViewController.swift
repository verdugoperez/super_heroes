//
//  HeroeViewController.swift
//  super_heroes
//
//  Created by Manuel Alejandro Verdugo Pérez on 05/06/20.
//  Copyright © 2020 Manuel Alejandro Verdugo Pérez. All rights reserved.
//

import UIKit
import SDWebImage
import SCLAlertView

class HeroeViewController: UIViewController {

 
    @IBOutlet weak var heroeImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var publisher: UILabel!
    private let alert = SCLAlertView()
    var heroeId: String?
    private var heroesController = SuperHeroesController(id: 1)
    //private var heroeDetalle: SuperHeroeModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        heroesController.delegate = self
        
        heroeImageView.makeRounded()
        
        if let safeId = heroeId {
            heroesController.getSuperHeroePorId(id: Int(safeId)!)
        }
        
       
        //nombreLabel.text = heroeId
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HeroeViewController: SuperHeroesControllerDelegate {
    func actualizaSuperHeroes(_ superHeroeController: SuperHeroesController, superHeroes: [SuperHeroeModel], id: Int) {
      
        if superHeroes.count > 0 {
            let superHeroe = superHeroes[0]
            let imageURL = URL(string: superHeroe.imageUrl)
           
            DispatchQueue.main.async {
                self.title = superHeroe.fullName
                self.nombreLabel.text = "\(String(describing: superHeroe.race!)) - \(String(describing: superHeroe.gender!))"
                self.publisher.text = superHeroe.publisher
                 //cell.nombreLabel.text = currentCell.name
                self.heroeImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .handleCookies, context: nil)
            }
            
        }
    }
    
    func alertSuperHeroes(tipo: SCLAlertViewStyle, titulo: String, subTitulo: String, color: UInt) {
                DispatchQueue.main.async {
                         self.alert.showTitle(
                             titulo,
                             subTitle: subTitulo,
                             timeout: .none,
                             completeText: "Ok",
                             style: tipo,
                             colorStyle: color,
                             colorTextButton: 0xFFFFFF
                         )
                     }
    }
    
   
    
//    func alertSuperHeroes(tipo: SCLAlertViewStyle, titulo: String, subTitulo: String, color: UInt) {
//        DispatchQueue.main.async {
//                 self.alert.showTitle(
//                     titulo,
//                     subTitle: subTitulo,
//                     timeout: .none,
//                     completeText: "Ok",
//                     style: tipo,
//                     colorStyle: color,
//                     colorTextButton: 0xFFFFFF
//                 )
//             }
//    }
    
    
}
