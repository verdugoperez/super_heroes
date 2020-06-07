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
import Charts

class HeroeViewController: UIViewController {

 
    @IBOutlet weak var radarChartView: RadarChartView!
    @IBOutlet weak var heroeImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var publisher: UILabel!
    
    private var heroesController = SuperHeroesController(id: 1)
    private let alert = SCLAlertView()
    private let powers = RadarChartDataSet()
    
    var heroeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        heroesController.delegate = self
        
        heroeImageView.makeRounded()
        
        if let safeId = heroeId {
            heroesController.getSuperHeroePorId(id: Int(safeId)!)
        }
    }
    
    func updateDataChart(){
        let data = RadarChartData(dataSets: [powers])
        
        powers.lineWidth = 2

        let redColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 1)
        let redFillColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 0.6)
        powers.colors = [redColor]
        powers.fillColor = redFillColor
        powers.drawFilledEnabled = true
        
        radarChartView.webLineWidth = 1.5
        radarChartView.innerWebLineWidth = 1.5
        radarChartView.webColor = .lightGray
        radarChartView.innerWebColor = .lightGray

        let xAxis = radarChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 10
        xAxis.yOffset = 10
        xAxis.valueFormatter = XAxisFormatter()

        let yAxis = radarChartView.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.labelCount = 6
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        
        radarChartView.rotationEnabled = false
        radarChartView.legend.enabled = false

        powers.valueFormatter = DataSetValueFormatter()
        
        radarChartView.data = data
    }

}


extension HeroeViewController: SuperHeroesControllerDelegate {
    func actualizaSuperHeroes(_ superHeroeController: SuperHeroesController, superHeroes: [SuperHeroeModel], id: Int) {
      
        if superHeroes.count > 0 {
            let superHeroe = superHeroes[0]
            let imageURL = URL(string: superHeroe.imageUrl)
    
            if let safePowers = superHeroe.powerstats {
                for power in safePowers {
                    powers.append(RadarChartDataEntry(value: power))
                }
            }
            
            DispatchQueue.main.async {
               self.title = superHeroe.fullName
               self.nombreLabel.text = "\(String(describing: superHeroe.race!)) - \(String(describing: superHeroe.gender!))"
               self.publisher.text = superHeroe.publisher
               self.heroeImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .handleCookies, context: nil)
               self.updateDataChart()
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
}
