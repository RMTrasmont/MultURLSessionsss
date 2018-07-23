//
//  ViewController.swift
//  MultURLSessionsss
//
//  Created by Rafael M. Trasmontero on 7/17/18.
//  Copyright © 2018 RMT. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

struct User:Decodable,Encodable {
    var address:Address?
    var company:Company?
    var email:String?
    var id:Int?
    var name:String?
    var phone:String?
    var username:String?
    var website:String?
}

struct Address:Decodable,Encodable{
    var city:String?
    var geo:[String:String]?
    var street:String?
    var suite:String?
    var zipcode:String?
}

struct Company:Decodable,Encodable{
    var bs:String?
    var catchPhrase:String?
    var name:String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //O.G. GET
    @IBAction func OldSchoolGET(_ sender: UIButton) {
        guard let getURL = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        URLSession.shared.dataTask(with: getURL) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            } else {
                guard let jsonData = data else { return }
                do {
                    let gottenObject =  try JSONSerialization.jsonObject(with: jsonData, options: []) as! [Any]
                //print(gottenObject)
                print(gottenObject[2])
                //DO THE EXTRA ANNOYING PARSING HERE...
                    
                } catch {
                print(error)
                }
            }
        }.resume()
 
    }
    
    //O.G. GET w/ AlamoFire
    @IBAction func oldSchoolGETwAlamo(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        Alamofire.request(url).responseJSON { (response) in
            guard let fetchedObjects = response.value as? [[String:Any]] else {return}
            print(fetchedObjects[0])
            //DO PARSING OF DATA HERE
        }
        
    }
    
    //O.G. POST
    @IBAction func oldSchoolPOST(_ sender: UIButton) {
        guard let postURL = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        let dataToPOST = ["Name":"Mike Jones", "Who" : "Mike Jones"]
        var request = URLRequest.init(url: postURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
          request.httpBody = try JSONSerialization.data(withJSONObject: dataToPOST, options: [])
        } catch {
            print(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do{
                    guard let postedData = try? JSONSerialization.jsonObject(with: data!, options: []) else {return}
                    print(postedData)
                    //DO THE EXTRA ANNOYING PARSING HERE...
                }
            }
        }.resume()
        
        
    }
    
    //DECODE GET
    @IBAction func getAndDECODE(_ sender: UIButton) {
        guard let targetURL = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        URLSession.shared.dataTask(with: targetURL) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do{
                    if let jsonData = data{
                        let objects = try JSONDecoder().decode([User].self, from: jsonData)
                        //WORK DECODER MAGIC HERE...PARSE
                        print(objects)
                        
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    //ENCODE(& DECODE) POST
    @IBAction func encodePOST(_ sender: UIButton) {
        guard let targetURL = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        //CREATE OBJECT TO POST
        let address = Address(city: "Piscataway", geo: ["lat" : "123" , "long":"321"], street: "Kingsbridge", suite: "40", zipcode: "08854")
        let company = Company(bs: "Tripple Eight", catchPhrase: "Grab them by the Pussy", name: "Donald Trump")
        let user = User(address: address, company: company, email: "trump@trump.com", id: 234321, name: "The Donald", phone: "888-999-0000", username: "Donnie-T", website: "wwww.NanananananaTRUMP.com")
        //SET UP REQUEST
        var request = URLRequest(url: targetURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            //ENCODE OBJECT TO BE POSTED
            let dataToPOST = try JSONEncoder().encode(user)
            request.httpBody = dataToPOST
        } catch {
            print(error.localizedDescription)
        }
        //POST THE OBJECT TO SERVER
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            if data != nil {
                do {
                    //DECODE DATA TO CONFIRM OUR OBJECT WAS POSTED
                    let postedObject = try JSONDecoder().decode(User.self, from: data!)
                    print(postedObject)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
        
    }
    
    //GET WITH ALAMOFIRE THEN DECODE
    @IBAction func getWithAlamofireAndDecode(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        Alamofire.request(url).responseJSON { (response) in
            if let dataToDecode = response.data {
                do{
                    let objects = try JSONDecoder().decode([User].self, from: dataToDecode)
                    print(objects)
                    //DO ANNOYING PARSING OF OBJECT PROPERTIES HERE
                    //print("\(String(describing: objects[1].address?.city))")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    
    }
    
    @IBAction func getWithAlamofireAndSwiftyJSON(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        Alamofire.request(url).responseJSON { (response) in
            if let dataForSwiftyJSON = response.data {
                do {
                    let json = try JSON(data: dataForSwiftyJSON)
                    print(json)
                    //PARSE JSON USING SWIFTY HERE
                    //print(json[0]["address"]["street"].stringValue)
                    //print(json.arrayValue.map({$0["name"].stringValue}))
                    //print(json.arrayValue.map({$0["address"].dictionary}))
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func postWithAlamofire(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        let objectToPost = ["UserName":"Ric Flair" , "Address":"16 Wooooooooo Drive"]
        //NOTE: MUST have "encoding: JSONEncoding.default" and Parameters MUST be [String:String] type to avoid "extra method error"
        Alamofire.request(url, method: .post, parameters: objectToPost, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { (response:DataResponse<Any>) in
            response.result.ifSuccess {
                if let postedData = response.result.value {
                    print(postedData)
                }
            }
        }

    }
    
    
    @IBAction func postWithAlamofireAndDecodeAndEncode(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        //CREATE OBJECT TO POST
        let address = Address(city: "Piscataway", geo: ["lat" : "123" , "long":"321"], street: "Kingsbridge", suite: "40", zipcode: "08854")
        let company = Company(bs: "Tripple Eight", catchPhrase: "Grab them by the Pussy", name: "Donald Trump")
        let user = User(address: address, company: company, email: "trump@trump.com", id: 234321, name: "The Donald", phone: "888-999-0000", username: "Donnie-T", website: "wwww.NanananananaTRUMP.com")
        //SETUP REQUEST "extra method error" appears in Alamofire b/c parameter is not [String:Any] so set up request seperately
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let objectToPOST = try JSONEncoder().encode(user)
            request.httpBody = objectToPOST
        } catch {
            print(error.localizedDescription)
        }
        
        //GET YOUR ALAMOFIRE ON...DON'T FORGET TO MAKE response "response:DataResponse<Any>"
        Alamofire.request(request).responseJSON { (response:DataResponse<Any>) in
            if response.result.isSuccess {
                guard let postedObject = response.result.value else {return}
                print(postedObject)
            }
        }


    }
    


}

