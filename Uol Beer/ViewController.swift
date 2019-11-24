//
//  ViewController.swift
//  Uol Beer
//
//  Created by Jaber Vieira Da Silva Shamali on 20/11/19.
//  Copyright © 2019 Jaber Vieira Da Silva Shamali. All rights reserved.
//

import UIKit
import CoreData
import Network

class ViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    final let url = URL(string: "https://api.punkapi.com/v2/beers/")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var beer = [Beer]()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    var imagem:[UIImage?] = []
    var looping = 0
    var index = 0
    var network: Bool = true
    
    
    @IBOutlet weak var tableBeer: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.network = true
                DispatchQueue.main.async {
                self.deleteAllRecords()
                }
                self.getJson()
                print("We're connected!")
            } else {
                if !UserDefaults.standard.bool(forKey: Keys.firstAcess) {
                      self.alertFirstAcessOffline()
                    }
                self.network = false
                print("No connection.")
            }
            print(path.isExpensive)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        looping += 1
        if network{
            return beer.count
        } else {
            if looping == 3{
                self.getData()
            }
        }
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
           
        } else {
            if !self.imagem.isEmpty{
                cell.imgBeer.image = self.imagem[indexPath.row]
            }
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor =  UIColor.orange.withAlphaComponent(0.7)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableBeer.indexPathForSelectedRow{
            let detailVC = segue.destination as! SecondViewController
            detailVC.id = beer[indexPath.row].id
            detailVC.name = beer[indexPath.row].name
            detailVC.descrip = beer[indexPath.row].description
            detailVC.tagline = beer[indexPath.row].tagline
            detailVC.abv = beer[indexPath.row].abv
            detailVC.ibu = beer[indexPath.row].ibu ?? 0.0
            if network{
                detailVC.img = beer[indexPath.row].image_url
            } else {
                detailVC.imgOffline = self.imagem[indexPath.row]
            }
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
                
                if self.network {
                    
                    self.saveData()
                }
                UserDefaults.standard.set(true, forKey: Keys.firstAcess)
            } catch{
                print("Não foi possível transformar")
            }
            
            }.resume()
    }
    
    func saveData(){
         while(index<=(beer.count - 1)){
        let entity = NSEntityDescription.entity(forEntityName: "Cervejas", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        

            
            newEntity.setValue(beer[index].id, forKey: "id")
            newEntity.setValue(beer[index].name, forKey: "nome")
            newEntity.setValue(beer[index].description, forKey: "descricao")
            newEntity.setValue(beer[index].tagline, forKey: "tagline")
            newEntity.setValue(beer[index].abv, forKey: "abv")
            newEntity.setValue(beer[index].ibu, forKey: "ibu")
            if let imageURL = URL(string: beer[index].image_url){
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                        self.imagem.append(image)
                        let img = image!.pngData()
                        newEntity.setValue(img, forKey: "img")
                    }
            }

            index += 1
            do{
                try context.save()
            } catch {
                print("Erro ao salvar")
            }
        }


    }
    
    func getData(){

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cervejas")
        request.returnsObjectsAsFaults = false

        do{
            let result = try! context.fetch(request)
            for data in result as! [NSManagedObject]{
                self.beer.append(Beer.init(id: data.value(forKey: "id") as! Int, name:  data.value(forKey: "nome") as! String, tagline:  data.value(forKey: "tagline") as! String, description:  data.value(forKey: "descricao") as! String, image_url:  data.value(forKey: "img") as? String ?? "", abv:  data.value(forKey: "abv") as! Double, ibu:  data.value(forKey: "ibu") as? Double))
                
                var img: UIImage?{
                    return UIImage(data: data.value(forKey: "img") as! Data)
                }
                self.imagem.append(img)

            }
        }
    }
    
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cervejas")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print ("Deletado com sucesso")
        } catch {
            print ("Delete falhou")
        }
    }
    
    
    func alertFirstAcessOffline(){
        let appAlert = UIAlertController(title: "Aviso", message: "Primeiro acesso necessita de conexão com a internet.", preferredStyle: .alert)
        
        appAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
        }))
        
        self.present(appAlert, animated: true)
    }
}

