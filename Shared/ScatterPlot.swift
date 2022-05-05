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
    
    @MainActor func plotScatter(dataPoints: [(xPoint: Double, yPoint: Double)], xMax: Double) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 1.0
        plotDataModel!.changingPlotParameters.yMin = 0.0
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = xMin
        plotDataModel!.changingPlotParameters.xLabel = "Temperature"
        plotDataModel!.changingPlotParameters.yLabel = "Domain Size"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Some plot"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        print("\(dataPoints)")
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append([.X: dataPoints[i].xPoint, .Y: dataPoints[i].yPoint]) //SOME DATA POINTS
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}
