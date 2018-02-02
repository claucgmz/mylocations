//
//  LocationCell.swift
//  MyLocations
//
//  Created by Caludia Carrillo on 2/2/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  func configure(for location: Location) {
    descriptionLabel.text = location.locationDescription.isEmpty ? "(No description)" : location.locationDescription

  
    if let placemark = location.placemark {
      var text = ""
      if let s = placemark.subThoroughfare {
        text += s + " "
        
      }
      if let s = placemark.thoroughfare {
        text += s + ", "
      }
      if let s = placemark.locality {
        text += s
      }
      addressLabel.text = text
    } else {
      addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
    }
  }
}
