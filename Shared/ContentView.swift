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
    
    @ObservedObject private var ratioPlotModel = RatioPlot()
    @ObservedObject private var intEPlotModel = InternalEPlot()
    @ObservedObject private var magPlotModel = MagPlot()
    @ObservedObject private var u2PlotModel = FluctuationPlot()
    @ObservedObject private var specHeatPlotModel = SpecificHeatPlot()
    @State private var isEditingAtoms = false
    @State private var isEditingSteps = false
    @State private var numberOfAtoms: Double = 100
    @State private var simulationStepsString = "1000"
    @State private var startState = "Cold"
    @State private var finalState1D: [Int] = [Int](repeating: 1, count: 100) // dummy values
    @State private var finalState2D: [Int] = [Int](repeating: 1, count: 100) // dummy values
    @State private var finalState: [Int] = [Int](repeating: 1, count: 100) // dummy values
    @State private var temperatureString = "1.2"
    @State private var magnetizationString = ""
    @State private var internalEString = ""
    @State private var specificHeatString = ""
    @State var colorPalette: [Color] = [.yellow, .blue]
    @State var simSteps: Int = 0
    @State var countOfRows: Int = 16
    @State var startStateSelect = ["Hot", "Cold"]
    @State var stepsPerUpdate: Double = 1.0
    @State var viewSteps: Int = 0
    @State var specHeatDisableButton = false
    @State var plotDisableButton = false
    @State var hasButtonBeenPressed = false
    @State var is1D = true
    @State var viewString = "1D Ising Model"
    
    let isingSim = MetropolisAlgorithm()
    
    
    var body: some View {
        
        HStack{
            
            VStack{
                
                //Text("1D Ising Model")
                
                Button(viewString, action: { Task.init { await self.switchViews() } } )
                        .padding()
                        .frame(width: 200.0)
                
                HStack{
                
                    if is1D {Text("Position")
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 80, height: 500)
                    } else {Text("Position (Y)")
                            .rotationEffect(Angle(degrees: -90))
                            .frame(width: 80, height: 500)
                        }
                    
                    
                
                    drawingView(colors: $colorPalette, inputVector: $finalState, countOfRows: $countOfRows, simSteps: $viewSteps)
                        .aspectRatio(1, contentMode: .fit)
                        .drawingGroup()
                        .blur(radius: 0)
                        .frame(width: 500, height: 500)
                }
                
                if is1D {Text("Time")} else {Text("Position (X)")}
                
            }
            .padding()
            
            
            VStack{
                
                HStack{
                    
                    HStack{
                        CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                            .setPlotPadding(left: 10)
                            .setPlotPadding(right: 10)
                            .setPlotPadding(top: 10)
                            .setPlotPadding(bottom: 10)
                            .frame(width: 400, height: 300)
                            .padding()
                        
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
                            /*
                            HStack{
                            
                                Text("Specific Heat:")
                                .frame(width: 100)
                                TextField("Specific Heat", text: $specificHeatString)
                                .frame(width: 50)
                            
                            }
                            
                            Text("Currently not correct")
                            
                            Button("Find Specific Heat", action: { Task.init { await self.calculateSpecificHeat(numTrials: 50) } } )
                                .padding()
                                .frame(width: 150)
                                .disabled(specHeatDisableButton)
                            */
                            
                            Button("Plot U vs kB T", action: { Task.init { await self.plotFunc(numTrials: 50, plotType: "UvsT") } } )
                                .frame(width: 120, height: 30)
                                .disabled(plotDisableButton)
                            
                            Button("Plot M vs kB T", action: { Task.init { await self.plotFunc(numTrials: 50, plotType: "MvsT") } } )
                                .frame(width: 120, height: 30)
                                .disabled(plotDisableButton)

                            Button("Plot U2 vs kB T", action: { Task.init { await self.plotFunc(numTrials: 50, plotType: "U2vsT") } } )
                                .frame(width: 120, height: 30)
                                .disabled(plotDisableButton)
                            
                            Button("Plot C vs kB T", action: { Task.init { await self.plotFunc(numTrials: 50, plotType: "CvsT") } } )
                                .frame(width: 120, height: 30)
                                .disabled(plotDisableButton)
                            
                        }
                        
                    }
            
                    
                }
                
                Divider()
                
                VStack{
                    
                    Slider(value: $numberOfAtoms,
                       in: 100...2000,
                       step: 100,
                       onEditingChanged: { editing in isEditingAtoms = editing },
                       minimumValueLabel: Text("100"),
                       maximumValueLabel: Text("2000"),
                       label: { Text("Number of atoms:") })
                
                    Text("\(Int(numberOfAtoms))")
                    .foregroundColor(isEditingAtoms ? .red : .blue)
                
                    HStack{
                        
                        Picker("Start condition", selection: $startState) {
                            ForEach(startStateSelect, id: \.self) {
                            Text($0)
                            }
                    
                        }
                        .frame(width: 200)
                        
                        
                        Text("Temperature")
                        TextField("Temperature", text: $temperatureString)
                            .frame(width: 50)
                
                        Text("Simulation steps")
                        TextField("Steps", text: $simulationStepsString)
                            .frame(width: 50)
                        
                    }
                    
                    let sliderMaxVal = max(2.0, (Double(simulationStepsString) ?? 1)/10.0)

                
                    Slider(value: $stepsPerUpdate,
                       in: 0.0...sliderMaxVal,
                       step: max(1.0, pow(10, (log10(Double(simulationStepsString) ?? 1.0))-2.0)),
                       onEditingChanged: { editing in isEditingSteps = editing },
                       minimumValueLabel: Text("1"),
                       maximumValueLabel: Text("\(sliderMaxVal)"),
                       label: { Text("Steps between outputs:") })
                
                    Text("\(max(1.0,stepsPerUpdate))")
                        .foregroundColor(isEditingSteps ? .red : .blue)
                
                    if is1D {
                    Button("Simulate 1D", action: { Task.init { await self.ising1D() } } )
                        .padding()
                        .frame(width: 200.0)
                        .disabled(isingSim.enableButton == false)
                    } else {
                        Button("Simulate 2D", action: { Task.init { await self.ising2D() } } )
                            .padding()
                            .frame(width: 200.0)
                            .disabled(isingSim.enableButton == false)
                    }
                    
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
        
        internalEnergyvsT.removeAll()
        magnetizationvsT.removeAll()
        fluctuationvsT.removeAll()
        specificHeatvsT.removeAll()
        hasButtonBeenPressed = false
        
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
                plottingPoints.append( ( xPoint: Double(viewSteps) * Double(stepsPerUpdate), yPoint: countedItems[-1]! / Double(countOfRows) ) )
                
            }
            
            currentStep += 1
            
            
        }
        
        internalEString = "\(calculateInternalE(spinVector: spinVector))"
        
        magnetizationString = "\(Double(countOfRows) - 2.0 * countedItems[-1]! )"
        
        ratioPlotModel.plotDataModel = self.plotDataModel
        ratioPlotModel.plotRatio(dataPoints: plottingPoints, xMax: Double(simSteps))
        
    
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
    
    
    @MainActor func calculateSpecificHeat(numTrials: Int) async {
        var specificHeat = 0.0
        var avgIntE = 0.0
        var avgIntE2 = 0.0
        var numerator = 0.0
        var denominator = 1.0
        
        specHeatDisableButton = true
        
        simSteps = Int(simulationStepsString) ?? 1
        countOfRows = Int(numberOfAtoms)
        viewSteps = 1
        
        for _ in 0..<numTrials {
        
            var spinVector = generateInitialState(numberOfAtoms: Int(numberOfAtoms), startState: startState)
            var currentStep: Int = 0
                    
            
        
            var state1D: [Int] = []
        
            
            while currentStep < simSteps {
            
                spinVector = isingSim.updateSpinVector1D(tempurature: Double(temperatureString) ?? 0, numberOfAtoms: Int(numberOfAtoms), spinVector: spinVector)
            
                if currentStep == simSteps-1 {
                
                    state1D = spinVector
                    viewSteps += 1
                
                }
            
                currentStep += 1
            
            }
            
            avgIntE += Double(countOfRows) * calculateInternalE(spinVector: state1D)
            
            avgIntE2 += pow( Double(countOfRows) * calculateInternalE(spinVector: state1D), 2 )
            
        }
        
        avgIntE = avgIntE / Double(numTrials)
        //avgIntE = Double(internalEString) ?? 0.0
        //print("\(avgIntE)")
        
        avgIntE2 = avgIntE2 / Double(numTrials)
        //print("\(avgIntE2)")
        
        numerator = avgIntE2 - pow(avgIntE, 2)
        
        denominator = pow(Double(countOfRows), 2) * pow(Double(temperatureString) ?? 1.0, 2) * isingSim.kB
        
        specificHeat = numerator / denominator
        
        specificHeatString = "\(specificHeat)"
        
        specHeatDisableButton = false
        
    }
    
    
    @State var internalEnergyvsT: [(xPoint: Double, yPoint: Double)] = []
    @State var magnetizationvsT: [(xPoint: Double, yPoint: Double)] = []
    @State var fluctuationvsT: [(xPoint: Double, yPoint: Double)] = []
    @State var specificHeatvsT: [(xPoint: Double, yPoint: Double)] = []
    
    @MainActor func plotFunc(numTrials: Int, plotType: String) async {
        
        
        var currentIntE = 0.0
        var currentMag = 0.0
        var currentFluc = 0.0
        var specificHeat = 0.0

        
        plotDisableButton = true
        
        simSteps = Int(simulationStepsString) ?? 1
        countOfRows = Int(numberOfAtoms)
        viewSteps = 1
        
        if !hasButtonBeenPressed {
        for kBtemperature in stride(from: 0.0, through: 5.0, by: 0.1) {
        
            
            currentIntE = 0.0
            currentMag = 0.0
            currentFluc = 0.0
            
            for _ in 0..<numTrials {
                
                var spinVector = generateInitialState(numberOfAtoms: Int(numberOfAtoms), startState: startState)
                var currentStep: Int = 0
                    
                var mappedItems = spinVector.map{ ( $0, 1.0 ) }
                var countedItems = Dictionary(mappedItems, uniquingKeysWith: +)
        
                var state1D: [Int] = []
        
            
                while currentStep < simSteps {
            
                    
                    spinVector = isingSim.updateSpinVector1D(tempurature: kBtemperature/isingSim.kB, numberOfAtoms: Int(numberOfAtoms), spinVector: spinVector)
            
                    if currentStep == simSteps-1 {
                
                        state1D = spinVector
                        viewSteps += 1
                
                        currentIntE += calculateInternalE(spinVector: state1D) + 1.0
                        
                        mappedItems = spinVector.map{ ( $0, 1 ) }
                        countedItems = Dictionary(mappedItems, uniquingKeysWith: +)
                        
                        currentMag += Double(countOfRows) - 2.0 * countedItems[-1]!
                        
                        currentFluc += pow(/*Double(countOfRows) */ (calculateInternalE(spinVector: state1D) + 1.0), 2)
                        
                    }
            
                    currentStep += 1
                    
                    
                }
            
            }
            
            specificHeat = -(currentFluc -  pow(currentIntE, 2)) / ( Double(numTrials) * /*pow(Double(countOfRows), 2) */ pow(kBtemperature, 2) / isingSim.kB )
            
            internalEnergyvsT.append( (xPoint: kBtemperature, yPoint: currentIntE/Double(numTrials)) )
            
            magnetizationvsT.append( (xPoint: kBtemperature, yPoint: abs(currentMag/Double(numTrials))/Double(countOfRows)) )
            
            fluctuationvsT.append( (xPoint: kBtemperature, yPoint: currentFluc/Double(numTrials)) )
            
            specificHeatvsT.append( (xPoint: kBtemperature, yPoint: specificHeat) )
            
        }
        }
        
        hasButtonBeenPressed = true
        
        switch plotType {
        case "UvsT":
            
            intEPlotModel.plotDataModel = self.plotDataModel
            
            intEPlotModel.plotInternalE(dataPoints: internalEnergyvsT, xMax: 5.0)
            
            plotDisableButton = false
            
        case "MvsT":
            
            magPlotModel.plotDataModel = self.plotDataModel
            
            magPlotModel.plotMagnetization(dataPoints: magnetizationvsT, xMax: 5.0)
            
            plotDisableButton = false
        
        case "U2vsT":
            
            u2PlotModel.plotDataModel = self.plotDataModel
            
            u2PlotModel.plotFluctuation(dataPoints: fluctuationvsT, xMax: 5.0)
            
            plotDisableButton = false
            
        case "CvsT":
            
            specHeatPlotModel.plotDataModel = self.plotDataModel
            
            specHeatPlotModel.plotSpecificHeat(dataPoints: specificHeatvsT, xMax: 5.0)
            
            plotDisableButton = false
            
        default:
            print("Not supported plot.")
        }
        
    }
    
    
    @MainActor func switchViews() async {
        
        if is1D {
            viewString = "2D Ising Model"
            is1D = false
            finalState = finalState2D
        } else {
            viewString = "1D Ising Model"
            is1D = true
            finalState = finalState1D
        }
        
    }
    
    
    @MainActor func ising2D() async {
    
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
