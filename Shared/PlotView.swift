//
//  ScatterPlot.swift
//  Final Project - Ising Model
//
//  Created by Yoshinobu Fujikake on 4/10/22.
//

import Foundation
import SwiftUI
import CorePlot

class RatioPlot: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.01
    
    @MainActor func plotRatio(dataPoints: [(xPoint: Double, yPoint: Double)], xMax: Double) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 1.2
        plotDataModel!.changingPlotParameters.yMin = 0.0
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = -xMax/10
        plotDataModel!.changingPlotParameters.xLabel = "Time"
        plotDataModel!.changingPlotParameters.yLabel = "Ratio"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Up-to-Down Ratio vs Time step"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        print("\(dataPoints)")
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append([.X: dataPoints[i].xPoint, .Y: dataPoints[i].yPoint]) //SOME DATA POINTS
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}



class InternalEPlot: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.01
    
    @MainActor func plotInternalE(dataPoints: [(xPoint: Double, yPoint: Double)], xMax: Double) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 1.2
        plotDataModel!.changingPlotParameters.yMin = -0.1
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = -xMax/10
        plotDataModel!.changingPlotParameters.xLabel = "kB T"
        plotDataModel!.changingPlotParameters.yLabel = "U"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Internal Energy vs kB T"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        print("\(dataPoints)")
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append([.X: dataPoints[i].xPoint, .Y: dataPoints[i].yPoint]) //SOME DATA POINTS
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}



class MagPlot: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.01
    
    @MainActor func plotMagnetization(dataPoints: [(xPoint: Double, yPoint: Double)], xMax: Double) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 1.2
        plotDataModel!.changingPlotParameters.yMin = -0.1
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = -xMax/10
        plotDataModel!.changingPlotParameters.xLabel = "kB T"
        plotDataModel!.changingPlotParameters.yLabel = "M"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Magnetization vs kB T"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        //print("\(dataPoints)")
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append([.X: dataPoints[i].xPoint, .Y: dataPoints[i].yPoint]) //SOME DATA POINTS
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}


class FluctuationPlot: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.01
    
    @MainActor func plotFluctuation(dataPoints: [(xPoint: Double, yPoint: Double)], xMax: Double) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 1.2
        plotDataModel!.changingPlotParameters.yMin = -0.1
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = -xMax/10
        plotDataModel!.changingPlotParameters.xLabel = "kB T"
        plotDataModel!.changingPlotParameters.yLabel = "U2"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Fluctuation vs kB T"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        //print("\(dataPoints)")
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append([.X: dataPoints[i].xPoint, .Y: dataPoints[i].yPoint]) //SOME DATA POINTS
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}



class SpecificHeatPlot: ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    
    
    //temp parameter declaration
    let xMin = 0.0
    let xMax = 10.0
    let xStep = 0.01
    
    @MainActor func plotSpecificHeat(dataPoints: [(xPoint: Double, yPoint: Double)], xMax: Double) {
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 1.2
        plotDataModel!.changingPlotParameters.yMin = -0.1
        plotDataModel!.changingPlotParameters.xMax = xMax
        plotDataModel!.changingPlotParameters.xMin = -xMax/10
        plotDataModel!.changingPlotParameters.xLabel = "kB T"
        plotDataModel!.changingPlotParameters.yLabel = "C"
        plotDataModel!.changingPlotParameters.lineColor = .blue()
        plotDataModel!.changingPlotParameters.title = "Specific Heat vs kB T"
        
        plotDataModel!.zeroData()
        var plotData :[plotDataType] =  []
        
        //print("\(dataPoints)")
        
        for i in 0...dataPoints.endIndex-1 {
            plotData.append([.X: dataPoints[i].xPoint, .Y: dataPoints[i].yPoint]) //SOME DATA POINTS
        }
            
        plotDataModel!.appendData(dataPoint: plotData)
        
    }
}


