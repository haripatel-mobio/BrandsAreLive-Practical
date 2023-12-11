//
//  FilterVC.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 11/12/23.
//

import UIKit

protocol FilterVCDelegate : AnyObject {
    func passingData(filterList: [String])
}

class FilterVC: UIViewController {

    @IBOutlet weak var animalTV: UITableView!
    @IBOutlet weak var clearAllBtn: UIButton!
    
    weak var delegate: FilterVCDelegate? = nil
    var selectionList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveImage = UIImage(named: "save")!
        let saveBtn = UIBarButtonItem(image: saveImage, style: .plain, target: self, action: #selector(saveImageTapped))
        saveBtn.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
        
        let closeImage = UIImage(named: "close")!
        let closeBtn = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeImageTapped))
        closeBtn.tintColor = UIColor.black
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        
        if (selectionList.count != 0) {
            clearAllBtn.isHidden = false
        } else {
            clearAllBtn.isHidden = true
        }
        
        // Do any additional setup after loading the view.
        animalTV.register(UINib(nibName: "AnimalTVCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(AnimalTVCell.classForCoder()));
        
        animalTV.delegate = self
        animalTV.dataSource = self
        animalTV.clipsToBounds = false
    }
    
    @IBAction func clearAllFilterBtnTapHandler(_ sender: Any) {
        selectionList.removeAll()
        delegate?.passingData(filterList: selectionList)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveImageTapped()
    {
        delegate?.passingData(filterList: selectionList)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeImageTapped()
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.animalTV.dequeueReusableCell(withIdentifier: NSStringFromClass(AnimalTVCell.classForCoder())) as! AnimalTVCell
                
        // set the text from the data model
        let animalData = animalsList[indexPath.row]
        //cell.animalNameTxt?.text = animalData.name
        cell.animalNameTxt?.text = animalData
        
        cell.accessoryType = .none
        for selectedName in selectionList {
            if (selectedName.compare(animalData) == .orderedSame) {
                cell.accessoryType = .checkmark
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animalData = animalsList[indexPath.row]
        
        var isAddNew = true
        for selectedName in selectionList {
            if (selectedName.compare(animalData) == .orderedSame) {
                isAddNew = false
                break
            }
        }
        
        if (isAddNew) {
            selectionList.append(animalData)
        } else {
            if let index = selectionList.firstIndex(of: animalData) {
                selectionList.remove(at: index)
            }
        }
        
        if (selectionList.count != 0) {
            clearAllBtn.isHidden = false
        } else {
            clearAllBtn.isHidden = true
        }
        
        animalTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
