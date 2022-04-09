//
//  MetropolisAlgorithm.swift
//  Final Project - Ising Model
//
//  Created by Yoshinobu Fujikake on 4/9/22.
//

import Foundation

class MetropolisAlgorithm: ObservableObject {
    
    let exchangeEnergy = 0.0
    let kB = 8.617333262145e-5 // [eV/K]
    
    
    func updateSpinVector1D(tempurature: Double, numberOfAtoms: Int, spinVector: [Int]) -> [Int] {
        
        let spinFlipIndex = Int.random(in: 0..<numberOfAtoms)
        var trialSpinVector = spinVector
        var deltaConfigEnergy = 0.0
        var deltaSpinSum: Int = 0
        
        trialSpinVector[spinFlipIndex] = -spinVector[spinFlipIndex]
        
        // Only the differences between the pairs including the changed spin remain
        for i in spinFlipIndex-1...spinFlipIndex {
            deltaSpinSum += trialSpinVector[i%numberOfAtoms] * trialSpinVector[(i+1)%numberOfAtoms] - spinVector[i%numberOfAtoms] * spinVector[(i+1)%numberOfAtoms]
        }
        
        deltaConfigEnergy = -exchangeEnergy * Double(deltaSpinSum)
        
        if deltaConfigEnergy <= 0 { // accept
            
            return trialSpinVector
            
        } else { // accept or reject with probability r
            
            let relP = exp(-deltaConfigEnergy/(kB * tempurature))
            
            
            if relP >= Double.random(in: 0.0...1.0) { // accept
                
                return trialSpinVector
                
            } else { // reject
                
                return spinVector
                
            }
            
        }
        
    }
    
}
