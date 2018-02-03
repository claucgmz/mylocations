//
//  MapViewController.swift
//  MyLocations
//
//  Created by Caludia Carrillo on 2/2/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
  var managedObjectContext: NSManagedObjectContext!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
  }
  //MARK: - Actions
  @IBAction func showUser() {
    let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
    mapView.setRegion(region, animated: true)
  }
  
  @IBAction func showLocations() {
    
  }
}


extension MapViewController: MKMapViewDelegate {
  
}
