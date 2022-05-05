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
    
    
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
    
    @ObservedObject private var scatterPlotModel = ScatterPlot()
    @State private var isEditingAtoms = false
    @State private var isEditingSteps = false
    @State private var numberOfAtoms: Double = 100
    @State private var simulationStepsString = "1000"
    @State private var startState = "Cold"
    @State private var finalState1D: [Int] = [Int](repeating: 1, count: 16) // dummy values
    @State private var temperatureString = "1.2"
    @State private var magnetizationString = ""
    @State private var internalEString = ""
    @State var colorPalette: [Color] = [.yellow, .blue]
    @State var simSteps: Int = 0
    @State var countOfRows: Int = 16
    @State var startStateSelect = ["Hot", "Cold"]
    @State var stepsPerUpdate: Double = 1.0
    @State var viewSteps: Int = 0
    
    let isingSim = MetropolisAlgorithm()
    
    
    var body: some View {
        
        HStack{
            
            VStack{
                
                Text("1D Ising Model")
                
                HStack{
                
                    Text("Position")
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 50, height: 500)
                
                    drawingView(colors: $colorPalette, inputVector: $finalState1D, countOfRows: $countOfRows, simSteps: $viewSteps)
                        .aspectRatio(1, contentMode: .fit)
                        .drawingGroup()
                        .blur(radius: 0)
                        .frame(width: 500, height: 500)
                }
                
                Text("Time")
                
            }
            .padding()
            
            
            VStack{
                
                HStack{
                    
                    VStack{
                        CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                            .setPlotPadding(left: 10)
                            .setPlotPadding(right: 10)
                            .setPlotPadding(top: 10)
                            .setPlotPadding(bottom: 10)
                            .frame(width: 400, height: 300)
                            .padding()
                    }
                    
                    VStack{
                        
                        HStack{
                        
                            Text("Magnetization:")
                            .frame(width: 100)
                            TextField("Magnetization", text: $magnetizationString)
                            .frame(width: 50)
                        
                        }
                    
                        HStack{
                        
                            Text("Internal Energy:")
                            .frame(width: 100)
                            TextField("Energy", text: $internalEString)
                            .frame(width: 50)
                        
                        }
                        
                    }
                    
                }
                
                Divider()
                
                VStack{
                    
                    Slider(value: $numberOfAtoms,
                       in: 10...200,
                       step: 10,
                       onEditingChanged: { editing in isEditingAtoms = editing },
                       minimumValueLabel: Text("10"),
                       maximumValueLabel: Text("200"),
                       label: { Text("Number of atoms:") })
                
                    Text("\(Int(numberOfAtoms))")
                    .foregroundColor(isEditingAtoms ? .red : .blue)
                
                    Picker("Start condition", selection: $startState) {
                        ForEach(startStateSelect, id: \.self) {
                        Text($0)
                        }
                    
                    }
                
                    Text("Temperature")
                    TextField("Temperature", text: $temperatureString)
                
                    Text("Simulation steps")
                    TextField("Steps", text: $simulationStepsString)
                
                    let sliderMaxVal = max(2.0, (Double(simulationStepsString) ?? 1)/2.0)

                
                    Slider(value: $stepsPerUpdate,
                       in: 0.0...sliderMaxVal,
                       step: max(1.0, pow(10, (log10(Double(simulationStepsString) ?? 1.0))-2.0)),
                       onEditingChanged: { editing in isEditingSteps = editing },
                       minimumValueLabel: Text("1"),
                       maximumValueLabel: Text("\(sliderMaxVal)"),
                       label: { Text("Steps between outputs:") })
                
                    Text("\(max(1.0,stepsPerUpdate))")
                        .foregroundColor(isEditingSteps ? .red : .blue)
                
                    Button("Simulate", action: { Task.init { await self.ising1D() } } )
                        .padding()
                        .frame(width: 200.0)
                        .disabled(isingSim.enableButton == false)
                    
                }

            }
            .padding()
            
            //Text("Note to self: Still need to add the statisitcs graphs and temperature.")
        
        }
    
    }
    
    func generateInitialState(numberOfAtoms: Int, startState: String) -> [Int] {
        
        let spinVals: [Int] = [-1, 1]
        
        switch startState {
            
        case "Hot":
            let spinVector: [Int] = (0..<numberOfAtoms).map{ _ in spinVals.randomElement()!}
            return spinVector
            
        case "Cold":
            let spinVector = [Int](repeating: -1, count: numberOfAtoms)
            return spinVector
            
        default:
            print("This initial is state not supported. Defaulting to 'cold' start.")
            return [Int](repeating: 1, count: numberOfAtoms)
            
        }
        
        
    }
    
    
    @MainActor func ising1D() async {
        
        print("Starting simulation...")
        
        isingSim.setButtonEnable(state: false)
        
       
        simSteps = Int(simulationStepsString) ?? 1
        countOfRows = Int(numberOfAtoms)
        viewSteps = 1
        
        var spinVector = generateInitialState(numberOfAtoms: Int(numberOfAtoms), startState: startState)
        var currentStep: Int = 0
        var plottingPoints: [(xPoint: Double, yPoint: Double)] = []
        
        var mappedItems = spinVector.map{ ( $0, 1.0 ) }
        var countedItems = Dictionary(mappedItems, uniquingKeysWith: +)
        
        plottingPoints.append( ( xPoint: Double(viewSteps), yPoint: countedItems[-1]! / Double(countOfRows) ) )
        
        finalState1D.removeAll()
        
        finalState1D.append(contentsOf: spinVector)
        
        while currentStep < simSteps {
            
            spinVector = isingSim.updateSpinVector1D(tempurature: Double(temperatureString) ?? 0, numberOfAtoms: Int(numberOfAtoms), spinVector: spinVector)
            
            if currentStep%Int(max(1.0, stepsPerUpdate)) == 0 {
                
                finalState1D.append(contentsOf: spinVector)
                viewSteps += 1
                
                
                mappedItems = spinVector.map{ ( $0, 1 ) }
                countedItems = Dictionary(mappedItems, uniquingKeysWith: +)
                plottingPoints.append( ( xPoint: Double(viewSteps), yPoint: countedItems[-1]! / Double(countOfRows) ) )
                
            }
            
            currentStep += 1
            
            
        }
        
        internalEString = "\(calculateInternalE(spinVector: spinVector))"
        
        magnetizationString = "\(Double(countOfRows) - 2.0 * countedItems[-1]! )"
        
        scatterPlotModel.plotDataModel = self.plotDataModel
        scatterPlotModel.plotScatter(dataPoints: plottingPoints, xMax: Double(simSteps))
        
        print("Simulation finished with \(finalState1D.count) data points.")
        
        isingSim.setButtonEnable(state: true)
        
    }
    
    
    func calculateInternalE (spinVector: [Int]) -> Double {
        
        var totE: Int = 0
        var internalE = 0.0
        
        for spinIndex in 0..<spinVector.count {
                
            totE += spinVector[isingSim.modulo(dividend: spinIndex, divisor: Int(numberOfAtoms))] * spinVector[isingSim.modulo(dividend: spinIndex+1, divisor: Int(numberOfAtoms))]
            
        }
        
        internalE = -isingSim.exchangeEnergy * Double(totE) / Double(spinVector.count)
        
        return internalE
        
    }
    
    
    func calculateSpecificHeat() -> Double {
        var specificHeat = 0.0
        
        return specificHeat
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
