//
//  Model.swift
//  0x800
//
//  Created by Artur Kucaj on 14/01/15.
//  Copyright (c) 2015 Artur Kucaj. All rights reserved.
//

import Foundation

class BoardModel {
    
    private var values: [[Int]] =  [[0, 0, 0, 0],
                                    [0, 0, 0, 0],
                                    [0, 0, 0, 0],
                                    [0, 0, 0, 0]]
    
    let cols:Int = 4
    let rows:Int = 4
    let refreshBoardNotif = "REFRESH_BOARD"
    let gameOverNotif = "GAME_OVER"
    var score:Int = 0
    
    // Singleton - shared instance
    class var sharedInstance : BoardModel {
        struct Static {
            static let instance : BoardModel = BoardModel()
        }
        return Static.instance
    }
    
    func clear() {
        score = 0
        for i in 0...cols-1 {
            for j in 0...rows-1 {
                values[i][j] = 0
            }
        }
        draw()
        draw()
        NSNotificationCenter.defaultCenter().postNotificationName(refreshBoardNotif, object: nil)
    }
    
    func valueFor(#x:Int, y:Int) ->Int {
        return values[x-1][y-1]
    }
    
    // Draw a coordinate pointing to empty tile and put there a value "2"
    func draw() {
        let count = getEmptyFieldsNumber()
        if (count > 0) {
            // draw the matrix index
            var index = Int(arc4random_uniform(UInt32(count)))
            for i in 0...cols-1 {
                for j in 0...rows-1 {
                    if values[i][j] == 0 {
                        if (index-- <= 0) {
                            // enter initial value
                            println("count=\(count), index=\(index), i=\(i), j=\(j)")
                            values[i][j] = 2;
                            return;
                        }
                    }
                }
            }
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(gameOverNotif, object: nil)
        }
    }
    
    func getEmptyFieldsNumber() ->Int {
        var count = 0
        for i in 0...cols-1 {
            for j in 0...rows-1 {
                if values[i][j] == 0 {
                    count++
                }
            }
        }
        return count
    }
    
    //MARK: Moving
    
    func moveLeft() {
        for var j=0; j<rows; j++ {
            var data: [Int] = []
            // copy
            for var i=0; i<cols; i++ {
                data.append(values[i][j])
            }
            data = shift(data);
            // restore
            for var i=0; i<cols; i++ {
                values[i][j] = data[i]
            }
        }
        draw()
        NSNotificationCenter.defaultCenter().postNotificationName(refreshBoardNotif, object: nil)
    }
    
    func moveRight() {
        for var j=0; j<rows; j++ {
            var data: [Int] = []
            // copy
            for var i=0; i<cols; i++ {
                data.append(values[cols-i-1][j])
            }
            data = shift(data);
            // restore
            for var i=0; i<cols; i++ {
                values[i][j] = data[cols-i-1]
            }
        }
        draw()
        NSNotificationCenter.defaultCenter().postNotificationName(refreshBoardNotif, object: nil)
    }
    
    func moveTop() {
        for var i=0; i<cols; i++ {
            var data: [Int] = []
            // copy
            for var j=0; j<rows; j++ {
                data.append(values[i][j])
            }
            data = shift(data);
            // restore
            for var j=0; j<rows; j++ {
                values[i][j] = data[j]
            }
        }
        draw()
        NSNotificationCenter.defaultCenter().postNotificationName(refreshBoardNotif, object: nil)
    }
    
    func moveBottom() {
        for var i=0; i<cols; i++ {
            var data: [Int] = []
            // copy
            for var j=0; j<rows; j++ {
                data.append(values[i][rows-j-1])
            }
            data = shift(data);
            // restore
            for var j=0; j<rows; j++ {
                values[i][j] = data[rows-j-1]
            }
        }
        draw()
        NSNotificationCenter.defaultCenter().postNotificationName(refreshBoardNotif, object: nil)
    }
    
    
    //MARK: Private
    private func shift(var data: [Int]) ->[Int] {
        var result: [Int] = []
        let size = data.count
        // loop
        var loop = true
        while loop {
            loop = false
            // shrink tiles
            data = shrink(data)
            // merge tiles with same values
            for var k=0; k<data.count-1; k++ {
                if data[k] == data[k+1] {
                    data[k] *= 2
                    data[k+1] = 0
                    loop = true
                    score += data[k]
                }
            }
        }
        // now, return back the shifted data
        for i in 0...size-1 {
            if (i < data.count) {
                result.append(data[i])
            } else {
                result.append(0)
            }
        }
        return result
    }
    
    private func shrink(data: [Int]) ->[Int] {
        var result: [Int] = []
        for value in data {
            if value != 0 {
                result.append(value)
            }
        }
        return result
    }
}

