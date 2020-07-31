//
//  HogwartsHouses+Convenience.swift
//  HogwartsHousesCD35
//
//  Created by Alex Lundquist on 7/30/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation
import CoreData
extension HouseGuess {
  convenience init(guessName: String, house: String, isVisible: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
    self.init(context: context)
    self.guessName = guessName
    self.house = house
    self.isVisible = isVisible
  }
}
