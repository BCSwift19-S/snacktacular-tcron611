//
//  Photo.swift
//  Snacktacular
//
//  Created by Thomas Ronan on 4/15/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String //universal unique id
    
    var dictionary: [String: Any] {
        return["description": description, "postedBy": postedBy, "date": date]
    }
   
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
   
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"]as! String? ?? ""
        let postedBy = dictionary["postedBy"]as! String? ?? ""
        let timestamp = dictionary["date"] as? Timestamp //Added this to fix error, date was of type Timestamp so needed to convert in order to work.
        let date = timestamp!.dateValue()
        // let date = dictionary["date"] as! Date? ?? Date()
        self.init(image: UIImage(), description: description, postedBy: postedBy, date: date, documentUUID: "")
    }
    
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        //convert photo.image to a Data type so it can be saved by Firebase Storage.
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("Error: Could not convert image to data format")
            return completed(false)
        }
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        documentUUID = UUID().uuidString //generate a unique ID to use for the photo image's name
        //create a ref to upload storage to spot.documentID's folder, with name we created
        
        let storageRef = storage.reference().child(spot.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData)
            {metadata, error in
                guard error == nil else {
                    print("NOOOOOOOOO! Error during put data storage reference \(storageRef). Error: \(error!.localizedDescription)")
                    return
                }
            print("Upload worked!!")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            //this will either create new doc at documentUUID or update the existing doc with that name
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentUUID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("**** Error: upload task for file \(self.documentUUID) failed, in spot \(spot.documentID)")
            }
            return completed(false)
        }
    }
}

