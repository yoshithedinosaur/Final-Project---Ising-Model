//
//  ContentView.swift
//  Shared
//
//  Created by Yoshinobu Fujikake on 4/8/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    
    //var frame: CGRect
    
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
    
    var body: some View {
        
        VStack{
            
            HStack{
                
            }
        
        }
    
    }
    
    func generateInitialState(numberOfAtoms: Int, startState: String) -> [Int] {
        
        let spinVals: [Int] = [-1, 1]
        
        switch startState {
            
        case "Hot":
            let spinVector: [Int] = (0..<numberOfAtoms).map{ _ in spinVals.randomElement()!}
            return spinVector
            
        case "Cold":
            let spinVector = [Int](repeating: 1, count: numberOfAtoms)
            return spinVector
            
        default:
            print("This initial is state not supported. Defaulting to 'cold' start.")
            return [Int](repeating: 1, count: numberOfAtoms)
            
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
