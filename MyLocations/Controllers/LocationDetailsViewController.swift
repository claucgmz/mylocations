//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Caludia Carrillo on 1/27/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController {
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark?
  var categoryName = "No Category"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    descriptionTextView.text = ""
    categoryLabel.text = ""
    latitudeLabel.text = String(format: "%2.f", coordinate.latitude)
    longitudeLabel.text = String(format: "%2.f", coordinate.longitude)
    categoryLabel.text = categoryName
    
    if let placemark = placemark {
      addressLabel.text = string(from: placemark)
    }
    else {
      addressLabel.text = "No address found"
    }
    
    dateLabel.text = Date().toString(withFormat: "MMMM, dd YYYY")
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    gestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
    let point = gestureRecognizer.location(in: tableView)
    let indexPath = tableView.indexPathForRow(at: point)
    if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
      return
    }
    descriptionTextView.resignFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickCategory" {
      let controller = segue.destination as! CategoryPickerViewController
      controller.selectedCategoryName = categoryName
    }
  }
  
  @IBAction private func done() {
    let hudView = HudView.hud(inView: navigationController!.view, animated: true)
    hudView.text = "Tagged"
    
    let delayInSeconds = 0.6
    afterDelay(delayInSeconds, run: {
      hudView.hide()
      self.navigationController?.popViewController(animated: true)
    })    
  }
  
  @IBAction private func cancel() {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
    let controller = segue.source as! CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }
  
  // MARK: - Private methods
  private func string(from placemark: CLPlacemark) -> String {
    var text = ""
    if let s = placemark.subThoroughfare {
      text += s + " " }
    if let s = placemark.thoroughfare {
      text += s + ", "
    }
    if let s = placemark.locality {
      text += s + ", "
    }
    if let s = placemark.administrativeArea {
      text += s + " " }
    if let s = placemark.postalCode {
      text += s + ", "
    }
    if let s = placemark.country {
      text += s }
    return text
  }
}

// MARK: - Table View Delegates
extension LocationDetailsViewController {
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 0 || indexPath.section == 1 {
      return indexPath
    }
    else {
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      descriptionTextView.becomeFirstResponder()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 && indexPath.row == 0 {
      return 88
    }
    else if indexPath.section == 2 && indexPath.row == 2 {
      addressLabel.frame.size = CGSize( width: view.bounds.size.width - 120, height: 10000)
      addressLabel.sizeToFit()
      addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 16
      return addressLabel.frame.size.height + 20
    }
    else {
      return 44
    }
  }
}
