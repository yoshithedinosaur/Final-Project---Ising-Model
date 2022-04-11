//
//  ScatterPlot.swift
//  Final Project - Ising Model
//
//  Created by Yoshinobu Fujikake on 4/10/22.
//

import Foundation
import SwiftUI
import CorePlot

class ScatterPlot: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.01
    
    @MainActor func plotScatter(dataPoints: [Int]) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10.0
        plotDataModel!.changingPlotParameters.yMin = 0.0
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = "t"
        plotDataModel!.changingPlotParameters.yLabel = "x"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Potential Well"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append([.X: 0, .Y: 0]) //SOME DATA POINTS
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}
