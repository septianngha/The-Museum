//
//  ListDataViewController.swift
//  The Museum
//
//  Created by Muhamad Septian Nugraha on 27/10/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListDataViewController: UITableViewController {
    
    @IBOutlet weak var listLabel: UILabel!
    
    var depId: Int = 1
    var id: Int = 0
    var titleNavBar : String = ""
    var rowCount = 20
    
    var objectIDs: [Int] = []
    var objectDataList: [ObjectData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        id = depId
        self.listLabel.text = titleNavBar
        if id == 5 || id == 12 {
            self.listLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        
        registerCell()
        getDataObjectId()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "List of Collection"
    }
    
    
    // MARK: - API for Get Data by Departement Id
    func getDataObjectId() {
        
        let API_OBJECT_ID = "https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=\(id)"
        
        AF.request(API_OBJECT_ID).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                // print(value)
                
                let listId: JSON = JSON(value)
                
                // Ambil objectIDs sebagai array
                self.objectIDs = Array(listId["objectIDs"].arrayValue.prefix(50).map { $0.intValue })
                
                // Mengambil data id objek secara acak sebanyak rowCount
                let randomObjectIDs = self.objectIDs.shuffled().prefix(self.rowCount)
                
                // Memanggil getObjectList dan mengirim data id yang sudah dirandom
                for id in randomObjectIDs {
                    // print(id)
                    self.getObjectList(objectIDs: id)
                }
            
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    
    // MARK: - API for get data detail by data id
    func getObjectList(objectIDs: Int) {
        
        let API_OBJECT_ID = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(objectIDs)"
        
        AF.request(API_OBJECT_ID).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                // print(value)
                
                let objectData: JSON = JSON(value)
                let dataId = objectData["objectID"].intValue
                let dataName = objectData["objectName"].stringValue
                let dataTitle = objectData["title"].stringValue
                let dataImage = objectData["primaryImage"].stringValue
                
                // Simpan data ke dalam array
                if !dataImage.isEmpty {
                    let objectDataItem = ObjectData(
                        objectID: dataId,
                        objectName: dataName,
                        title: dataTitle,
                        primaryImage: dataImage)
                    self.objectDataList.append(objectDataItem)
                    
                    // Reload tabel setelah data ditambahkan
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }

    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectDataList.count // Menampilkan rows sebanyak jumlah data di objectDataList
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectCell", for: indexPath) as? ObjectTableViewCell else {
            return UITableViewCell()
        }

        let objectData = objectDataList[indexPath.row]
        cell.titleList.text = objectData.objectName
        cell.subtitleList.text = objectData.title
    
        // Menambahkan image pada data tabel
        let noImage = "https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
        let imageString = objectData.primaryImage

        // Cek apakah URL valid, jika tidak gunakan URL default
        let urlImage = URL(string: imageString.isEmpty ? noImage : imageString) ?? URL(string: noImage)!

        cell.imageList.downloaded(from: urlImage, contentMode: .scaleToFill)

        return cell
    }

    
    // MARK: - TableView Delegate Methods
    // Delegate digunakan untuk triger ketika cell di klik
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDetail", sender: self)
        
        // Mengatur agar hover bisa dianimasikan
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Menjalankan fungsi sebelum segue di jalankan
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? DetailObjectViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            
            let objectData = objectDataList[indexPath.row]
            destinationVC.objectId = objectData.objectID
            destinationVC.titleObject = objectData.objectName
        }
    }
    
    
    // MARK: - Register for Custom Table Cell
    func registerCell() {
        
        let nib = UINib(nibName: "ObjectTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ObjectCell")
        
        tableView.rowHeight = 129.0
    }
    
}
