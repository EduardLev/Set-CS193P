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

    /// Outlet for the Deal Three (3) Cards Button
    @IBOutlet weak var dealThreeCardsButton: UIButton!

    /// Outlet for the New Game Button
    @IBOutlet weak var newGameButton: UIButton!

    /// Outlet for the Find A Set Button
    @IBOutlet weak var findASetButton: UIButton!

    /// Outlet for the Set Board View
    @IBOutlet weak var setBoardViewOutlet: SetBoardView!

    /// Holds references to the selected Buttons
    /// Once the count is three, asks the model whether the selection
    /// consists of a set or not, and draws the border accordingly
    private var selectedViews = [SetCardView]() {
        didSet {
            if selectedViews.count == 3 {
                setWasFound = checkIfSelectedViewsFormASet()
                selectedViews.forEach { (setCardView) in
                    setCardView.wasInvolvedInMatch = setWasFound
                    // Disable Button if a set was found!
                    setCardView.gestureRecognizers?.first?.isEnabled = false
                }
            }
        }
    }

    // MARK: View Model Properties

    /// Pointer to an instance of SetGame, with 81 cards.
    /// See Set for more
    private var setGame = SetGame()

    /// Will record whether or not the three cards selected formed a Set
    private var setWasFound = false

    private var selectedProperties: (Int, Int, Int, Int) = (-1, -1, -1, -1)

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        addEndGameObservers()
    }

    // MARK: UIButton Actions

    /// Calls the method `computerFindSet` to show a computer
    /// generated Set in the cards that are currently displayed.
    @IBAction func findASetButtonDidClick(_ sender: UIButton) {
        //selectedViews.removeAll()
        //updateViewFromModel()
        //computerFindSet(startingIndex: 0)
    }

    /// Restarts the game
    @IBAction func newGameButtonDidTouch(_ sender: UIButton) {
        dealThreeCardsButton.isEnabled = true
        newGameButton.isHidden = true
        updateViewFromModel()
    }

    /// Calls the view method dealThreeCards function
    @IBAction func dealThreeCardsButtonDidTouch(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            sender.transform = CGAffineTransform.identity
        }
        dealThreeCards()
    }

    @IBAction func dealThreeCardsButtonDidTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    // MARK: View Model Actions

    /**
     Updates the current view to show the cards in the Set game model that are
     supposed to be currently shown to user.

     Loops through all indices of the 24 buttons on screen, and checks
     to see if the model has a card available to show on that button. If
     the card is available, it will be shown. If no card exists at that index
     in the model, the button will not be shown & wil be disabled to the user.
     Cards are drawn with no borders.
    */
    func updateViewFromModel() {
        // Loop through all views and update
        // first, clear the views
        setBoardViewOutlet.setCardSubviews.removeAll()
        for index in 0..<setGame.cardsShown.count {
            let cardToDisplay = setGame.cardsShown[index]
            let cardView = createCardView(using: cardToDisplay)
            setBoardViewOutlet.setCardSubviews.append(cardView)
        }
    }

    /**
     Creates and returns a `SetCardView` by initializing, adding a tap gesture,
     and configuring properties
    */
    private func createCardView(using card: Card) -> SetCardView {
        let cardView = SetCardView()
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTouchOfView(sender:)))
        cardView.addGestureRecognizer(tapGesture)
        (cardView.number, cardView.symbol, cardView.shading, cardView.color) = card.allProperties()
        return cardView
    }

    /**
     Responds to a button being selected by the user. The input is the button that was
     touched by the user.
    */
    @objc func handleTouchOfView(sender: UITapGestureRecognizer) {
        if let setCardView = sender.view as? SetCardView {
            let selectedCardProperties = setCardView.allProperties
            // now you can use 'setCardView' as the view
            // At this point, nothing new is yet selected.
            // Therefore the `selectedViews` array will only hold the views
            // that had been previously selected. If these formed a set,
            // `setWasFound` would be true, and false otherwise.
            if selectedViews.count == 3 {
                replaceOrDeselectCards()
            }
            toggleSelectionOfCardWithProperties(selectedCardProperties)
        }
    }

    /**
     Shuffles the `Card`s on screen when user rotates with two fingers.
     Also removes all currently selected cards.
    */
    @IBAction func userDidRotate(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            setGame.cardsShown.shuffle()
            selectedViews.removeAll()
            updateViewFromModel()
        default: break
        }
    }

    /**
     Removes all buttons from `selectedButtons` array and redraws the View.
     */
    func replaceOrDeselectCards() {
        // no matter what, we're going to be deselecting the buttons that
        // had already been selected.
        selectedViews.removeAll()
        updateViewFromModel()
    }

    /**
     Selects or deselects a `Card` based on its previous selection state
     */
    func toggleSelectionOfCardWithProperties(_ selectedCardProperties: (Int,Int,Int,Int)) {
        if let index = setBoardViewOutlet.setCardSubviews.index(where: { $0.allProperties == selectedCardProperties } ) {
            let setCardView = setBoardViewOutlet.setCardSubviews[index]
            if selectedViews.contains(setBoardViewOutlet.setCardSubviews[index]) {
                setCardView.isSelected = false
                selectedViews.remove(at: selectedViews.index(of: setCardView)!)
            } else {
                setCardView.isSelected = true
                selectedViews.append(setCardView)
            }
        }
    }

    /**
     Grabs the card indices by comparing to cardButtons array, and then
     sends the selected buttons to the Set Game. Returns a Bool if the
     user selection corresponds to a Set.
 */
    func checkIfSelectedViewsFormASet() -> Bool {
        var selectedCardIndexes = [Int]()
        for setCardView in selectedViews {
            if let selectedCardIndex = setBoardViewOutlet.setCardSubviews.index(of: setCardView) {
                selectedCardIndexes.append(selectedCardIndex)
            }
        }
        return setGame.inputSelectionWith(indexes: selectedCardIndexes)
    }

    /*
    * Adds three cards to the view shown to the player, as long
    * as there are less than 24 cards currently being shown.
    */
    func dealThreeCards() {
        setGame.addThreeCardsToPlay()
        updateViewFromModel()
    }

    /*
     Shows (as highlight) to the user a set that exists in the
     current view. If no set exists, will not highlight any cards.

     Loops through the buttons with a highlight to show the
     user how the calculation runs.
    */
    private func computerFindSet(startingIndex: Int) {
        /* FUTURE FUNCTIONALITY FOR RECURSIVE FINDING FUNCTION
        // base case
        if selectedButtons.count == 3 {
            return
        }

        for buttonIndex in startingIndex..<setGame.cardsShown.count {
            if setWasFound {
                print("setWasFound")
                break }
            // add the button to `selectedButtons` and continue
            toggleSelectionOfButton(cardButtons[buttonIndex])
            computerFindSet(startingIndex: (buttonIndex + 1))
            toggleSelectionOfButton(cardButtons[buttonIndex])
            computerFindSet(startingIndex: (buttonIndex + 1))
        }
 */
    }

    // MARK: End Game Actions & Observers

    @objc private func gameDidEnd() {
        newGameButton.isHidden = false
        dealThreeCardsButton.isEnabled = false
        let alert = UIAlertController(title: "Congratulations!",
                                      message: "You have found all the sets in the deck",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true)
    }

    private func addEndGameObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gameDidEnd),
                                               name: Notification.Name.init("gameDidEnd"),
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


