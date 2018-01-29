//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Caludia Carrillo on 1/26/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var latitudeLabel: UILabel!
  @IBOutlet private weak var longitudeLabel: UILabel!
  @IBOutlet private weak var addressLabel: UILabel!
  @IBOutlet private weak var tagButton: UIButton!
  @IBOutlet private weak var getButton: UIButton!
  
  let locationManager = CLLocationManager()
  var location: CLLocation?
  var updatingLocation = false
  var lastLocationError: Error?
  
  let geocoder = CLGeocoder()
  var placemark: CLPlacemark?
  var performingReverseGeocoding = false
  var lastGeocodingError: Error?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateLabels()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  // MARK - Action methods
  
  @IBAction private func getLocation() {
    let authStatus = CLLocationManager.authorizationStatus()
    if authStatus == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
      return
    }
    
    if authStatus == .denied || authStatus == .restricted {
      showLocationServicesDeniedAlert()
      return
    }
    
    if updatingLocation {
      stopLocationManager()
    } else {
      location = nil
      lastLocationError = nil
      startLocationManager()
    }
    updateLabels()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "TagLocation" {
      let controller = segue.destination as! LocationDetailsViewController
      controller.coordinate = (location?.coordinate)!
      controller.placemark = placemark
    }
  }
  
  // MARK - Private methods
  func string(from placemark: CLPlacemark) -> String {
    // 1
    var line1 = ""
    // 2
    if let s = placemark.subThoroughfare {
      line1 += s + " "
    }
    // 3
    if let s = placemark.thoroughfare {
      line1 += s }
    // 4
    var line2 = ""
    if let s = placemark.locality {
      line2 += s + " "
    }
    if let s = placemark.administrativeArea {
      line2 += s + " "
    }
    if let s = placemark.postalCode {
      line2 += s }
    // 5
    return line1 + "\n" + line2
  }
  private func showLocationServicesDeniedAlert() {
    let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    present(alert, animated: true, completion: nil)
    alert.addAction(okAction)
  }
  
  private func updateLabels() {
    if let location = location {
      latitudeLabel.text = String(format: "%.2f", location.coordinate.latitude)
      longitudeLabel.text = String(format: "%.2f", location.coordinate.longitude)
      tagButton.isHidden = false
      messageLabel.text = ""
      
      if let placemark = placemark {
        addressLabel.text = string(from: placemark)
      } else if performingReverseGeocoding {
        addressLabel.text = "Searching for Address..."
      } else if lastGeocodingError != nil {
        addressLabel.text = "Error Finding Address"
      } else {
        addressLabel.text = "No Address Found"
      }
    } else {
      latitudeLabel.text = ""
      longitudeLabel.text = ""
      addressLabel.text = ""
      tagButton.isHidden = true
      let statusMessage: String
      if let error = lastLocationError as NSError? {
        if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
          statusMessage = "Location Services Disabled"
        } else {
          statusMessage = "Error Getting Location"
        }
      }
      else if !CLLocationManager.locationServicesEnabled() {
        statusMessage = "Location Services Disabled"
      } else if updatingLocation {
        statusMessage = "Searching..."
      } else {
        statusMessage = "Tap 'Get My Location' to Start"
      }
      messageLabel.text = statusMessage
    }
    
    configureGetButton()
  }
  
  private func startLocationManager() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
      updatingLocation = true
    }
  }
  
  private func stopLocationManager() {
    if updatingLocation {
      locationManager.stopUpdatingLocation()
      locationManager.delegate = nil
      updatingLocation = false
    }
  }
  
  private func configureGetButton() {
    if updatingLocation {
      getButton.setTitle("Stop", for: .normal)
    } else {
      getButton.setTitle("Get My Location", for: .normal)
    }
  }
}

// MARK - Delegate methods for Location Manager
extension CurrentLocationViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("didFailWithError \(error)")
    if (error as NSError).code == CLError.locationUnknown.rawValue {
      return
    }
    
    lastLocationError = error
    stopLocationManager()
    updateLabels()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let newLocation = locations.last else {
      return
    }
    
    print("didUpdateLocations \(newLocation)")
    
    if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
      lastLocationError = nil
      location = newLocation
      
      if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
        print("*** We're done!")
        stopLocationManager()
      }
      updateLabels()
      
      if !performingReverseGeocoding {
        performingReverseGeocoding = true
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { placemarks, error in
          self.lastGeocodingError = error
          if error == nil, let p = placemarks, !p.isEmpty {
            self.placemark = p.last!
          } else {
            self.placemark = nil
          }
          
          self.performingReverseGeocoding = false
          self.updateLabels()
        })
      }
    }
  }
}

