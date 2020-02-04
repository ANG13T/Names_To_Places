//
//  ViewController.swift
//  Names_To_Places
//
//  Created by Angelina Tsuboi on 2/2/20.
//  Copyright © 2020 Angelina Tsuboi. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var places = [Place]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlace))
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Place", for: indexPath) as? PlaceCell else {
            fatalError("Unable to deque place cell")
        }
        
        let place = places[indexPath.item]
        
        cell.name.text = place.name
        let path = getDocumentsDirectory().appendingPathComponent(place.image)
        cell.image.image = UIImage(contentsOfFile: path.path)
        
        cell.image.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.image.layer.borderWidth = 2
        cell.image.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addPlace(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.sourceType = .photoLibrary
        guard let image = info[.editedImage] as? UIImage else {return} //gets the selected image
        let imageName = UUID().uuidString //gives image a unique id
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName) //appends that id to the end of the users document directory
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){ //makes jpeg data of image
            try? jpegData.write(to: imagePath) //writes that jpeg data to the image path
        }
        
        let place = Place(name: "Unknown", image: imageName)
        places.append(place)
        collectionView.reloadData()
        
        dismiss(animated: true) //dismisses the picker
        
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) //gets document directory for current user
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let ac = UIAlertController(title: "Rename or Delete?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { action in
            self.renamePlace(place: place)
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .default){ action in
            self.places.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        })
        
       present(ac, animated: true)
    }
    
    func renamePlace(place: Place){
    let ac = UIAlertController(title: "Rename Place", message: nil, preferredStyle: .alert)
           ac.addTextField()
           ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
               guard let newName = ac?.textFields?[0].text else {return}
               place.name = newName
               self?.collectionView.reloadData()
           })
           
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
           present(ac, animated: true)
    }
    

}

