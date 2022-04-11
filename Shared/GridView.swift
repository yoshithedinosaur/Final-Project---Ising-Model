//
//  TileView.swift
//  Final Project - Ising Model
//
//  Created by Yoshinobu Fujikake on 4/8/22.
//
/*
import Foundation
import SwiftUI

//Initiating scrollview is slow -> need faster method
struct GridView: View {
    //let colors: [Color]
    //let inputVector: [Int]
    //let count: CGFloat
    
    @Binding var colors: [Color]
    @Binding var inputVector: [Int]
    @Binding var count: CGFloat
    @Binding var simSteps: Int
    
    
    var body: some View {
        
        let colorVectors = ColorVectors()
        let colorizedVectors = colorVectors.vectorToColor(inputVector: inputVector)
        
        ScrollView(.horizontal) {
            LazyHGrid(rows: colorVectors.getRows(count: count), spacing: 0) {
                ForEach(0..<(Int(count)*(simSteps)), id: \.self) { index in
                    colorizedVectors[index]
                        .frame(width: 500/count)
                }
            }
        }
        .frame(width: 500, height: 500)
        .background(Color.white)
    }
    
}

struct ColorVectors {

    func vectorToColor(inputVector: [Int]) -> [Color] {
        
        print("Coloring vector...")
        let colorCount: Int = inputVector.count
        //print("\(colorCount)")
        var colorizedVector: [Color] = Array(repeating: .white, count: Int(colorCount))
        
        for i in 0..<colorCount {
            
            if inputVector[i] == 1 {
                
                colorizedVector[i] = .white
                
            } else {
                
                colorizedVector[i] = .black
                
            }
            
        }
        
        print("Vector colored.")
        return colorizedVector
    }
    

    func getRows(count: CGFloat) -> [GridItem] {
        return Array(repeating: GridItem(.flexible(minimum: 0, maximum: 500), spacing: 0), count: Int(count))
    }
    
}


struct GridView_Preview: PreviewProvider {
    static var previews: some View {
        GridView(colors: [.red, .blue], inputVector: (0..<20).map{ _ in [-1, 1].randomElement()!}, count: 20)
    }
}*/
