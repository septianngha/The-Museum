//
//  DepartementViewController.swift
//  The Museum
//
//  Created by Muhamad Septian Nugraha on 26/10/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class DepartementViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var departementPicker: UIPickerView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var homeBackground: UIImageView!
    
    let API_URL = "https://collectionapi.metmuseum.org/public/collection/v1/departments"
    
    var departments: [Departement] = []
    var id: Int = 0
    var titleNav: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openingScreen()
        getDataAPI()
        
        departementPicker.delegate = self
        departementPicker.dataSource = self
    }
    
    
    // MARK: - Setting Navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        guard (navigationController?.navigationBar) != nil
            else { fatalError("Navigation controller does not exist.")}
        
        // Membuat instance UINavigationBarAppearance
        let appearance = UINavigationBarAppearance()

        // Mengatur warna background
        appearance.backgroundColor = UIColor.black

        // Mengatur warna untuk elemen di bar (title, tombol)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        // Menentukan appearance untuk scroll edge dan standard appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // Mengubah warna item bar (back button, dll)
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    // MARK: - API for Get Departement Data
    func getDataAPI() {
        
        AF.request(API_URL).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let departmentsArray = json["departments"] as? [[String: Any]] {
                    self.departments = departmentsArray.compactMap { dict in
                        guard let id = dict["departmentId"] as? Int,
                              let name = dict["displayName"] as? String else {
                            return Departement(departmentId: 0, displayName: "") }
                        return Departement(departmentId: id, displayName: name)
                    }
                    
                    // Reload picker view setelah data berhasil dimuat
                    self.departementPicker.reloadAllComponents()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
        
    }
    
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departments.count
    }
    
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        let department = departments[row]
        label.text = "\(department.displayName)"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Highlight item yang dipilih
        if pickerView.selectedRow(inComponent: component) == row {
            label.textColor = .white
            label.backgroundColor = .black
            
        } else {
            label.textColor = .black
            label.backgroundColor = .clear
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40 // Set tinggi default untuk setiap baris
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.reloadAllComponents()
        
        let selectedDepartment = departments[row]
        print("Selected: \(selectedDepartment.displayName) (ID: \(selectedDepartment.departmentId))")
        setDepartemenImage(depId: selectedDepartment.departmentId)
        
        id = selectedDepartment.departmentId
        titleNav = selectedDepartment.displayName
    }
    
    
    // MARK: - Set Departement Image by Departemen Id
    func setDepartemenImage(depId: Int) {
        
        DispatchQueue.main.async {
            
            self.backgroundImage.image = UIImage(named: "dep-bg-\(depId).jpg")
            self.backgroundImage.layer.cornerRadius = 10
            self.backgroundImage.layer.masksToBounds = true
        }
    }
    
    
    // MARK: - Set Default Object on Departement View
    func openingScreen() {
        
        self.backgroundImage.image = UIImage(named: "dep-bg-1.jpg")
        self.backgroundImage.layer.cornerRadius = 10
        self.backgroundImage.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = homeBackground.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.2
        homeBackground.addSubview(blurEffectView)
    }
    
    
    // MARK: - Action for go to list data object by clicking button open
    @IBAction func tapOpen(_ sender: UIButton) {
        
        if id == 0 || titleNav == "" {
            id = 1
            titleNav = "American Decorative Arts"
        }
        
        performSegue(withIdentifier: "goToListData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToListData" {
            let destinationVC = segue.destination as! ListDataViewController
            destinationVC.depId = id
            destinationVC.titleNavBar = titleNav
        }
    }
    
}
