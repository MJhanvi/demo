//
//  Annotations.swift
//  Demo
//
//  Created by Jhanvi M. on 13/05/20.
//  Copyright © 2020 Jhanvi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Annotation:NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(_ latitude:CLLocationDegrees,_ longitude:CLLocationDegrees,title:String,subtitle:String){
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = title
        self.subtitle = subtitle
    }
}


class Annotations: NSObject {
    var restaurants:[Annotation]
    
    override init(){
        restaurants = [Annotation(41.892472,-87.62687676, title: "Restuarant 1", subtitle:"Address1")]
        restaurants += [Annotation(41.8931164,-87.6267778, title: "Restuarant 2", subtitle:"Address2")]
        restaurants += [Annotation(41.8957338,-87.6229457, title: "Restuarant 3", subtitle:"Address3")]
        restaurants += [Annotation(41.9206924,-87.6375364, title: "Restuarant 4",  subtitle:"Address4")]
         restaurants += [Annotation(41.9217837,-87.6645778, title: "Restuarant 5",  subtitle:"Address5")]
         restaurants += [Annotation(42.0018732,-87.7258586 , title: "Restuarant 6", subtitle:"Address6")]
         restaurants += [Annotation(41.8910953,-87.6597941 , title: "Restuarant 7", subtitle:"Address7")]
         restaurants += [Annotation(41.9105463,-87.6760223, title: "Restuarant 8", subtitle:"Address8")]
         restaurants += [Annotation(41.9633682,-87.6737948, title: "Restuarant 9", subtitle:"Address9")]
    }
}
