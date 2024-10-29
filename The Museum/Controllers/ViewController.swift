//
//  ViewController.swift
//  The Museum
//
//  Created by Muhamad Septian Nugraha on 26/10/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tapToDepartement: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Mengaktifkan user interaction untuk UIImageView
        tapToDepartement.isUserInteractionEnabled = true
       
        // Membuat tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapToDepartement.addGestureRecognizer(tapGesture)
   }
    
    // Menyembunyikan nav bar
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

   @objc func imageTapped() {
       
       performSegue(withIdentifier: "goToDepartement", sender: self)
   }

}

