//
//  ViewController.swift
//  0x800
//
//  Created by Artur Kucaj on 14/01/15.
//  Copyright (c) 2015 Artur Kucaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreCount: UILabel!
    @IBOutlet weak var boardView: UIView!
    let bm = BoardModel.sharedInstance
    var rows = BoardModel.sharedInstance.rows
    let cols = BoardModel.sharedInstance.cols
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Register to receive a board releated notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRefreshBoard:", name: bm.refreshBoardNotif, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onGameOver:", name: bm.gameOverNotif, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Notifications
    func onRefreshBoard(notification: NSNotification){
        println("Received a notification \(notification.name)")
        refreshBoard()
    }
    
    func onGameOver(notification: NSNotification){
        println("Received a notification \(notification.name)")
        
        var alert = UIAlertController(title: "Oops", message: "Game over\nKeep trying. Good luck!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Ok logic here")
        }))
        presentViewController(alert, animated: true, completion: nil)
    }


    //MARK: - Buttons actions
    @IBAction func rightBttnTapped(sender: AnyObject) {
        println("RIGHT button")
        
        bm.moveRight()
    }

    @IBAction func leftBttnTapped(sender: AnyObject) {
        println("LEFT button")
        
        bm.moveLeft()
    }
    
    @IBAction func topBttnTapped(sender: AnyObject) {
        println("TOP button")
        
        bm.moveTop()
    }
    
    @IBAction func downBttnTapped(sender: AnyObject) {
        println("BOTTOM button")
        
        bm.moveBottom()
    }
    
    @IBAction func newGameBttnTapped(sender: AnyObject) {
        println("NEW game!")
        
        bm.clear()
    }
    
    
    //MARK: Board
    func refreshBoard() {
        for x in 1...cols {
            for y in 1...rows {
                let tile = getTileView(x:x, y:y)
                let label = getLabelFromView(tile!)
                var value = bm.valueFor(x:x, y:y)
                label?.text = value == 0 ? "" : String(value)
            }
        }
        scoreCount.text = String(bm.score)
    }
    
    
    //MARK: Access to each tile
    
    func getTileView(#x:Int, y:Int) ->UIView? {
        var tag = 10 * y + x
        return boardView.viewWithTag(tag)
    }
    
    func getLabelFromView(view:UIView) ->UILabel? {
        for v in view.subviews as [UIView] {
            if let label = v as? UILabel {
                return label
            }
        }
        return nil;
    }
    
}

