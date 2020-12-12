//
//  ViewController.swift
//  Project4-Draft
//
//  Created by Abdeltwab Elhussin on 3/16/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//
/*
 what i have larned so far
 1- protoclos
 2- Http methods and status codes
 3- Https vs Http
 4-  how to make a request
        - first define a URL
        - then a session
        - then make a request
5-  make sure your are running in the foreground ot in the background
6- how to allow http requests 
 
 7- i had a problem when trying to use the url  after dividing it to the standard waay
    it was always return error  ,  that can not convert the url string to URL
   the problem tell now is the URLString was wrong
 The problem was
 ** the sapces between Equal signs and the Paramters
 ** changing the order of the parameters in the URL has no effect
 
 *- Serialization — converting an object into a stream of bytes; this is often done to send an object over the network so that it can be recreated somewhere else
 */

/*
 8- to parse the Json data we need three steps
    - get the raw data
    - convert it into a swf object  : Ns array  or NSDictionary
    - get the Key-Value paris you want
 */

/*9-
 when trying to convert to data using this line :
 if let imgData = try? Data (contentsOf: imgURl!)
 i had an error :
   Invalid conversion from throwing function of type '(_, _, _) throws -> ()' to non-throwing function type '(Data?, URLResponse?, Error?) -> Void'
 i solved it by adding ? after try
 the reason is here  : https://stackoverflow.com/questions/48712752/swift4-invalid-conversion-from-throwing-function-of-type-throws
 
 */

/*
 10 -  the Gurad else statment
 
 */

import UIKit

class ViewController: UIViewController {

    //outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var buttonView: UIButton!
    @IBOutlet weak var photoLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // URL
        /*let imgURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg")!
        // URL  session
        let task = URLSession.shared.dataTask(with: imgURL) { (data, response, err) in
            if err == nil {
                let downlaodedImg = UIImage(data: data!)
               performUIUpdatesOnMain{
                self.imgView.image = downlaodedImg

                }
            }
            
        }
        
        task.resume()
        */

    }
    
    // MARK : Configure UI
    private func configureUI (enabled : Bool){
        buttonView.isEnabled = enabled
        photoLbl.isEnabled = enabled
    }

    //MARK : Calling the API
    private func getImgFromFlicker () {
       /*Stage 1
         Let URL = Write the URL  as it
         */
        
        /* Stage 2
         let url = URL(string: "\(Constnats.APIBaseURLS.FLickerBURL)?\(Constnats.FlickerPramtersKey.Method)=\(Constnats.FlickerParametersValues.GalleryPhotosName)&\(Constnats.FlickerPramtersKey.APIKey) =\(Constnats.FlickerParametersValues.APIKey)&\(Constnats.FlickerPramtersKey.GalleryID) = \(Constnats.FlickerParametersValues.gallerID)& \(Constnats.FlickerPramtersKey.Extras) =\(Constnats.FlickerPramtersKey.Extras) =\(Constnats.FlickerParametersValues.MediumPhoto)&\(Constnats.FlickerPramtersKey.Format) =\(Constnats.FlickerParametersValues.ResponseFormat)&\(Constnats.FlickerPramtersKey.NoJSONCallback) = \(Constnats.FlickerParametersValues.DisabelJasonCallback)")
         
         */
        
        // Stage 3
        let MethodsParameters = [
            Constnats.FlickerPramtersKey.Method : Constnats.FlickerParametersValues.GalleryPhotosName ,
            Constnats.FlickerPramtersKey.APIKey : Constnats.FlickerParametersValues.APIKey ,
            Constnats.FlickerPramtersKey.GalleryID : Constnats.FlickerParametersValues.gallerID ,
            Constnats.FlickerPramtersKey.Extras : Constnats.FlickerParametersValues.MediumPhoto ,
            Constnats.FlickerPramtersKey.Format : Constnats.FlickerParametersValues.ResponseFormat ,
            Constnats.FlickerPramtersKey.NoJSONCallback : Constnats.FlickerParametersValues.DisabelJasonCallback
            ] as [String : AnyObject]
        let URLString = Constnats.APIBaseURLS.FLickerBURL + esacpedParamter(paramters: MethodsParameters as [String :AnyObject])
        

        let url = URL(string: URLString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {(data , respons , err ) in
            
            
            func displayError (_ error :String ) {
                print(error)
                print("Url at time of error : \(url)")
                performUIUpdatesOnMain {
                    self.configureUI(enabled: true)
                }
            }
            guard (err == nil) else {
                displayError("There was an erro with your requrest ")
                return
            }
            
            /*Guard : the status Code */
           // guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            guard let statusCode = ( respons as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                displayError("your request returnd a respnse with status code other that 2.xx")
                return
            }
            
            
            guard let data = data else {
                displayError("no data was retuend by the request ")
                return
            }
            
            // pasing the data
            
            let parsedResults : [String :AnyObject]!
             do{
                 // 2-  converrt the raw json into mangeble data strcutre NSDictioanry
                 parsedResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String :AnyObject]
              } catch {
                  displayError("could not parse the data as Json : '\(data)'")
               return
             }
            
            
            /*Gurad the Flicker returen error  (stat != OK )*/
            guard let stat = parsedResults[Constnats.FlickerResponseKeys.Status] as? String ,stat == Constnats.FlcikerResposneValues.IsOk else {
                displayError("API returned Error see , the Error code and message is \(parsedResults)")
                return
            }
            //3- search for the Key vlaue paris we need
             // Dictionary of the Phoots
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = parsedResults[Constnats.FlickerResponseKeys.photos] as? [String:AnyObject] , let photosArray = photosDictionary[Constnats.FlickerResponseKeys.photo] as? [[String:AnyObject]] else {
                displayError("connot find the keys \(Constnats.FlickerResponseKeys.photos) and \(Constnats.FlickerResponseKeys.photo) in \(parsedResults)")
                return
            }
            
           // Array of all Photos
           // random photo index
           let randomIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
           let individualPhotoDictionary = photosArray[randomIndex] as [String:AnyObject]
            /* GUARD: Does our photo have a key for 'url_m'? */
            guard let imgeURLString  = individualPhotoDictionary[Constnats.FlickerResponseKeys.MediumURL] as? String  ,let photoTitle = individualPhotoDictionary[Constnats.FlickerResponseKeys.title] as? String else {
                displayError("reponse dose not have vlaue for the keys \(Constnats.FlickerResponseKeys.MediumURL) and \(Constnats.FlickerResponseKeys.title) ")
                return
            }
            let imgURl = URL(string: imgeURLString)

            // set the iamge data
             if let imgData = try? Data (contentsOf: imgURl!) {
               performUIUpdatesOnMain {
                  self.imgView.image = UIImage(data: imgData)
                  self.photoLbl.text = photoTitle
                   self.configureUI(enabled: true)
                       }
             }else {
                 // handle that imge data trhow excpetion
                displayError("Image does not exist at \(imgURl)")
                
              }
            
        }// end of the request task
        
        
        //start the task
        task.resume()
       

    }
  
    
    /*
     if let imgeData =  try Data(contentsOf: imgURl!){
     performUIUpdatesOnMain {
     self.imgView.image = UIImage(data: imgeData)
     self.photoLbl.text = photoTitle
     self.configureUI(enabled: true)
     }
     }
     
     
     */
    
    
    
    let someParameters = [
        "course" : "Networking",
        "nanoDegree" : "IOS" ,
        "Quiz" : "escaping paramters"
    ] as [String : AnyObject]
    
    private func esacpedParamter (paramters: [String:AnyObject]) -> String{
        if paramters.isEmpty {
            return ""
        }else {
            var keyVlauePairs = [String]()
            for(key , value) in paramters {
                // make sure it is string
                let stringVlaue = "\(value)"
                //escape it
                let escapedValue = stringVlaue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                
                //append it
                keyVlauePairs.append(key + "=" + "\(escapedValue!)")   // the problem was here
            }
            
            return "?\(keyVlauePairs.joined(separator: "&"))"
        }
        
        
    }
    
    
    
    //MARK : Actios
    @IBAction func buttonAction(_ sender: Any) {
        configureUI(enabled: false)
        getImgFromFlicker()
    }
    
    
}

