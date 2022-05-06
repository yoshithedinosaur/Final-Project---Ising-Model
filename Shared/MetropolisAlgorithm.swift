//
//  MetropolisAlgorithm.swift
//  Final Project - Ising Model
//
//  Created by Yoshinobu Fujikake on 4/9/22.
//

import Foundation

class MetropolisAlgorithm: NSObject, ObservableObject {
    
    @Published var enableButton = true

    
    let exchangeEnergy = 1.0
    //let kB = 8.617333262145e-5 // [eV/K]
    let kB = 1.0 //test value
    
    func updateSpinVector1D(tempurature: Double, numberOfAtoms: Int, spinVector: [Int]) -> [Int] {
        
        let spinFlipIndex = Int.random(in: 0..<numberOfAtoms)
        var trialSpinVector = spinVector
        var deltaConfigEnergy = 0.0
        var deltaSpinSum: Int = 0
        
        // Flip a randomly chosen spin
        trialSpinVector[spinFlipIndex] = -spinVector[spinFlipIndex]
        
        // Only the differences between the pairs including the changed spin remain
        for i in spinFlipIndex-1...spinFlipIndex {
            deltaSpinSum += trialSpinVector[modulo(dividend: i, divisor: numberOfAtoms)] * trialSpinVector[modulo(dividend: i+1, divisor: numberOfAtoms)] - spinVector[modulo(dividend: i, divisor: numberOfAtoms)] * spinVector[modulo(dividend: i+1, divisor: numberOfAtoms)]
        }
        //print("\(spinVector)")
        //print("\(trialSpinVector)")
        
        deltaConfigEnergy = -exchangeEnergy * Double(deltaSpinSum)
        //print("\(deltaConfigEnergy)")
        
        if deltaConfigEnergy <= 0 { // accept
            
            //print("accepted at 1")
            return trialSpinVector
            
        } else { // accept or reject with probability r
            
            //let relP = exp(-deltaConfigEnergy/(kB * tempurature))
            let relP = exp(-deltaConfigEnergy/(kB * tempurature)) //kB*T=1 in units of J
            
            if relP >= Double.random(in: 0.0...1.0) { // accept
                
                //print("accepted at \(relP)")
                return trialSpinVector
                
            } else { // reject
                
                //print("rejected at \(relP)")
                return spinVector
                
            }
            
        }
        
    }
    
    func updateSpinVector2D(tempurature: Double, numberOfAtoms: Int, spinVector: [Int]) -> [Int] {
        
        let spinFlipIndexRow = Int.random(in: 0..<numberOfAtoms)
        let spinFlipIndexCol = Int.random(in: 0..<numberOfAtoms)
        var deltaConfigEnergy = 0.0
        var deltaSpinSum: Int = 0
        let spinMatrix = unpack2dArray(arr: spinVector, rows: numberOfAtoms, cols: numberOfAtoms)
        var trialSpinMatrix = spinMatrix
        
        // Flip a randomly chosen spin
        trialSpinMatrix[spinFlipIndexRow][spinFlipIndexCol] = -spinMatrix[spinFlipIndexRow][spinFlipIndexCol]
        
        // Only the differences between the pairs including the changed spin remain
        for i in spinFlipIndexRow-1...spinFlipIndexRow {
            deltaSpinSum += trialSpinMatrix[modulo(dividend: i, divisor: numberOfAtoms)][modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)] * trialSpinMatrix[modulo(dividend: i+1, divisor: numberOfAtoms)][modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)] - spinMatrix[modulo(dividend: i, divisor: numberOfAtoms)][modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)] * spinMatrix[modulo(dividend: i+1, divisor: numberOfAtoms)][modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)]
        }
        
        for i in spinFlipIndexCol-1...spinFlipIndexCol {
            deltaSpinSum += trialSpinMatrix[modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][modulo(dividend: i, divisor: numberOfAtoms)] * trialSpinMatrix[modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][modulo(dividend: i+1, divisor: numberOfAtoms)] - spinMatrix[modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][modulo(dividend: i, divisor: numberOfAtoms)] * spinMatrix[modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][modulo(dividend: i+1, divisor: numberOfAtoms)]
        }
        
        let trialSpinVector = pack2dArray(arr: trialSpinMatrix, rows: numberOfAtoms, cols: numberOfAtoms)
        //print("\(spinVector)")
        //print("\(trialSpinVector)")
        
        deltaConfigEnergy = -exchangeEnergy * Double(deltaSpinSum)
        //print("\(deltaConfigEnergy)")
        
        if deltaConfigEnergy <= 0 { // accept
            
            //print("accepted at 1")
            return trialSpinVector
            
        } else { // accept or reject with probability r
            
            //let relP = exp(-deltaConfigEnergy/(kB * tempurature))
            let relP = exp(-deltaConfigEnergy/(kB * tempurature)) //kB*T=1 in units of J
            
            if relP >= Double.random(in: 0.0...1.0) { // accept
                
                //print("accepted at \(relP)")
                return trialSpinVector
                
            } else { // reject
                
                //print("rejected at \(relP)")
                return spinVector
                
            }
            
        }
        
    }
    
    
    
    /// pack2DArray
    /// Converts a 2D array into a linear array
    ///
    /// - Parameters:
    ///   - arr: 2D array
    ///   - rows: Number of Rows
    ///   - cols: Number of Columns
    /// - Returns: Row Major Linear Array
    func pack2dArray(arr: [[Int]], rows: Int, cols: Int) -> [Int] {
        var resultArray = Array(repeating: Int(0), count: rows*cols)
        for Iy in 0...cols-1 {
            for Ix in 0...rows-1 {
                let index = Iy * rows + Ix
                resultArray[index] = arr[Iy][Ix]
            }
        }
        return resultArray
    }
    
    /// unpack2DArray
    /// Converts a linear array to a 2D array in Row Major Format
    ///
    /// - Parameters:
    ///   - arr: Row Major Linear Array
    ///   - rows: Number of Rows
    ///   - cols: Number of Columns
    /// - Returns: 2D array
    func unpack2dArray(arr: [Int], rows: Int, cols: Int) -> [[Int]] {
        var resultArray = [[Int]](repeating:[Int](repeating: Int(0) ,count:rows), count:cols)
        for Iy in 0...cols-1 {
            for Ix in 0...rows-1 {
                let index = Iy * rows + Ix
                resultArray[Iy][Ix] = arr[index]
            }
        }
        return resultArray
    }
    
    
    
    
    ///modulo: swift is stupid and '%' sign is NOT modulo, but means remainder so now I have to make own damn modulo function because the folks at apple thought they were too quirky to make '%' work the right way
    ///parameters: divident, divisor
    ///return: modulo of dividend and divisor
    func modulo(dividend: Int, divisor: Int) -> Int {
        let val = dividend - Int(floor((Double(dividend)/Double(divisor)))) * (divisor)
        //print("\(val)")
        return val
    }
    
    
    /// setButton Enable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        
        
        if state {
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = true
                }
            }
            
            
                
        }
        else{
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = false
                }
            }
                
        }
        
    }
    
}
