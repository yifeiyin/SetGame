//
//  SetGameViewController.swift
//  Set
//
//  Created by YinYifei on 2018-05-10.
//  Copyright © 2018 Yifei Yin. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {

    var game = SetGame() { didSet { cardDictionary.removeAll() }}
    
    @IBOutlet var cardButtons: [UIButton]!
    var cardDictionary = [UIButton: SetCard]()
    
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!
    @IBAction func DealThreeMoreCardsButtonPressed(_ sender: UIButton) {
        game.DealThreeMoreCards()
        UpdateViewFromModel()
    }
    
    @IBAction func CardButtonPressed(_ sender: UIButton) {
        if let card = cardDictionary[sender] {
            game.SelectCard(card: card)
            UpdateViewFromModel()
        }
    }
    
    @IBOutlet weak var utilityButton: UIButton!
    @IBAction func UtilityButtonPressed(_ sender: UIButton) {
        game.ShowHint()
        UpdateViewFromModel()
    }
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func MenuButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowPauseMenuSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPauseMenuSegue" {
            let pauseMenuVC = segue.destination as! PauseMenuViewController
            pauseMenuVC.label1Text = String(game.newCards.count) + " cards remaining"
            pauseMenuVC.label2Text = String(game.discardedCards.count / 3) + " sets collected (\(game.discardedCards.count*100/81)%)"
            pauseMenuVC.label3Text = String(game.numberOfSetsOnTable) + " possible sets on table"
            pauseMenuVC.goBackButtonEnbled = true
            
            pauseMenuVC.completion = { [unowned self] ( newGame ) in
                if newGame != nil {
                    self.game = newGame!
                    self.timeCounter = 0
                }
                self.isTimeCounterEnbled = true
                self.UpdateViewFromModel()
            }
        } else if segue.identifier == "GameCompleteMenuSegue" {
            let pauseMenuVC = segue.destination as! PauseMenuViewController
            pauseMenuVC.label1Text = "Game Complete!"
            pauseMenuVC.label2Text = timeCounterString + " time consumed"
            pauseMenuVC.label3Text = String(game.discardedCards.count / 3) + " sets collected (\(game.discardedCards.count*100/81)%)"
            
            pauseMenuVC.goBackButtonEnbled = false
            pauseMenuVC.completion = { [unowned self] ( newGame ) in
                if newGame != nil {
                    self.game = newGame!
                    self.timeCounter = 0
                }
                self.isTimeCounterEnbled = true
                self.UpdateViewFromModel()
            }
        }
    }
    
    var timer: Timer!
    var isTimeCounterEnbled = true
    var timeCounter = TimeInterval(0)
    var timeCounterString: String {
        var seconds = String(Int((self.timeCounter.truncatingRemainder(dividingBy: 60)).rounded(.down)))
        let minutes = String(Int((self.timeCounter / 60).rounded(.down)))
        if seconds.count == 1 {
            seconds = "0" + seconds
        }
        return minutes + ":" + seconds
    }
    
    override func viewDidLoad() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: _updateTimeCounter)
        super.viewDidLoad()
        UpdateViewFromModel()
    }
    
    lazy var _updateTimeCounter = { [unowned self] (Timer: Timer) in
        if self.isTimeCounterEnbled {
            self.timeCounter += 1
            
            let title = self.timeCounterString
            UIButton.performWithoutAnimation {
                self.utilityButton.setTitle(title, for: .normal)
                self.utilityButton.layoutIfNeeded()
            }
        }
    }
    
    func UpdateViewFromModel() {
        
        var localTableCards = game.tableCards
        cardButtons.forEach { button in
            if let correspondingCard = cardDictionary[button] {
                if let correspondingCardIndexInLocalTableCards = localTableCards.index(of: correspondingCard) {
                    localTableCards.remove(at: correspondingCardIndexInLocalTableCards)
                } else {
                    cardDictionary[button] = nil
                }
            }
        }
        localTableCards.forEach { spareCard in
            let spareButtons = cardButtons.filter { cardDictionary[$0] == nil }
            assert(spareButtons.count > 0)
            cardDictionary[spareButtons[0]] = spareCard
            localTableCards.remove(at: localTableCards.index(of: spareCard)!)
        }
        assert(localTableCards.count == 0)
        
        
        cardButtons.forEach { button in
            let card = cardDictionary[button]
            if card == nil {
                ConfigureButton(for: button, is: .hidden)
            } else {
                var buttonState = ButtonState.unselected
                if game.selectedCards.contains(card!) {
                    buttonState = .normallySelected
                    if game.matchingStatus == .match {
                        buttonState = .match
                    } else if game.matchingStatus == .mismatch {
                        buttonState = .mismatch
                    }
                }
                ConfigureButton(for: button, is: buttonState, content: GetAttributedTitle(for: card!))
            }
        }
        
        dealThreeMoreCardsButton.isEnabled = game.isAbleToDealThreeMoreCards
        
        if game.isGameCompleted {
            performSegue(withIdentifier: "GameCompleteMenuSegue", sender: nil)
        }
    }
    
    private enum ButtonState {
        case hidden
        case unselected
        case normallySelected
        case match
        case mismatch
    }
    
    private func ConfigureButton(for button: UIButton, is state: ButtonState, content attributedTitle: NSAttributedString? = nil) {
        
        let hiddenBGColor = UIColor.white
        let hiddenBroaderColor = UIColor.clear.cgColor
        
        let visbleBGColor = UIColor.white
        let visbleBroaderColor = UIColor.gray.cgColor
        
        let selectedBroaderColor = UIColor.blue.cgColor
        let matchBroaderColor = UIColor.green.cgColor
        let mismatchBroaderColor = UIColor.red.cgColor
        
        if state == .hidden {
            button.backgroundColor = hiddenBGColor
            button.layer.borderColor = hiddenBroaderColor
            
            button.setAttributedTitle(nil, for: .normal)
            button.setTitle(nil, for: .normal)
        } else {
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.backgroundColor = visbleBGColor

            switch state {
            case .match: button.layer.borderColor = matchBroaderColor
            case .mismatch: button.layer.borderColor = mismatchBroaderColor
            case .normallySelected: button.layer.borderColor = selectedBroaderColor
            case .unselected: button.layer.borderColor = visbleBroaderColor
            default: fatalError()
            }
            button.layer.borderWidth = 3.0
            button.layer.cornerRadius = 8.0
        }
    }
    
    private func GetAttributedTitle(for card: SetCard) -> NSAttributedString {
        let symbols = [SetCard.Property.a: "▲", .b: "●", .c: "■" ]
        let numbers = [SetCard.Property.a: 1, .b: 2, .c: 3 ]
    
        let strokeWidths = [SetCard.Property.a: -5.0, .b: -0.0, .c: 7.0 ]
        let strokeColors = [SetCard.Property.a: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), .b: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), .c: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        let foregroundColors = [SetCard.Property.a: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), .b: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), .c: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
        let foregroundColorAlphas = [SetCard.Property.a: CGFloat(0.2), .b: 1.0, .c: 1.0]
        
        var string = ""
        for _ in 0..<numbers[card.number]! {
            string.append(symbols[card.symbol]!)
        }
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(30.0)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let strokeWidth = strokeWidths[card.shading]!
        let strokeColor = strokeColors[card.color]!
        let foregroundColor = foregroundColors[card.color]!.withAlphaComponent(foregroundColorAlphas[card.shading]!)
        let ps = NSMutableParagraphStyle()
        ps.alignment = .center
        ps.lineBreakMode = .byCharWrapping
        ps.paragraphSpacing = 0.1
        ps.lineSpacing = 0.1
        
        return NSAttributedString(string: string,
                                  attributes: [.font: font,
                                               .strokeWidth: strokeWidth,
                                               .strokeColor: strokeColor,
                                               .foregroundColor: foregroundColor,
                                               .paragraphStyle: ps
                                               ])
        
    }
}
