//
//  FormDisplay.swift
//  MedProj
//
//  Created by William Flores on 2/12/17.
//  Copyright © 2017 Michael McKenna. All rights reserved.
//

import UIKit

class FormDisplay: UICollectionViewController {
    
    // MARK: Properties
    
//    var form: Form?
    var isEdit = false
    
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        isEdit = !isEdit
        sender.title = (isEdit) ? "Edit" : "Submit"
        collectionView?.reloadData()
    }
    
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - collection view data source

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserFormDisplayCell else {
            return UICollectionViewCell()
        }
        
//        cell.configure(form: form, isEdit: isEdit)
        return cell
    }
    
}
