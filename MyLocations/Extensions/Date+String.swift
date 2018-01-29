//
//  Date+String.swift
//  MyLocations
//
//  Created by Caludia Carrillo on 1/28/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

extension Date {
  func toString(withFormat format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    
    return dateFormatter.string(from: self)
  }
}


