//
//  Set.swift
//  Set-CS193P
//
//  Created by Eduard Lev on 4/5/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

/*
 * A structure that represents the game of Set
 *
 *
 */
struct SetGame {
    /// Array of 'Card' that represents the 81 cards in the Set Deck
    private let completeDeck: [Card]

    /// Set of 'Card' that represents how many cards available in the Set Deck
    private var actualDeck: Set<Card>

    /// Array of 'Card' that represents the cards currently shown.
    var cardsShown = [Card]()

    /// Array of `Card`s that have already been matched by the user.
    var cardsMatched = [Card]()

    /// Array of 'Card' that represent cards currently selected.
    /// by the user
    var selectedCards = [Card]()

    /// Int that represents the user score in the current game.
    private(set) var score = 0

    /// Creates an 81 card Set Deck, with each Card
    /// having four properties - number, symbol, shading and color
    /// in the range 0 to 2 inclusive.
    init() {
        var deck = [Card]()
        let range = 0...2
        for number in range {
            for symbol in range {
                for shading in range {
                    for color in range {
                        let card = Card(number: number,
                                        symbol: symbol,
                                        shading: shading,
                                        color: color)
                        deck.append(card)
                        print(card.hashValue)
                    }
                }
            }
        }
        deck.shuffle()
        self.completeDeck = deck

        // creates a set of cards left
        actualDeck = Set(deck)

        // initializes the 12 cards shown at the beginning of the game
        for index in 0..<12 {
            cardsShown.append(deck[index])
            actualDeck.remove(deck[index])
        }
    }

    /**
     Updates the user three-card selection & returns a Bool describing whether or not
     the selection that the user made corresponds to a Set.

     This will update the model `selectedCards` array, and then call
     a helper function to check whether or not a Set is made, since
     this action must occur any time a user inputs a selection of three cards.

     - parameter indexes: The indexes in the cardsShown array that correspond
     to the cards that the user has selected as a guess for a Set match.
    */
    mutating func inputSelectionWith(indexes: [Int]) -> Bool {
        // first, update the selectedCards array
        for index in indexes {
            assert(index < cardsShown.count, "SetGame, inputSelectionWith:, index > cardsShown")
            selectedCards.append(cardsShown[index])
        }

        // once the selected cards have been chosen, check if they are a set
        // if they are, do some actions that move around cards into the correct
        // arrays in the model
        if checkForSet() {
            updateGameForASetFoundAt(indexes: indexes)
            return true
        } else {
            selectedCards.removeAll()
            return false
        }
    }

    private mutating func updateGameForASetFoundAt(indexes: [Int]) {
        // Cards cannot be popped from actualDeck until all the selected
        // cards have been removed. Otherwise there would be duplicates.
        for card in selectedCards {
            if actualDeck.count > 0 { actualDeck.remove(card) }
        }

        // also need to remove the card from cardsShown, actualDeck, and selected Cards
        for card in selectedCards {
            cardsMatched.append(card)
            if let selectedCardIndex = cardsShown.index(of: card) {
                if actualDeck.count > 0 {
                    cardsShown.insert(actualDeck.popFirst()!, at: selectedCardIndex)
                    cardsShown.remove(at: selectedCardIndex + 1)
                } else {
                    cardsShown.remove(at: selectedCardIndex)
                }
            }
            selectedCards.remove(at: selectedCards.index(of: card)!)
        }

        if cardsShown.count == 0 {
            resetGame()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "gameDidEnd"),
                                            object: nil)
        }
    }

    /*
     Sets self to point to a new initialized game of Set
     */
    private mutating func resetGame() {
        self = SetGame()
    }

    /**
     Checks if the three cards in the `selectedCards` array are a Set.
     Returns true/false based on the check

     This function takes advantage of the fact that, for cards involved in a set,
     the added hashvalues only contain numbers that are divisible by 3 (0, 3 and 6).
     This property arises out of the selection of 0, 1 and 2 for card properties,
     as well as the hashValue function for Card.
     */
    private func checkForSet() -> Bool {
        // logic that checks if three cards in an array consist of a set
        var sum = 0
        for card in selectedCards {
            sum += card.hashValue
        }
        let sumString = String(sum)
        return !sumString.contains("1") &&
            !sumString.contains("2") &&
            !sumString.contains("4") &&
            !sumString.contains("5")
    }

    mutating func addThreeCardsToPlay() {
        guard actualDeck.count > 0 else { return }

        var addedCards = 0
        while addedCards < 3 {
            if actualDeck.count > 0 {
                cardsShown.append(actualDeck.popFirst()!)
                addedCards += 1
            }
        }
    }
}


