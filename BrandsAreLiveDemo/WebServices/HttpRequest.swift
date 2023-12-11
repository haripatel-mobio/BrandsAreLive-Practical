//
//  HttpRequest.swift
//  BrandsAreLiveDemo
//
//  Created by Hardik Shah on 09/12/23.
//

import UIKit
import Alamofire
//import AlamofireCoreData

class HttpRequest: NSObject {
    /*let jsonTransformer = DataRequest.jsonTransformerSerializer { (responseInfo, result) -> Result<Any> in
        guard result.isSuccess else {
            return result
        }
        
        let json = result.value as! [String: Any]
        let success = json["success"] as! NSNumber
        switch success.boolValue {
        case true:
            return Result.success(json["data"]!)
        default:
            // here we should create or own error and send it
            return Result.failure("error" as! Error)
        }
    }*/
    
    class func requestGETURL(_ strURL: String, header: HTTPHeaders,  success:@escaping ([String: Any]?) -> Void, failure:@escaping (Error) -> Void) {
        debugPrint(strURL)
        debugPrint(header)
        
        // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        AF.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).response { response in
        
            //UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success(let data):
                if let jsonData = data {
                do {
                    // Assuming the response is in JSON format
                    /*if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                        saveDataToCoreData(jsonArray)
                        success(true)
                    }*/
                    guard let jsonData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                        print("error")
                        return
                    }
                    //saveDataToCoreData(jsonArray)
                    success(jsonData)
                } catch let error {
                    print("Error parsing JSON: \(error)")
                    success(nil)
                }
            }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    /*class func saveDataToCoreData(_ jsonArray: [String: Any]) {
        let context = PersistentContainer.shared.context

        for json in jsonArray {
            print("JSON: \(json)")
            let entity = AnimalImages(context: context)

            //entity.animal_image = json["name"] as? String
            // ...

            do {
                try context.save()
            } catch {
                print("Failed to save data to Core Data: \(error)")
            }
        }
    }*/
    
    class func requestGETCoreData(_ strURL: String, header: HTTPHeaders,  success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        debugPrint(strURL)
        debugPrint(header)
        
        /*AF.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseInsert(jsonSerializer: jsonTransformer, context: PersistentContainer.shared.context, type: Many<Animals>.self) { response in
            switch response.result {
            case let .success(users):
                // users is a instance of Many<User>
                break
            case .failure:
                // handle error
                break
            }
        }*/
    }
}
