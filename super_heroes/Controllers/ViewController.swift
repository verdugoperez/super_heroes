//
//  ViewController.swift
//  super_heroes
//
//  Created by Manuel Alejandro Verdugo Pérez on 04/06/20.
//  Copyright © 2020 Manuel Alejandro Verdugo Pérez. All rights reserved.
//

import UIKit
import SCLAlertView
import SDWebImage
import ChameleonFramework

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var heroesController = SuperHeroesController(id: 1)
    private var heroesControllerCV = SuperHeroesController(id: 2)
    
    private var dataTableView: [SuperHeroeModel] = []
    private var dataCollectionView: [SuperHeroeModel] = []

    private let alert = SCLAlertView()
    private var heroeSeleccionadoId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        
        heroesController.delegate = self
        heroesControllerCV.delegate = self
        
        searchTextField.delegate = self
        
        heroesController.getSuperHeroes()
        heroesControllerCV.getSuperHeroes(total: 5)
        
        updateUI()
    }
    
    func updateUI(){
        self.view.backgroundColor = GradientColor(.topToBottom, frame: self.view.layer.bounds , colors: [UIColor.red, UIColor.blue])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.heroeSegue {
           let destinationVC = segue.destination as! HeroeViewController
           
           destinationVC.heroeId = heroeSeleccionadoId
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.heroeCvCell, for: indexPath) as! CustomCollectionViewCell
        let currentCell = dataCollectionView[indexPath.row]
        let imageURL = URL(string: currentCell.imageUrl)
           
        cell.nombreLabel.text = currentCell.name
        cell.heroeImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .handleCookies, context: nil)
        cell.isHighlighted = true
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == dataCollectionView.count - 1 {
            heroesControllerCV.getMoreHeroes(total: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        heroeSeleccionadoId =  dataCollectionView[indexPath.row].id
        self.performSegue(withIdentifier: K.heroeSegue, sender: self)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var ancho: CGFloat = 0
        var alto: CGFloat = 0
        
        if UIDevice.current.orientation.isLandscape {
            ancho = 80.0
            alto = ancho
        } else {
            ancho = collectionView.bounds.width / 3
            alto = ancho
        }
        
        return CGSize(width: ancho, height: alto)
    }
}

extension ViewController: SuperHeroesControllerDelegate {
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

    func actualizaSuperHeroes(_ superHeroeController: SuperHeroesController, superHeroes: [SuperHeroeModel], id: Int) {
        if id == 1 {
            dataTableView = superHeroes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            dataCollectionView = superHeroes
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = dataTableView[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.heroeCell, for: indexPath) as! CustomTableViewCell
        let imageURL = URL(string: currentCell.imageUrl)
        
        cell.nombreLabel.text = currentCell.name
        cell.publisher.text = currentCell.publisher
        cell.heroeImageView?.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .handleCookies, context: nil)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let nombre = searchTextField.text!
        
        if indexPath.row == dataTableView.count - 1 && nombre == "" {
          heroesController.getMoreHeroes()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        heroeSeleccionadoId = dataTableView[indexPath.row].id
        self.performSegue(withIdentifier: K.heroeSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         let nombre = searchTextField.text!
        
         if nombre != "" {
            heroesController.getSuperHeroesPorNombre(nombre: nombre)
         } else {
            heroesController.resetNumeroPagina()
            heroesController.getSuperHeroes()
        }
     }
}
