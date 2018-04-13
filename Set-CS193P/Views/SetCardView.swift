//
//  SetCardView.swift
//  Set-CS193P
//
//  Created by Eduard Lev on 4/10/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class SetCardView: UIView {

    // MARK: Public View Properties

    /// Publicly settable view number property
    @IBInspectable
    var number: Int = 0 { didSet {cardNumber = number + 1} }

    /// Publicy settable view symbol property
    @IBInspectable
    var symbol: Int = 0 { didSet {
        switch symbol {
            case 0: cardSymbol = .oval
            case 1: cardSymbol = .diamond
            case 2: cardSymbol = .squiggle
            default: break
            }
        }
    }

    /// Publicy settable view shading property
    @IBInspectable
    var shading: Int = 0 { didSet {
        switch shading {
            case 0: cardShading = .filled
            case 1: cardShading = .open
            case 2: cardShading = .striped
            default: break
        }
        }
    }

    /// Publicy settable view color property
    @IBInspectable
    var color: Int = 0 { didSet {
        switch color {
            case 0: cardColor = CardColor.pink
            case 1: cardColor = CardColor.purple
            case 2: cardColor = CardColor.green
            default: break
        }
        }
    }

    /// Publicaly gettable tuple of all the view properties
    var allProperties: (Int, Int, Int, Int) {
        return (number, symbol, shading, color)
    }

    // MARK: Private View Properties

    /// Private property that holds an array of the rects to draw shapes in
    private var shapeFrames = [CGRect]()

    /// Private view or `Card` number property
    private var cardNumber: Int!

    /// Private view or `Card` symbol property
    private var cardSymbol: CardSymbol!

    /// Private view or `Card` shading property
    private var cardShading: CardShading!

    /// Private view or `Card` color property
    private var cardColor: UIColor!

    var isSelected: Bool = false {
        didSet {
            self.layer.borderWidth = isSelected ? 2.0 : 0.0
        }
    }

    /// Optional Bool that keeps track of whether this card was in a match or not.
    /// Possible values are nil, true and false. Nil if the card was not attempted to be matched
    /// by the user, true if a user selected the match and false if the view was selected
    /// but is not involved in a match.
    var wasInvolvedInMatch: Bool? {
        didSet {
            if let wasInvolvedInMatch = wasInvolvedInMatch {
                self.layer.borderColor = wasInvolvedInMatch ?
                    UIColor.green.cgColor : UIColor.red.cgColor
            }
        }
    }

    // MARK: Drawing Methods

    // REFACTOR
    override func draw(_ rect: CGRect) {
        createWhiteRoundedRectangle()
        setUpPathSettings()
        determineRequiredFramesForSymbols()
        drawRequiredSymbols()

        // set up Border Properties
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = UIColor.blue.cgColor
    }

    // REFACTOR
    private func setUpPathSettings() {
        // set color
        cardColor.setFill()
        cardColor.setStroke()
    }

    // DEFINITELY REFACTOR THIS!
    private func determineRequiredFramesForSymbols() {
        let size = CGSize(width: shapeWidth, height: shapeHeight)
        shapeFrames.removeAll()

        switch cardNumber {
        case 1:
            let point = CGPoint(x: symbolXCoordinate, y: bounds.midY - shapeHeight/2)
            let rect = CGRect(origin: point, size: size)
            shapeFrames.append(rect)
        case 2:
            let point1 = CGPoint(x: symbolXCoordinate, y: bounds.midY - shapeSpacing/2 - shapeHeight*(3/2))
            let point2 = CGPoint(x: symbolXCoordinate, y: bounds.midY + shapeSpacing/2 + shapeHeight/2)
            let rect1 = CGRect(origin: point1, size: size)
            let rect2 = CGRect(origin: point2, size: size)
            shapeFrames.append(rect1)
            shapeFrames.append(rect2)
        case 3:
            let point1 = CGPoint(x: symbolXCoordinate, y: bounds.midY - shapeHeight/2)
            let point2 = CGPoint(x: symbolXCoordinate, y: bounds.midY - shapeHeight/2 - shapeSpacing - shapeHeight*2)
            let point3 = CGPoint(x: symbolXCoordinate, y: bounds.midY + shapeHeight*(3/2) + shapeSpacing)
            let rect1 = CGRect(origin: point1, size: size)
            let rect2 = CGRect(origin: point2, size: size)
            let rect3 = CGRect(origin: point3, size: size)
            shapeFrames.append(rect1)
            shapeFrames.append(rect2)
            shapeFrames.append(rect3)
        default: break
        }
    }

    /**
    Calls the required drawing functions depending on the views
    `cardSymbol` property
    */
    private func drawRequiredSymbols() {
        for frame in shapeFrames {
            switch cardSymbol {
            case .oval: drawOneOval(inRect: frame)
            case .diamond: drawOneDiamond(inRect: frame)
            case .squiggle: drawOneSquiggle(inRect: frame)
            default: break
            }
        }
    }

    /**
     Draws an oval in the requested frame
    */
    private func drawOneOval(inRect rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: bounds.height)
        path.stroke()
        createShading(withPath: path, inRect: rect)
    }

    /**
    Draws a diamond in the requested frame
     */
    private func drawOneDiamond(inRect rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX + shapeWidth/2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + shapeHeight/2))
        path.addLine(to: CGPoint(x: rect.minX + shapeWidth/2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + shapeHeight/2))
        path.close()
        path.stroke()
        createShading(withPath: path, inRect: rect)
    }

    /**
    Draws a squiggle in the requested frame
     */
    private func drawOneSquiggle(inRect rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX - shapeWidth/3, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - shapeWidth/8, y: rect.minY),
                          controlPoint: CGPoint(x: rect.midX, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.maxX - shapeWidth/8, y: rect.minY + shapeHeight),
                          controlPoint1: CGPoint(x: rect.maxX + shapeWidth/8, y: rect.minY),
                          controlPoint2: CGPoint(x: rect.maxX + shapeWidth/8, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.midX - shapeWidth/3, y: rect.minY + shapeHeight),
                          controlPoint1: CGPoint(x: rect.midX, y: rect.midY + shapeHeight/4),
                          controlPoint2: CGPoint(x: rect.midX, y: rect.midY + shapeHeight/4))
        path.addCurve(to: CGPoint(x: rect.midX - shapeWidth/3, y: rect.minY),
                      controlPoint1: CGPoint(x: rect.minX - shapeWidth/8, y: rect.maxY),
                      controlPoint2: CGPoint(x: rect.minX - shapeWidth/8, y: rect.minY))
        path.close()
        path.stroke()
        createShading(withPath: path, inRect: rect)
    }

    /**
     Adds required shading to a graphics contexts. Creates shading only in the path
     that is passed in
    */
    private func createShading(withPath path: UIBezierPath, inRect rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        switch cardShading {
            case .filled: path.fill()
            case .open: break
            case .striped: createStripes(withRect: rect)
        default: break
        }
        context?.restoreGState()
    }

    /**
     Adds stripes to a rect, with clipping.
     Adjust the # of stripes by updating NumberOfStripesInRect property
     */
    private func createStripes(withRect rect: CGRect) {
        let stripe = UIBezierPath()
        stripe.lineWidth = 1.0
        stripe.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        stripe.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        for _ in 1...Int(numberOfStripesInRect) {
            let translation =
                CGAffineTransform(translationX: bounds.size.width/numberOfStripesInRect, y: 0)
            stripe.apply(translation)
            stripe.stroke()
        }
    }

    /**
    Creates a white rounded rectangle that clips the view drawing bounds
    */
    private func createWhiteRoundedRectangle() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        //roundedRect.addClip() // rest of drawing will be inside this bounds
        UIColor.white.setFill()
        roundedRect.fill()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
    }
}

extension SetCardView {
    /// Stores the ratio between the height of the card and the corner Radius
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let shapeHeightToBoundsHeight: CGFloat = 1/4
        static let shapeWidthToBoundsWidth: CGFloat = 3/4
    }

    /// Calculated value of corner radius based on the bounds height & ratio
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }

    /// Calculated value of the shape height in one Card
    private var shapeHeight: CGFloat {
        return bounds.size.height * SizeRatio.shapeHeightToBoundsHeight
    }

    /// Calculated value of the shape width in one Card
    private var shapeWidth: CGFloat {
        return bounds.size.width * SizeRatio.shapeWidthToBoundsWidth
    }

    /// Calculated value of the spacing between shapes
    private var shapeSpacing: CGFloat {
        return ((1 - 3*shapeHeight))/4
    }

    /// Determines the number of stripes visible in a symbol
    private var numberOfStripesInRect: CGFloat {
        return 30
    }

    private var symbolXCoordinate: CGFloat {
        return bounds.midX - shapeWidth/2
    }

    // MARK: Private Enumerations

    /// Stores the possible values for this views symbol property
    private enum CardSymbol: Int {
        case oval = 0
        case diamond
        case squiggle
    }

    /// Stores the possible values for this views shading property
    private enum CardShading: Int {
        case filled = 0
        case open
        case striped
    }

    /// Stores the possible values for this views color property
    private enum CardColor {
        static let pink = UIColor(red: 251/255, green: 23/255, blue: 133/255, alpha: 1.0)
        static let purple = UIColor.purple
        static let green = UIColor.green
    }
}
