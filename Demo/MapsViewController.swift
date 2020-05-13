//
//  MapsViewController.swift
//  Demo
//
//  Created by Jhanvi M. on 13/05/20.
//  Copyright © 2020 Jhanvi. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate {
    let pizzaAnnotations = Annotations()
    let initialCoordinate = CLLocationCoordinate2DMake(41.9180474,-87.661767)
    @IBOutlet weak var mapView: MKMapView!
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        guard let annotation = annotation as? Annotation else {return nil}
        var identifier = ""
    
        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.canShowCallout = true
        annotationView.markerTintColor = .blue
        annotationView.clusteringIdentifier = identifier
        return annotationView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        //set intial region
        let initialregion = MKCoordinateRegion(center: initialCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        mapView.setRegion(initialregion, animated: true)
        // add the annotations
        mapView.addAnnotations(pizzaAnnotations.restaurants)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
