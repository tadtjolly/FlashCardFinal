//
//  DeckDetailViewController.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 4/29/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import SwipeCellKit

class DeckDetailViewController: UIViewController {
    
    //MARK: UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countTerm: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    var menuView : BTNavigationDropdownMenu!
    
    //MARK: Local variable
    var isInsert = false
    var deck:Deck!
    var selectedDeckIndex = 0
    var UID = ""
    
    //height for table view cell
    let cellSpacingHeight: CGFloat = 5
    
    //MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        for (index,d) in decks.enumerated() {
            if d.identifier == deck.identifier {
                selectedDeckIndex = index
            }
        }
        
        countTerm.text = "\(deck.cards.count) Terms"
        
        // Do any additional setup after loading the view.
        let decksName = decks.map{ $0.name }
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.141602397, green: 0.8048137426, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: deck.name, items: decksName as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = #colorLiteral(red: 0.141602397, green: 0.8048137426, blue: 1, alpha: 1)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
            self.selectedDeckIndex = indexPath
//            // [START custom_event_swift]
//            guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//            guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck Detail", action: "Switch to other Deck", label: nil, value: nil) else { return }
//            tracker.send(event.build() as [NSObject : AnyObject])
//            // [END custom_event_swift]
            
            print("Did select item at index: \(indexPath)")
            
            let temp = decks[indexPath]
            print(temp)
            self.deck = decks[indexPath]
            
            print("-------")
            //print(self.cardt.count)
            
            //            print(decks)

            self.countTerm.text = "\(self.deck.cards.count)"
            self.tableView.reloadData()
            
            self.selectedDeckIndex = indexPath
        }
        
        self.navigationItem.titleView = menuView
        self.navigationController?.navigationBar.tintColor = UIColor.white;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UI Event
    
    @IBAction func editTapped(_ sender: AnyObject) {
//        // [START custom_event_swift]
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Deck Detail", action: "Switch to Edit Deck", label: nil, value: nil) else { return }
//        tracker.send(event.build() as [NSObject : AnyObject])
//        // [END custom_event_swift]
        
        print("Edit tapped")
        let viewController = DeckDetailAddEditViewController.instantiateFrom(appStoryboard: .DeckDetail)
        viewController.cardt = deck.cards
        viewController.UID = UID
        viewController.deck = decks[selectedDeckIndex]
        viewController.delegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func PlayGame1Button(_ sender: Any) {
        print("playgame")
        let viewController = Game1ViewController.instantiateFrom(appStoryboard: .ScreenGame1)
        viewController.deck = deck
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func PlayStackGameButton(_ sender: UIButton) {
        let viewController = GameStackViewController.instantiateFrom(appStoryboard: .GameStack)
        viewController.originalCards = deck.cards
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeckDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = deck.cards[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckDetailViewControllerTableViewCell", for: indexPath) as! DeckDetailViewControllerTableViewCell
        cell.delegate = self
        
        cell.setMark(card.marked, animated: false)
        
        cell.termLabel.text = card.term
        cell.definition.text = card.definition
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension DeckDetailViewController: DeckDetailAddEditViewControllerDelegate {
    func didEndEdit(deck: Deck) {
        self.deck = deck
        decks[selectedDeckIndex] = deck
        tableView.reloadData()
        
        //navigationController?.popViewController(animated: true)
    }
}

extension DeckDetailViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let card = deck.cards[indexPath.row]
        
        if orientation == .left {
            // Làm edit
            return nil
        }
        else {
            let markAction = SwipeAction(style: .default, title: nil, handler: { (action, indexPath) in
                let card = self.deck.cards[indexPath.row]
                card.marked = !card.marked
                
                let cell = tableView.cellForRow(at: indexPath) as! DeckDetailViewControllerTableViewCell
                cell.setMark(card.marked, animated: true)
                
            })
            
            markAction.hidesWhenSelected = true
            markAction.accessibilityLabel = card.marked ? "Unmark" : "Mark"
            
            let descriptor: ActionDescriptor = card.marked ? .unmark : .mark
            configure(action: markAction,with: descriptor)
            
            return [markAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        options.buttonSpacing = 11
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
    }
}

enum ActionDescriptor {
    case edit, mark, unmark
    
    func title() -> String {
        switch self {
        case .edit: return "Edit"
        case .mark: return "Mark"
        case .unmark: return "Unmark"
        }
    }
    
    func image() -> UIImage? {
        let name: String
        
        switch self {
        case .edit: name = "Edit"
        case .mark, .unmark: name = "Unmark"
        }
        
        return UIImage(named: name)
    }
    
    var color: UIColor {
    switch self {
    case .mark, .unmark: return #colorLiteral(red: 1, green: 0.8319787979, blue: 0, alpha: 1)
    case .edit : return #colorLiteral(red: 0, green: 0.732499063, blue: 0.9509658217, alpha: 1)
    }
    }
}
