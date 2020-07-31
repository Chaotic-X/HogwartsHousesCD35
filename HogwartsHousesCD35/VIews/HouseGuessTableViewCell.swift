//
//  HouseGuessTableViewCell.swift
//  HogwartsHousesCD35
//
//  Created by Alex Lundquist on 7/30/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import UIKit

//MARK: -Protocols
protocol HouseGuessTableViewCellDelegate: class {
  func houseButtonTappedDoSomething(_ sender: HouseGuessTableViewCell )
}
class HouseGuessTableViewCell: UITableViewCell {
  
  //MARK: -Properties
  
  var guess: HouseGuess? {
    //We are doing a property observer because this
    //TableViewCell doesn't natively have a viewDidLoad func
    //so we do one by creating the computed property
    didSet {
      updateViews()
    }
  }
  
  weak var delegate: HouseGuessTableViewCellDelegate?
  
  //MARK: -Outlets
  @IBOutlet weak var personGuessLabel: UILabel!
  @IBOutlet weak var houseImageButton: UIButton!
  
  //MARK: -Actions
  @IBAction func houseButtonTapped(_ sender: Any) {
    delegate?.houseButtonTappedDoSomething(self)
  }
  
  
  //MARK: -HelpFunctions
  func updateViews() {
    guard let guess = guess else { return }
    personGuessLabel.text = guess.guessName
    updateButtonFor(for: guess)
  }
  
  func updateButtonFor(for guess: HouseGuess) {
    if guess.isVisible {
      if let house = guess.house {
        houseImageButton.setImage(UIImage(named: house), for: .normal)
      }
    } else {
      houseImageButton.setImage(#imageLiteral(resourceName: "hogwarts"), for: .normal)
    }
  }
}
