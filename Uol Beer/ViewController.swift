//
//  ViewController.swift
//  Uol Beer
//
//  Created by Jaber Vieira Da Silva Shamali on 20/11/19.
//  Copyright © 2019 Jaber Vieira Da Silva Shamali. All rights reserved.
//

import UIKit
import Alamofire

class ViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    final let url = URL(string: "https://api.punkapi.com/v2/beers/")
    private var beer = [Beer]()
    var idBeer = 0
    @IBOutlet weak var tableBeer: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getJson()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cerveja") as! BeerCell
        
        cell.nameBeer.text = beer[indexPath.row].name
        cell.teorBeer.text = "Teor Alcóolico \(beer[indexPath.row].abv)%"

        
        if let imageURL = URL(string: beer[indexPath.row].image_url){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgBeer.image = image
                    }
                }
            }
           
        }
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableBeer.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let detailVC = segue.destination as! SecondViewController
            detailVC.id = selectedRow
            detailVC.name = beer[indexPath.row].name
            detailVC.descrip = beer[indexPath.row].description
            detailVC.tagline = beer[indexPath.row].tagline
            detailVC.abv = beer[indexPath.row].abv
            detailVC.ibu = beer[indexPath.row].ibu ?? 0.0
            detailVC.img = beer[indexPath.row].image_url
        }
    }
    
    func getJson(){
        guard let listUrl = url  else {return}
        URLSession.shared.dataTask(with: listUrl) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Error")
                return
            }
            do
            {
                let decoder = JSONDecoder()
                let beers = try decoder.decode([Beer].self, from: data)
                self.beer = beers
                DispatchQueue.main.async {
                    self.tableBeer.reloadData()
                }
                
                
            } catch{
                print("Não foi possível transformar")
            }
            
            print("Ok")
            }.resume()
    }
}

