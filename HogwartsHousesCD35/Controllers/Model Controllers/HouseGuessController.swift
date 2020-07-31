//
//  HouseGuessController.swift
//  HogwartsHousesCD35
//
//  Created by Alex Lundquist on 7/30/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation
import CoreData

class HouseGuessController {
  
  static let shared = HouseGuessController()
  
  let fetchResultsController: NSFetchedResultsController<HouseGuess> = {
    let fetchRequest: NSFetchRequest<HouseGuess> = HouseGuess.fetchRequest()
    let veiledSort = NSSortDescriptor(key: "isVisible", ascending: false)
    fetchRequest.sortDescriptors = [veiledSort]
    return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isVisible", cacheName: nil)
  }()
  init(){
    do{
      try fetchResultsController.performFetch()
    } catch {
      print("Error in \(#function) : \(error.localizedDescription) \n-------\n \(error)")
    }
  }
  
  //MARK: -CRUD
  
  //Create
  func createGuess(guessName: String, house: String) {
    _ = HouseGuess(guessName: guessName, house: house)
    saveToPersistentStore()
  }
  
  //Update
  func updateVisibility(houseGuess: HouseGuess) {
    houseGuess.isVisible = !houseGuess.isVisible
    //    houseGuess.isVisible.toggle()
    saveToPersistentStore()
  }
  
  //Remove
  func remove(houseGuess: HouseGuess) {
    let moc = CoreDataStack.context
    moc.delete(houseGuess)
    saveToPersistentStore()
  }
  
  //MARK: -PersistentStore
  func saveToPersistentStore() {
    do {
      try CoreDataStack.context.save()
    } catch {
      print("Error in \(#function) : \(error.localizedDescription) \n-------\n \(error)")
    }
  } //End of Save
} //End of Class
