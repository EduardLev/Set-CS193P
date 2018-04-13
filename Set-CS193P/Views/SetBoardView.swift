//
//  SetBoardView.swift
//  Set-CS193P
//
//  Created by Eduard Lev on 4/10/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    // MARK: View Properties

    /// Stores the Grid object for this view
    private var grid: Grid!

    /// Stores an array of custom subviews that corresponds to shown `Card` Objects
    var setCardSubviews = [SetCardView]() {
        didSet { setNeedsLayout() }
    }

    // MARK: View Methods

    /**
    * Removes all the card subviews from the larger Set Board View
    */
    private func removeSubviews() {
        self.subviews.forEach( { $0.removeFromSuperview() })
    }

    /**
    * Adds each card subview to the current view
    */
    private func addSetCardsToSubviews() {
        // Adds card subviews to the current view
        for setCardView in setCardSubviews { addSubview(setCardView) }
    }

    /**
    * Creates a Grid object based on `setCardSubviews`
    */
    private func createGridObject() {
        // See Grid Object - set layout to 5/8 aspect ratio
        // so that as many cards fit in the view as possible.
        let layout = Grid.Layout.aspectRatio(Constants.aspectRatio)
        grid = Grid(layout: layout, frame: bounds)
        // The # of cells in the grid = the number of cards to be shown
        grid.cellCount = setCardSubviews.count
    }

    /**
    * Adds the correct frame calculated by Grid to each `Card` Subview
    */
    private func addFramesToSubviews() {
        let (gridRows, gridColumns) = grid.dimensions
        // Iterate over the grid and set the frames of each view
        for row in 0...gridRows {
            for column in 0...gridColumns {
                if let frame = grid[row, column] {
                    setCardSubviews[row*gridColumns + column].frame = frame
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        removeSubviews()
        addSetCardsToSubviews()
        createGridObject()
        addFramesToSubviews()
    }
}

// MARK: Extensions

extension SetBoardView {
    private struct Constants {
        static let aspectRatio: CGFloat = 5/8
    }
}
