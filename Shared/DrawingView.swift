//
//  UIImageView.swift
//  Final Project - Ising Model
//
//  Created by Yoshinobu Fujikake on 4/10/22.
//

import SwiftUI

struct drawingView: View {
    
    @Binding var colors: [Color]
    @Binding var inputVector: [Int]
    @Binding var countOfRows: Int
    @Binding var simSteps: Int
    
    
    
    var body: some View {
    
        let colorDataPoints = ColorPoints()
        let colorizedDataPoints = colorDataPoints.vectorToColor(colorOption: colors,inputVector: inputVector, countOfRows: countOfRows, simSteps: simSteps)
        
        /*ZStack{
            ForEach(0..<colorizedDataPoints.count, id: \.self) { index in
                drawModel(drawingPoints: colorizedDataPoints[index] )
                    .fill(colorizedDataPoints[index].colorData)
            }
            
        }*/
        ZStack{
            drawModel(rows: countOfRows, simSteps: simSteps, drawingPoints: colorizedDataPoints.blackPoints)
                .fill(.black)
            drawModel(rows: countOfRows, simSteps: simSteps, drawingPoints: colorizedDataPoints.whitePoints)
                .fill(.white)
        }
        .background(Color.white)
        .aspectRatio(1, contentMode: .fill)
        
    }
}



struct drawModel: Shape {
    
   
    let smoothness : CGFloat = 1.0
    let rows: Int
    let simSteps: Int
    //var drawingPoints: (xPoint: Double, yPoint: Double, colorData: Color)
    var drawingPoints: [(xPoint: Double, yPoint: Double)]
    
    func path(in rect: CGRect) -> Path {
        
               
        // draw from the center of our rectangle
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let scale = rect.width/2
        

        // Create the Path for the display
        
        var path = Path()
        
        for item in drawingPoints {
            
        //path.addRect(CGRect(x: drawingPoints.xPoint*Double(scale)+Double(center.x), y: drawingPoints.yPoint*Double(scale)+Double(center.y), width: scale , height: scale))
            path.addRect(CGRect(x: item.xPoint*Double(scale)+Double(center.x), y: item.yPoint*Double(scale)+Double(center.y), width: 2*scale/CGFloat(simSteps) , height: 2*scale/CGFloat(rows)))
              
        }


        return (path)
    }
}


struct ColorPoints {

 /*   func vectorToColor(colorOption: [Color], inputVector: [Int], countOfRows: Int, simSteps: Int) -> [(xPoint: Double, yPoint: Double, colorData: Color)] {
        
        //print("Coloring data points...")
        let colorCount: Int = inputVector.count
        //print("\(colorCount)")
        var colorizedPoints: [(xPoint: Double, yPoint: Double, colorData: Color)] = Array(repeating: (xPoint: 0.0, yPoint: 0.0, colorData: .white), count: Int(colorCount))
        
        for i in 0..<colorCount {
            
            if inputVector[i] == 1 {
                
                colorizedPoints[i].colorData = colorOption[0]
                
            } else {
                
                colorizedPoints[i].colorData = colorOption[1]
                
            }
            
            colorizedPoints[i].xPoint = 2.0 * floor(Double(i)/Double(countOfRows)) / Double(simSteps) - 1.0
            colorizedPoints[i].yPoint = 2.0 * (Double(i)/Double(countOfRows) - floor(Double(i)/Double(countOfRows))) - 1.0
            
        }
        
        //print("Data points colored.")
        return colorizedPoints
    }*/
    
    func vectorToColor(colorOption: [Color], inputVector: [Int], countOfRows: Int, simSteps: Int) -> (blackPoints: [(xPoint: Double, yPoint: Double)], whitePoints: [(xPoint: Double, yPoint: Double)]) {
        
        //print("Coloring data points...")
        let colorCount: Int = inputVector.count
        //print("\(colorCount)")
        var colorizedPoints: (blackPoints: [(xPoint: Double, yPoint: Double)], whitePoints: [(xPoint: Double, yPoint: Double)]) = (blackPoints: [], whitePoints: [])
        var xPoint = 0.0
        var yPoint = 0.0
        
        for i in 0..<colorCount {
            
            xPoint = 2.0 * floor(Double(i)/Double(countOfRows)) / Double(simSteps) - 1.0
            yPoint = 2.0 * (Double(i)/Double(countOfRows) - floor(Double(i)/Double(countOfRows))) - 1.0
            
            if inputVector[i] == 1 {
                
                colorizedPoints.whitePoints.append( (xPoint: xPoint, yPoint: yPoint) )
                
            } else {
                
                colorizedPoints.blackPoints.append( (xPoint: xPoint, yPoint: yPoint) )
                
            }
            
            
        }
        
        //print("\(colorizedPoints)")
        return colorizedPoints
    }
    
    
}
