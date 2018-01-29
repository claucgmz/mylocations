//
//  Functions.swift
//  MyLocations
//
//  Created by Caludia Carrillo on 1/29/18.
//  Copyright © 2018 Claudia Carrillo. All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
 DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
