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

    mutating func toggleSelection(of card: Card) -> (toggled: Bool, set: Bool?)? {
        guard !cardsMatched.contains(card) else { return nil }

        // if there are selected cards, and the cards matched contains
        // one of the selected cards, that means that the selected cards
        // have been involved in a match.
        // therefore remove the selected cards from the cards shown,
        // remove the selected cards, and add 3 new cards (if possible) to the cards shown.
        if let oneSelectedCard = selectedCards.first {
            if cardsMatched.contains(oneSelectedCard) {
                for selectedCard in selectedCards {
                    actualDeck.remove(selectedCard)
                    replaceCard(card: selectedCard)
                    selectedCards.remove(at: selectedCards.index(of: selectedCard)!)
                }
                return nil
            }
        }

        if selectedCards.count == 3 {
            selectedCards.removeAll()
        }

        if let index = selectedCards.index(of: card) {
            selectedCards.remove(at: index)
            return (false, nil)
        } else {
            selectedCards.append(card)
            if selectedCards.count == 3 {
                if checkForSet() {
                    cardsMatched += selectedCards
                    return (true, true)
                } else {
                    return (true, false)
                }
            }
        }
        return (true, nil)
    }

    mutating func replaceCard(card: Card) {
        if let index = cardsShown.index(of: card) {
            cardsShown.remove(at: index)
            cardsShown.insert(actualDeck.popFirst()!, at: index)
        }
    }

    func checkForSet() -> Bool {
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
        var addedCards = 0
        while addedCards < 3 {
            if actualDeck.count > 0 {
                cardsShown.append(actualDeck.popFirst()!)
                addedCards += 1
            }
        }
    }
        
    
    
}


