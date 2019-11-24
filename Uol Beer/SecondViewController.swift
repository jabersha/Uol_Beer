//
//  SecondViewController.swift
//  Uol Beer
//
//  Created by Jaber Vieira Da Silva Shamali on 21/11/19.
//  Copyright © 2019 Jaber Vieira Da Silva Shamali. All rights reserved.
//

import UIKit



class SecondViewController: UIViewController {

    @IBOutlet weak var imgBeer: UIImageView!
    @IBOutlet weak var descriBeer: UILabel!
    @IBOutlet weak var abvBeer: UILabel!
    @IBOutlet weak var taglineBeer: UILabel!
    @IBOutlet weak var nameBeer: UILabel!
    @IBOutlet weak var ibuBeer: UILabel!
    
    
    var id = Int()
    var name = String()
    var descrip = String()
    var tagline = String()
    var abv = Double()
    var ibu = Double()
    var img = String()
    var imgOffline: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameBeer.text = name
        descriBeer.text = "\"\(descrip)\""
        taglineBeer.text = tagline
        abvBeer.text = "Teor Alcóolico \n\(abv)%"
        ibuBeer.text = "Escala de amargor \n\(ibu)"
        
        if let imageURL = URL(string: img){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imgBeer.image = image
                    }
                }
            }
            
        } else {
            if self.imgOffline != nil {
                self.imgBeer.image = imgOffline
            }
        }
        
        
    }

    
}
