//
//  ViewController.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 06/12/23.
//

import UIKit
import Alamofire

class AnimalsVC: UIViewController {

    @IBOutlet weak var animalTV: UITableView!
    //private var animalsList: [String] = ["Elephant", "Lion", "Fox", "Dog", "Shark", "Turtle", "Whale", "Penguin"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let favImage = UIImage(named: "heart-red")!
        let favBtn = UIBarButtonItem(image: favImage, style: .plain, target: self, action: #selector(favImageTapped))
        favBtn.tintColor = UIColor.red
        self.navigationItem.setRightBarButton(favBtn, animated: true)
        
        animalTV.register(UINib(nibName: "AnimalTVCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(AnimalTVCell.classForCoder()));
        
        animalTV.delegate = self
        animalTV.dataSource = self
        animalTV.clipsToBounds = false
        animalTV.allowsMultipleSelection = false
        
        //getAnimalsData()
    }
    
    @objc func favImageTapped()
    {
        let favoriteAnimalsVC = FavoritesAnimalsVC()
        favoriteAnimalsVC.title = "Favorite Animals"
        self.navigationController?.pushViewController(favoriteAnimalsVC, animated: true)
    }
}

// Calling APIs
extension AnimalsVC {
    func getAnimalsData() {
        let headers: HTTPHeaders = [
            "x-api-key": ninja_api_key,
        ]
        HttpRequest.requestGETURL(getAnimals, header: headers) { response in
            //print("response: \(response)")
            /*do {
                guard let result = try PersistentContainer.shared.context.fetch(Animals.fetchRequest()) as? [Animals] else {return}
                //self.animalsList = result
                self.animalTV.reloadData()
            } catch let error {
                debugPrint(error)
            }*/
            
        } failure: { error in
            print("error: \(error)")
        }
    }
}

extension AnimalsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalTV.dequeueReusableCell(withIdentifier: NSStringFromClass(AnimalTVCell.classForCoder())) as! AnimalTVCell
                
        // set the text from the data model
        let animalData = animalsList[indexPath.row]
        //cell.animalNameTxt?.text = animalData.name
        cell.animalNameTxt?.text = animalData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animalData = animalsList[indexPath.row]
        print("animalData: \(animalData)")
        let animalImageVC = AnimalImagesVC()
        animalImageVC.modalPresentationStyle = .fullScreen
        animalImageVC.animalName = animalData
        //animalsImageVC.title = "\(animalData.name) Images"
        animalImageVC.title = "\(animalData) Images"
        self.navigationController?.pushViewController(animalImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
