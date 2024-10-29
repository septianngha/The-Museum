//
//  DetailObjectViewController.swift
//  The Museum
//
//  Created by Muhamad Septian Nugraha on 28/10/24.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailObjectViewController: UIViewController {

    @IBOutlet weak var titleObjectLabel: UILabel!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelObjectDate: UILabel!
    @IBOutlet weak var labelMedium: UILabel!
    @IBOutlet weak var labelCulture: UILabel!
    @IBOutlet weak var labelPeriod: UILabel!
    @IBOutlet weak var labelArtistName: UILabel!
    @IBOutlet weak var labelArtistBio: UILabel!
    
    @IBOutlet weak var imgPrimary: UIImageView!
    @IBOutlet weak var imgHomeBackground: UIImageView!
    
    var objectId: Int = 0
    var titleObject: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        getDetailData(objectIDs: objectId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // MARK: - Function for going back when the button pressed
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - GET DATA FROM API
    var objectDataDetail: [ObjectDataDetail] = []
    
    func getDetailData(objectIDs: Int) {
        let API_OBJECT_ID = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(objectIDs)"
        
        AF.request(API_OBJECT_ID).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                let objectData: JSON = JSON(value)
                
                let dataId = objectData["objectID"].intValue
                let dataName = objectData["objectName"].stringValue
                let dataTitle = objectData["title"].stringValue
                let dataImage = objectData["primaryImage"].stringValue
                
                let dataObjectDate = objectData["objectDate"].stringValue
                let dataMedium = objectData["medium"].stringValue
                let dataCulture = objectData["culture"].stringValue
                let dataPeriod = objectData["period"].stringValue
                
                let dataArtistName = objectData["artistDisplayName"].stringValue
                let dataArtisBio = objectData["artistDisplayBio"].stringValue
                
                // Simpan data ke dalam array
                let objectDataItem = ObjectDataDetail(
                    objectID: dataId,
                    objectName: dataName,
                    title: dataTitle,
                    primaryImage: dataImage,
                    
                    objectDate: dataObjectDate,
                    medium: dataMedium,
                    culture: dataCulture,
                    period: dataPeriod,
                    
                    artistDisplayName: dataArtistName,
                    artistDisplayBio: dataArtisBio
                )
                self.objectDataDetail.append(objectDataItem)
                
//                for objectData in self.objectDataDetail {
//                    print("Object ID: \(objectData.objectID)")
//                    print("Object Name: \(objectData.objectName)")
//                    print("Title: \(objectData.title)")
//                    print("Primary Image: \(objectData.primaryImage)")
//                    
//                    print("Object Date: \(objectData.objectDate)")
//                }
                
                // Tambahkan data ke label, dsb.
                DispatchQueue.main.async {
                    self.titleObjectLabel.text = dataName
                    self.labelTitle.text = dataTitle
                    
                    self.labelObjectDate.text = dataObjectDate
                    self.labelMedium.text = dataMedium
                    self.labelCulture.text = dataCulture
                    self.labelPeriod.text = dataPeriod
                    
                    self.labelArtistName.text = dataArtistName
                    self.labelArtistBio.text = dataArtisBio
                    
                    // Menambahkan image pada data tabel
                    let noImage = "https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg"
                    let imageString = dataImage

                    // Cek apakah URL valid, jika tidak gunakan URL default
                    let urlImage = URL(string: imageString.isEmpty ? noImage : imageString) ?? URL(string: noImage)!

                    self.imgPrimary.downloaded(from: urlImage, contentMode: .scaleToFill)
                }
                
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
}
