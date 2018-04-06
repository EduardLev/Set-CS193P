//
//  ViewController.swift
//  Set-CS193P
//
//  Created by Eduard Lev on 4/5/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: View Controller Properties

    /// Array of UIButton that will show the game elements
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet {
            for button in cardButtons {
                button.layer.cornerRadius = 8.0
            }
        }
    }

    /// Outlet for the Deal Three Cards Button
    @IBOutlet weak var dealThreeCardsButton: UIButton!

    /// Outlet for the New Game Button
    @IBOutlet weak var newGameButton: UIButton!

    private var selectedButtons = [UIButton]()

    // MARK: View Properties
    private var setGame = SetGame()

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }

    // MARK: UIButton Actions

    /// Add action here later
    /// - parameter sender: The UIButton that the user selected
    @IBAction func cardDidTouch(_ sender: UIButton) {
        selectCard(sender)
    }

    /// Add action here later
    @IBAction func newGameButtonDidTouch(_ sender: UIButton) {

    }

    /// Add action here later
    @IBAction func dealThreeCardsButtonDidTouch(_ sender: UIButton) {
        dealThreeCards()
    }

    func createUI() {
        updateViewFromModel()
    }

    // MARK: View Model Actions

    /*
    * Adds three cards to the view shown to the player, as long
    * as there are less than 24 cards currently being shown.
    */
    func dealThreeCards() {
        let cardsShown = setGame.cardsShown.count
        assert(cardsShown <= 24, "ViewController, dealThreeCards(): `cardsShown` is greater than 24")

        guard cardsShown < 24 else { return }
        setGame.addThreeCardsToPlay()
        updateViewFromModel()
    }

    func updateViewFromModel() {
        if selectedButtons.count > 0 {
            for button in selectedButtons {
                button.setAttributedTitle(createAttributedString(using: setGame.cardsShown[cardButtons.index(of: button)!]), for: .normal)
            button.backgroundColor = UIColor(red: 223.0/255, green: 223.0/255, blue: 223/255, alpha: 1.0)
            button.layer.borderWidth = 0.0
            }
        } else {
            for index in cardButtons.indices {
                if index < setGame.cardsShown.count {
            cardButtons[index].setAttributedTitle(createAttributedString(using: setGame.cardsShown[index]), for: .normal)
                    cardButtons[index].backgroundColor = UIColor(red: 223.0/255, green: 223.0/255, blue: 223/255, alpha: 1.0)
                    cardButtons[index].layer.borderWidth = 0.0
                    cardButtons[index].isEnabled = true
                } else {
                    cardButtons[index].backgroundColor = .white
                    cardButtons[index].isEnabled = false
                }
            }
        }
    }

    private func createAttributedString(using card: Card)
        -> NSAttributedString {
            var attributes = [NSAttributedStringKey : Any]()
            var cardText: String

            attributes[.strokeColor] = colors[card.color] // color
            cardText = String(repeating: shapes[card.symbol], count: card.number+1) // symbol & # of repeats

            switch card.shading {
            case 0: attributes[.strokeWidth] = -5.0
                    attributes[.foregroundColor] = (attributes[.strokeColor] as! UIColor)
            case 1: attributes[.foregroundColor] = colors[card.color].withAlphaComponent(0.30)
            case 2: attributes[.strokeWidth] = 5.0
            default: break
            }

            return NSAttributedString(string: cardText, attributes: attributes)
    }

    func selectCard(_ sender: UIButton) {
        if let indexOfSelectedCard = cardButtons.index(of: sender) {
            print(setGame.cardsShown[indexOfSelectedCard])
            if let (toggled, cardsAreASet) = setGame.toggleSelection(of: setGame.cardsShown[indexOfSelectedCard]) {
            selectedButtons.append(sender)
            if let cardsAreASet = cardsAreASet {
                if cardsAreASet {
                    for button in selectedButtons {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = UIColor.green.cgColor
                    }
                } else {
                    for button in selectedButtons {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = UIColor.red.cgColor
                        selectedButtons.remove(at: selectedButtons.index(of: button)!)
                    }
                }
            } else if toggled {
                if selectedButtons.count > 3 {
                    updateViewFromModel()
                    sender.layer.borderWidth = 3.0
                    sender.layer.borderColor = UIColor.blue.cgColor
                } else {
                    sender.layer.borderWidth = 3.0
                    sender.layer.borderColor = UIColor.blue.cgColor
                }
            } else {
                selectedButtons.remove(at: (selectedButtons.index(of: sender))!)
                sender.layer.borderWidth = 0.0
            }
            } else {
                updateViewFromModel()
            }
        }
    }

}

