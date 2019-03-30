//
//  Constants .swift
//  Project4-Draft
//
//  Created by Abdeltwab Elhussin on 3/22/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import Foundation

struct Constnats  {

struct APIBaseURLS {
    static let FLickerBURL = "https://api.flickr.com/services/rest/"
}

// MARK :Flicker Parmaters Keys
struct FlickerPramtersKey {
    //get galleris.getphotos
    static let Method = "method"
    static let APIKey = "api_key"
    static let GalleryID = "gallery_id"
    static let Extras = "extras"
    static let Format = "format"
    static let NoJSONCallback = "nojsoncallback"
    //photos.search
    
    
}

 // MARK: Flickr Parameter Values
struct FlickerParametersValues {
    static let APIKey = "a4649255bf61107387a61890cceaadb3"
    static let GalleryPhotosName = "flickr.galleries.getPhotos"
    static let ResponseFormat = "json"
    static let DisabelJasonCallback = 1  // means yes
    static let gallerID = "5704-72157622566655097"
    static let MediumPhoto = "url_m"
    }

    
    
    struct FlickerResponseKeys {
        static let photos = "photos"
        static let photo = "photo"
        static let title = "title"
        static let MediumURL = "url_m"
        static let ispublic = "ispublic"
        static let Status = "stat"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    struct FlcikerResposneValues {
        static let IsOk = "ok"
    }
}



// the URL

/*
https://api.flickr.com/services/rest/?
 method=flickr.galleries.getPhotos&
 api_key=174d95b6d604fea23d046c2c34bc108a&
 gallery_id=gallery_id&
 format=json&
 nojsoncallback=1&
 auth_token=72157677323446477-d560244d657ed90b&
 api_sig=82455292fb37e3673eccbb64e7f7841e
*/
