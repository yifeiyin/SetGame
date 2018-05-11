//
//  SetGameViewController.swift
//  Set
//
//  Created by YinYifei on 2018-05-10.
//  Copyright © 2018 Yifei Yin. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {

    var game = SetGame()
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var DealThreeMoreCardsButton: UIButton!
    @IBAction func DealThreeMoreCardsButtonPressed(_ sender: UIButton) {
        game.DealThreeMoreCards()
        UpdateViewFromModel()
    }
    
    @IBAction func cardButtonPressed(_ sender: UIButton) {
        game.SelectCard(at: cardButtons.index(of: sender)!)
        UpdateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateViewFromModel()
    }
    
    
    func UpdateViewFromModel() {
        
        // cardButtons
        let hiddenBGColor = UIColor.white
        let visbleBGColor = UIColor.white
        let hiddenBroaderColor = UIColor.clear.cgColor
        let visbleBroaderColor = UIColor.gray.cgColor
        let selectedBroaderColor = UIColor.blue.cgColor
        let matchBroaderColor = UIColor.green.cgColor
        let mismatchBroaderColor = UIColor.red.cgColor
        
        
        // TODO: Redo this part, add look up Dictionary for cardButtons -> game.tablecards
        for index in cardButtons.indices {
            if index < game.tableCards.count {
                cardButtons[index].layer.borderWidth = 3.0
                cardButtons[index].layer.cornerRadius = 8.0
                cardButtons[index].layer.borderColor = visbleBroaderColor
                cardButtons[index].backgroundColor = visbleBGColor
                
                if game.indicesOfCardsSelected.contains(index) {
                    if game.matchingStatus == .match {
                        cardButtons[index].layer.borderColor = matchBroaderColor
                    } else if game.matchingStatus == .mismatch {
                        cardButtons[index].layer.borderColor = mismatchBroaderColor
                    } else {
                        cardButtons[index].layer.borderColor = selectedBroaderColor
                    }
                }
                
                cardButtons[index].setAttributedTitle(GetAttributedTitle(forIndexOf: index), for: .normal)
            } else {
                
                cardButtons[index].backgroundColor = hiddenBGColor
                cardButtons[index].layer.borderColor = hiddenBroaderColor
                
                cardButtons[index].setAttributedTitle(nil, for: .normal)
                cardButtons[index].setTitle(nil, for: .normal)
            }
        }
        
        // TODO: DealThreeMoreCardsButton - disable/enable
        // TODO: Add end game detection stuff
    }
    
    func GetAttributedTitle(forIndexOf index: Int) -> NSAttributedString {
        
        let card = game.tableCards[index]
//        var card = SetCard(number: .a, color: .a, symbol: .a, shading: .a)
//
//        switch index {
//        case 0: card = SetCard(number: .a, color: .a, symbol: .a, shading: .a)
//        case 1: card = SetCard(number: .b, color: .a, symbol: .a, shading: .a)
//        case 2: card = SetCard(number: .c, color: .a, symbol: .a, shading: .a)
//        case 3: card = SetCard(number: .a, color: .b, symbol: .a, shading: .a)
//        case 4: card = SetCard(number: .a, color: .c, symbol: .a, shading: .a)
//        case 5: card = SetCard(number: .a, color: .a, symbol: .b, shading: .a)
//        case 6: card = SetCard(number: .a, color: .a, symbol: .c, shading: .a)
//        case 7: card = SetCard(number: .a, color: .a, symbol: .a, shading: .b)
//        case 8: card = SetCard(number: .a, color: .a, symbol: .a, shading: .c)
//        case 9: card = SetCard(number: .a, color: .b, symbol: .c, shading: .a)
//        case 10: card = SetCard(number: .a, color: .a, symbol: .b, shading: .c)
//        case 11: card = SetCard(number: .a, color: .a, symbol: .c, shading: .b)
//        case 12: card = SetCard(number: .a, color: .c, symbol: .a, shading: .b)
//        case 13: card = SetCard(number: .c, color: .a, symbol: .b, shading: .a)
//        case 14: card = SetCard(number: .b, color: .b, symbol: .c, shading: .c)
//        case 15: card = SetCard(number: .a, color: .a, symbol: .a, shading: .a)
//        case 16: card = SetCard(number: .a, color: .a, symbol: .a, shading: .a)
//        case 17: card = SetCard(number: .a, color: .a, symbol: .a, shading: .a)
//        case 18: card = SetCard(number: .a, color: .a, symbol: .a, shading: .a)
//        default:
//            card = SetCard(number: .c, color: .c, symbol: .c, shading: .c)
//        }
        
        let symbols = [SetCard.Property.a: "▲", .b: "●", .c: "■" ]
        let numbers = [SetCard.Property.a: 1, .b: 2, .c: 3 ]
        
        let strokeWidths = [SetCard.Property.a: -5.0, .b: -5.0, .c: 5.0 ]
        let strokeColors = [SetCard.Property.a: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), .b: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), .c: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        let foregroundColors = [SetCard.Property.a: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), .b: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), .c: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
        let foregroundColorAlphas = [SetCard.Property.a: CGFloat(0.2), .b: 0.5, .c: 1.0]
        
        var string = ""
        for _ in 0..<numbers[card.number]! {
            string.append(symbols[card.symbol]!)
        }
        
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(35.0)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let strokeWidth = strokeWidths[card.shading]!
        let strokeColor = strokeColors[card.color]!
        let foregroundColor = foregroundColors[card.color]!.withAlphaComponent(foregroundColorAlphas[card.shading]!)
//        let ps = NSMutableParagraphStyle()
//        ps.alignment = .center
//        ps.lineBreakMode = .byCharWrapping
//        ps.paragraphSpacing = 0.1
//        ps.lineSpacing = 0.1
        
        return NSAttributedString(string: string,
                                  attributes: [.font: font,
                                               .strokeWidth: strokeWidth,
                                               .strokeColor: strokeColor,
                                               .foregroundColor: foregroundColor,
                                               // .paragraphStyle: ps
                                               ])
        
    }
}
