//
//  MainTableViewController.swift
//  HogwartsHousesCD35
//
//  Created by Alex Lundquist on 7/30/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    HouseGuessController.shared.fetchResultsController.delegate = self
  }
  //MARK: -Actions
  @IBAction func addButtonTapped(_ sender: Any) {
    presentAlertController()
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return HouseGuessController.shared.fetchResultsController.sections?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return HouseGuessController.shared.fetchResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "guessCell", for: indexPath) as? HouseGuessTableViewCell else { return UITableViewCell()}
    
    let guessToDisplay = HouseGuessController.shared.fetchResultsController.object(at: indexPath)
    cell.guess = guessToDisplay
    cell.delegate = self
    return cell
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return view.frame.height / 7
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return HouseGuessController.shared.fetchResultsController.sectionIndexTitles[section] == "0" ? "Invisibility Cloack" : "Visbile"
  }
  
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let guessToDelete = HouseGuessController.shared.fetchResultsController.object(at: indexPath)
      HouseGuessController.shared.remove(houseGuess: guessToDelete)
    }
  } //End of Delete
  
  //MARK: -Helper Functions
  
  func presentAlertController() {
//    let alertController = UIAlertController(title: "Add House Guess", message: nil, preferredStyle: .alert)
    let alertController = UIAlertController(title: "Add House Guess", message: "Please spell it write!", preferredStyle: .alert)
    alertController.addTextField { (textField) in
      textField.placeholder = "Persons Name"
      textField.textAlignment = .center
    }
    alertController.addTextField { (textField) in
      textField.placeholder = "Person's Hogwarts House"
      textField.textAlignment = .center
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    let guessAction = UIAlertAction(title: "Add", style: .default) { (_) in
      guard let guessName = alertController.textFields?[0].text, // textFieldsArray [0 = fistTextField, 1 = SecondTextfield]
        let house = alertController.textFields?[1].text,
        !guessName.isEmpty && !house.isEmpty else { return }
      HouseGuessController.shared.createGuess(guessName: guessName, house: house)
      //      self.tableView.reloadData()
      
    } //End of guessAction
    alertController.addAction(cancelAction)
    alertController.addAction(guessAction)
    present(alertController, animated: true)
  } //End of Alert
  
} //End of Class

//MARK: -Extensions

extension MainTableViewController: HouseGuessTableViewCellDelegate {
  //We want to update the visibility of the image on the cell where the button was tapped
  //what information do we need to do that.
  
  //Hey tableView.. give us the cell that triggered this event.
  func houseButtonTappedDoSomething(_ sender: HouseGuessTableViewCell) {
    //This is the TableView saying here is that Cell you requested
    guard let indexPath = tableView.indexPath(for: sender) else { return }
    //We now need a place to put to the infor.. that we will be giving to the cell.
    let guess = HouseGuessController.shared.fetchResultsController.object(at: indexPath)
    //This is the name of our function that toggles our image
    HouseGuessController.shared.updateVisibility(houseGuess: guess)
    sender.updateViews()
  }
  
  
}

extension MainTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
      case .insert:
        let indexSet = IndexSet(integer: sectionIndex)
        tableView.insertSections(indexSet, with: .automatic)
      case .delete:
        let indexSet = IndexSet(integer: sectionIndex)
        tableView.deleteSections(indexSet, with: .automatic)
      default:
        fatalError()
    }
  }
  
  //The options we have access to by using NSFetchedResultsContoller
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
      case .delete:
        guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
      case .insert:
        guard let newIndexPath = newIndexPath else { break }
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      case .move:
        guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
        tableView.moveRow(at: indexPath, to: newIndexPath)
      case .update:
        guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .automatic)
      @unknown default:
        fatalError()
    }
  }
}
