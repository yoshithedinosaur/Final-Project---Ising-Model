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
    
    @State private var isEditingAtoms = false
    @State private var isEditingSteps = false
    @State private var numberOfAtoms: Double = 16
    @State private var simulationStepsString = "10"
    @State private var startState = "Cold"
    @State private var finalState1D: [Int] = [Int](repeating: 1, count: 16) // dummy values
    @State var colorPalette: [Color] = [.black, .red]
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
                
                    drawingView(colors: $colorPalette, inputVector: $finalState1D, countOfRows: $countOfRows, simSteps: $viewSteps)
                        .aspectRatio(1, contentMode: .fit)
                        .drawingGroup()
                    //.frame(width: 500, height: 500)
                }
                
                Text("Time")
                
            }
            .padding()
            
            
            VStack{
                
                Slider(value: $numberOfAtoms,
                    in: 16...1024,
                    step: 16,
                    onEditingChanged: { editing in isEditingAtoms = editing },
                    minimumValueLabel: Text("16"),
                    maximumValueLabel: Text("1024"),
                    label: { Text("Number of atoms:") })
                
                Text("\(Int(numberOfAtoms))")
                    .foregroundColor(isEditingAtoms ? .red : .blue)
                
                Picker("Start condition", selection: $startState) {
                    ForEach(startStateSelect, id: \.self) {
                        Text($0)
                    }
                    
                }
                
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
            .padding()
        
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
        finalState1D.removeAll()
        
        finalState1D.append(contentsOf: spinVector)
        
        while currentStep < simSteps {
            
            spinVector = isingSim.updateSpinVector1D(tempurature: 1, numberOfAtoms: Int(numberOfAtoms), spinVector: spinVector)
            
            if currentStep%Int(max(1.0, stepsPerUpdate)) == 0 {
                
                finalState1D.append(contentsOf: spinVector)
                viewSteps += 1
            }
            
            currentStep += 1
            
            
        }
        print("Simulation finished with \(finalState1D.count) data points.")
        
        isingSim.setButtonEnable(state: true)
        
    }
    
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
