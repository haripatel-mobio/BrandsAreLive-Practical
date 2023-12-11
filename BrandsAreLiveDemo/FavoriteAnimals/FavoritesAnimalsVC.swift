//
//  FavoritesAnimalsVC.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 08/12/23.
//

import UIKit

class FavoritesAnimalsVC: UIViewController {

    @IBOutlet weak var favoritesTV: UITableView!
    var favoriteAnimalList = [FavoritesImages]()
    var favoriteAnimalFilterList = [FavoritesImages]()
    var selectionList = [String]()
    @IBOutlet weak var noDataFoundTxt: UILabel!
    let filterBtn = BadgedButtonItem(with: UIImage(named: "filter"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationItem()
        
        do {
            guard let result = try PersistentContainer.shared.context.fetch(FavoritesImages.fetchRequest()) as? [FavoritesImages] else { return }
        
            favoriteAnimalList = result
        } catch let error {
            debugPrint(error)
        }
        
        checkListEmpty()
        
        favoritesTV.register(UINib(nibName: "AnimalImagesCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(AnimalImagesCell.classForCoder()));
        
        favoritesTV.delegate = self
        favoritesTV.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClearAllTapHandler(_ sender: Any) {
        
    }
    
    func customNavigationItem() {
        filterBtn.tapAction = {
            self.filterImageTapped()
        }
        filterBtn.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(filterBtn, animated: true)
    }
    
    func checkListEmpty() {
        filterBtn.setBadge(with: selectionList.count)
        if (selectionList.count != 0) {
            if (favoriteAnimalFilterList.count == 0) {
                noDataFoundTxt.isHidden = false
                favoritesTV.isHidden = true
            } else {
                noDataFoundTxt.isHidden = true
                favoritesTV.isHidden = false
            }
        } else {
            if (favoriteAnimalList.count == 0) {
                noDataFoundTxt.isHidden = false
                favoritesTV.isHidden = true
            } else {
                noDataFoundTxt.isHidden = true
                favoritesTV.isHidden = false
            }
        }
    }
    
    @objc func filterImageTapped()
    {
        let filterVC = FilterVC()
        filterVC.modalPresentationStyle = .currentContext
        filterVC.title = "Filter"
        filterVC.selectionList = selectionList
        filterVC.delegate = self
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
}

extension FavoritesAnimalsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (selectionList.count != 0) {
            return favoriteAnimalFilterList.count
        } else {
            return favoriteAnimalList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favoritesTV.dequeueReusableCell(withIdentifier: NSStringFromClass(AnimalImagesCell.classForCoder())) as! AnimalImagesCell
        //let imageURL = animalImages[indexPath.row]
        //let url = imageURL
        var photoData = FavoritesImages()
        if (selectionList.count != 0) {
            photoData = favoriteAnimalFilterList[indexPath.section]
        } else {
            photoData = favoriteAnimalList[indexPath.section]
        }
        
        cell.animalNameView.isHidden = false
        cell.animalNameTxt.text = photoData.animal_name
        
        let url = photoData.image_url
        DispatchQueue.main.async {
            cell.animalImageView?.kf.setImage(with: URL(string: url!))
            cell.animalImageView?.layoutIfNeeded()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        var photoData = FavoritesImages()
        if (selectionList.count != 0) {
            photoData = favoriteAnimalFilterList[indexPath.section]
        } else {
            photoData = favoriteAnimalList[indexPath.section]
        }
        let imageWidth = photoData.width
        let imageHeight = photoData.height
        let cellHeight = (imageHeight * Int64(screenWidth)) / imageWidth
        //print("cellHeight: \(cellHeight)")
        return CGFloat(cellHeight)
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
}

extension FavoritesAnimalsVC: FilterVCDelegate {
    func passingData(filterList: [String]) {
        selectionList = filterList
        favoriteAnimalFilterList = favoriteAnimalList.filter({ favoriteData in
            for animalName in filterList {
                if (animalName.compare(favoriteData.animal_name!) == .orderedSame) {
                    return true
                }
            }
            return false
        })
        //print("favoriteAnimalFilterList: \(favoriteAnimalFilterList)")
        checkListEmpty()
        favoritesTV.reloadData()
    }
}
