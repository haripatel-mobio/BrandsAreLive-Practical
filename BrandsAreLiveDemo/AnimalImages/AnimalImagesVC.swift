//
//  AnimalImagesVC.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 08/12/23.
//

import UIKit
import Alamofire
import Kingfisher
import Lottie

class AnimalImagesVC: UIViewController {
    
    @IBOutlet weak var imagesTV: UITableView!
    var animalName: String?
    //var animalImages = [String]()
    var animalImages = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "\(animals.name ?? "Animal") Images"
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = backButton
//        self.navigationItem.backBarButtonItem?.title = " "
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        imagesTV.register(UINib(nibName: "AnimalImagesCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(AnimalImagesCell.classForCoder()));
        
        imagesTV.delegate = self
        imagesTV.dataSource = self
        
        //animationView()
        
        getAnimalsData()
    }
}

// Calling APIs
extension AnimalImagesVC {
    /*func animationView() {
        // 2. Start LottieAnimationView with animation name (without extension)
        //likeAnimationView = .init(name: "like")
        //likeAnimationView!.frame = view.bounds
        
        // 3. Set animation content mode
        likeAnimationView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        likeAnimationView!.loopMode = .loop

        // 5. Adjust animation speed
        likeAnimationView!.animationSpeed = 0.5
        
        // 6. Play animation
        likeAnimationView.play()
    }*/
    
    func getAnimalsData() {
        if (animalName == nil || animalName == "") {
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": pexels_api_key,
        ]
        let apiURL = getAnimalImages.replacingOccurrences(of: "[animal_name]", with: animalName!)
        HttpRequest.requestGETURL(apiURL, header: headers) { [self] response in
            guard let responseData = response else {
                return
            }
            guard let photos = responseData["photos"] as? [[String: Any]] else { return }
            for photoData in photos {
                animalImages.append(photoData)
                /*let src = photoData["src"] as? [String: Any]
                if (src != nil) {
                    let imageURL = src?["medium"] as? String
                    animalImages.append(imageURL!)
                }*/
            }
            //print("animalImages: \(animalImages)")
            imagesTV.reloadData()
        } failure: { error in
            print("error: \(error)")
        }
    }
}

extension AnimalImagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return animalImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.imagesTV.dequeueReusableCell(withIdentifier: NSStringFromClass(AnimalImagesCell.classForCoder())) as! AnimalImagesCell
        //let imageURL = animalImages[indexPath.row]
        //let url = imageURL
        let imageData = animalImages[indexPath.section]
        let src = imageData["src"] as! [String: Any]
        let url = src["medium"] as! String
        
        DispatchQueue.main.async {
            cell.animalImageView?.kf.setImage(with: URL(string: url))
            cell.animalImageView?.layoutIfNeeded()
            cell.layoutIfNeeded()
        }
        
        cell.likeView.isHidden = false
        cell.likeImage.image = UIImage(named: "heart")
        do {
            if let result = try PersistentContainer.shared.context.fetch(FavoritesImages.fetchRequest()) as? [FavoritesImages] {
                for favImageData in result {
                    if (favImageData.image_id == imageData["id"] as! Int64) {
                        //print("favImageData.image_id: \(favImageData.image_id)")
                        //print("imageData[\"id\"]: \(imageData["id"] ?? "")")
                        cell.likeImage.image = UIImage(named: "heart-red")
                        break
                    }
                }
            }
        } catch let error {
            debugPrint(error)
        }
        
        cell.likeView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeViewTapped(tapGestureRecognizer:)))
        cell.likeView.tag = indexPath.section
        cell.likeView.addGestureRecognizer(tapGestureRecognizer)
        
        cell.isUserInteractionEnabled = true
        let tapLikeAnimationViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapLikeAnimationViewGestureRecognizer.numberOfTapsRequired = 2
        cell.tag = indexPath.section
        cell.addGestureRecognizer(tapLikeAnimationViewGestureRecognizer)
        
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedView = tapGestureRecognizer.view
        let index = tappedView?.tag
        let indexPath = IndexPath(row: 0, section: index!)
        
        let cell = imagesTV.cellForRow(at: indexPath) as? AnimalImagesCell
        cell?.likeAnimationView.isHidden = false
        cell?.likeAnimationView.stop()
        cell?.likeAnimationView.play(completion: { completed in
            cell?.likeAnimationView.isHidden = true
        })
        
        let photoData = self.animalImages[index!]
        handleLike(photoData: photoData, justLike: true)
    }
    
    @objc func likeViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedView = tapGestureRecognizer.view
        let index = tappedView?.tag
        let photoData = self.animalImages[index!]
        print("imageData: \(photoData)")
        
        handleLike(photoData: photoData)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let photoData = animalImages[indexPath.section]
        let imageWidth = photoData["width"] as? CGFloat
        let imageHeight = photoData["height"] as? CGFloat
        let cellHeight = (imageHeight! * screenWidth) / imageWidth!
        //print("cellHeight: \(cellHeight)")
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            return nil
        }
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func handleLike(photoData: [String: Any], justLike: Bool? = false) {
        do {
            guard let result = try PersistentContainer.shared.context.fetch(FavoritesImages.fetchRequest()) as? [FavoritesImages] else { return }
        
            var isInsertNew = true
            for favImageData in result {
                //print("tapped.favImageData.image_id: \(favImageData.image_id)")
                //print("tapped.imageData[\"id\"]: \(imageData["id"])")
                if (favImageData.image_id == photoData["id"] as! Int64) {
                    isInsertNew = false
                    if (!justLike!) {
                        PersistentContainer.shared.context.delete(favImageData)
                        imagesTV.reloadData()
                    }
                    break
                }
            }
            if (isInsertNew) {
                let context = PersistentContainer.shared.context
                
                let entity = FavoritesImages(context: context)
                entity.animal_name = animalName
                entity.image_id = photoData["id"] as! Int64
                let src = photoData["src"] as! [String: Any]
                entity.image_url = src["medium"] as? String
                entity.width = photoData["width"] as! Int64
                entity.height = photoData["height"] as! Int64
                
                do {
                    try context.save()
                    imagesTV.reloadData()
                } catch {
                    print("Failed to save data to Core Data: \(error)")
                }
            } else {
                
            }
        } catch let error {
            debugPrint(error)
        }
    }
}
