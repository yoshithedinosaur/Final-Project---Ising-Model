//
//  WLSampling.swift
//  Final Project - Ising Model
//
//  Created by Yoshinobu Fujikake on 5/6/22.
//

import Foundation


class WLSampling: NSObject, ObservableObject {
    
    @Published var enableButton = true
    @Published var lnProbDensity: [Double] = []
    
    let matMan = MetropolisAlgorithm()
    let exchangeEnergy = 1.0
    //let kB = 8.617333262145e-5 // [eV/K]
    let kB = 1.0 //test value
    var hist: [Int : Int] = [:]
    
    
    func wangLandau(numberOfAtoms: Int, spinVector: [Int], fac: Double) -> [Int] {
        
        
        let spinFlipIndexRow = Int.random(in: 0..<numberOfAtoms)
        let spinFlipIndexCol = Int.random(in: 0..<numberOfAtoms)
        var deltaConfigEnergy: Int = 0
        var configEnergy: Int = 0
        var trialConfigEnergy: Int = 0
        var deltaSpinSum: Int = 0
        let spinMatrix = matMan.unpack2dArray(arr: spinVector, rows: numberOfAtoms, cols: numberOfAtoms)
        var trialSpinMatrix = spinMatrix
        
        // Flip a randomly chosen spin
        trialSpinMatrix[spinFlipIndexRow][spinFlipIndexCol] = -spinMatrix[spinFlipIndexRow][spinFlipIndexCol]
        
        
        // Only the differences between the pairs including the changed spin remain
        for i in spinFlipIndexRow-1...spinFlipIndexRow {
            deltaSpinSum += trialSpinMatrix[matMan.modulo(dividend: i, divisor: numberOfAtoms)][matMan.modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)] * trialSpinMatrix[matMan.modulo(dividend: i+1, divisor: numberOfAtoms)][matMan.modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)] - spinMatrix[matMan.modulo(dividend: i, divisor: numberOfAtoms)][matMan.modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)] * spinMatrix[matMan.modulo(dividend: i+1, divisor: numberOfAtoms)][matMan.modulo(dividend: spinFlipIndexCol, divisor: numberOfAtoms)]
        }
        
        for i in spinFlipIndexCol-1...spinFlipIndexCol {
            deltaSpinSum += trialSpinMatrix[matMan.modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][matMan.modulo(dividend: i, divisor: numberOfAtoms)] * trialSpinMatrix[matMan.modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][matMan.modulo(dividend: i+1, divisor: numberOfAtoms)] - spinMatrix[matMan.modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][matMan.modulo(dividend: i, divisor: numberOfAtoms)] * spinMatrix[matMan.modulo(dividend: spinFlipIndexRow, divisor: numberOfAtoms)][matMan.modulo(dividend: i+1, divisor: numberOfAtoms)]
        }
        
        
        let trialSpinVector = matMan.pack2dArray(arr: trialSpinMatrix, rows: numberOfAtoms, cols: numberOfAtoms)
        //print("\(spinVector)")
        //print("\(trialSpinVector)")
        
        deltaConfigEnergy = -Int(exchangeEnergy) * deltaSpinSum
        //print("\(deltaConfigEnergy)")
        
        //print(spinVector)
        // Calculate the energy of each configuration
        configEnergy = intEnergy(spinVector: spinVector, numberOfAtoms: numberOfAtoms)
        trialConfigEnergy = configEnergy + deltaConfigEnergy
        
        let configPD = lnProbDensity[probDensityIndex(intE: configEnergy, numberOfAtoms: numberOfAtoms)]
        let trConfigPD = lnProbDensity[probDensityIndex(intE: trialConfigEnergy, numberOfAtoms: numberOfAtoms)]
        
        
        if trConfigPD <= configPD { // accept
            
            //print("accepted at 1")
            lnProbDensity[probDensityIndex(intE: trialConfigEnergy, numberOfAtoms: numberOfAtoms)] += fac
            
            //print(lnProbDensity[probDensityIndex(intE: trialConfigEnergy, numberOfAtoms: numberOfAtoms)])
            
            hist[trialConfigEnergy]! += 1
            
            return trialSpinVector
            
        } else { // accept or reject with probability r
            
            //let relP = exp(-deltaConfigEnergy/(kB * tempurature))
            let relP = exp(configPD) - exp(trConfigPD) //kB*T=1 in units of J
            
            if relP >= Double.random(in: 0.0...1.0) { // accept
                
                //print("accepted at \(relP)")
                
                hist[trialConfigEnergy]! += 1
                
                lnProbDensity[probDensityIndex(intE: trialConfigEnergy, numberOfAtoms: numberOfAtoms)] += fac
                
                return trialSpinVector
                
            } else { // reject
                
                //print("rejected at \(relP)")
                
                hist[configEnergy]! += 1
                
                lnProbDensity[probDensityIndex(intE: configEnergy, numberOfAtoms: numberOfAtoms)] += fac
                
                return spinVector
                
            }
            
        }
        
    }
    
    
    
    func intEnergy(spinVector: [Int], numberOfAtoms: Int) -> Int {
        
        var intE: Int = 0
        
        for i in 0..<numberOfAtoms*numberOfAtoms {
            
            intE += spinVector[matMan.modulo(dividend: i, divisor: numberOfAtoms)] * spinVector[matMan.modulo(dividend: i+1, divisor: numberOfAtoms)]
            
        }
        
        //print("\(intE)")
        
        return -Int(exchangeEnergy) * intE
        
    }
    
    
    
    func probDensityIndex(intE: Int, numberOfAtoms: Int) -> Int {
        return (intE + 2 * Int(numberOfAtoms*numberOfAtoms)) / 4
    }
    
    
}
