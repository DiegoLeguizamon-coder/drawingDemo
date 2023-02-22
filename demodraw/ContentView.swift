//
//  ContentView.swift
//  demodraw
//
//  Created by MacBook Pro on 15/02/23.
//

import SwiftUI

struct Line {
    var points:[CGPoint] = [CGPoint]()
    var color:Color = .red
    var lineWidth: Double = 1.0
    var shape: String = "line"
}

struct ContentView: View {
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State private var startPoint: CGPoint!
    @State private var endPoint: CGPoint!
    @State private var newShape: String = "line"
    @State private var newColor: Color = .red
    
    var imageDrawingView: some View {
        ZStack {
            Image("carro")
                    .resizable()
                    .frame(width: 400, height: 300)
            Canvas {context , size in
                
                for line in lines {
                    
                    switch line.shape {
                    case "arrow":
                        if endPoint != nil {
                            var path = Path()
                            let start = CGPoint(x: (Int.random(in: 1..<300)), y: (Int.random(in: 1..<350))) //startPoint! //
                            let end = CGPoint(x: Int.random(in: 1..<150), y: Int.random(in: 1..<300))  //endPoint! //
                            
                            print("---------------")
                            print("start \(start)")
                            print("end \(end)")
                            print("---------------")
                            
                            let arrowAngle = CGFloat(Double.pi / 8)
                            let pointerLineLength = CGFloat(15)
                            
                            let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
                            let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
                            let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
                            
                            path.move(to: start)
                            path.addLine(to: end)
                            
                            path.addLine(to: arrowLine1)
                            path.move(to: end)
                            path.addLine(to: arrowLine2)
                            path.addLines(line.points)
                            context.stroke(path, with: .color(line.color), lineWidth: 5.0)
                        }
                        break
                    default:
                        
                        //for line in lines {
                        var path = Path()
                        //path.addLine(to: line.points)
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                        //}
                    }
                }
            }
            .frame(width: 400, height: 300)
            .gesture(DragGesture()
                .onChanged({ value in
                    
                    if self.currentLine.points.count == 0 {
                        self.startPoint = value.location
                        print("startPoint \(startPoint)")
                    }
                    
                    self.currentLine.points.append(value.location)
                    self.currentLine.shape = newShape
                    self.currentLine.color = newColor
                    self.lines.append(currentLine)
                    
                    
                }).onEnded({ value in
                    self.currentLine = Line(points: [])
                    self.endPoint = value.location
                    print("endPoint \(endPoint)")
                })
            )
        }
    }
    //Borrar el cambas
    //self.lines.removeAll()
    
    
    var body: some View {
        VStack{
            imageDrawingView
            
            VStack {
                Button(action: {
                    self.newShape = "line"
                }, label: {
                    Text("Line").bold()
                })
                
                Button(action: {
                    self.newShape = "arrow"
                }, label: {
                    Text("Arrow").bold()
                })
                 
                Spacer()
                
                HStack {
                    Button(action: {
                        let high = imageDrawingView.asImage(size: CGSize(width: 400, height: 300))
                        print("Hola")
                    }, label: {
                        Text("Save").bold()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.lines.removeAll()
                    }, label: {
                        Text("Clear").bold()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.newColor = .green
                    }, label: {
                        Text("Green").bold()
                    })
                    
                    Button(action: {
                        self.newColor = .red
                    }, label: {
                        Text("Red").bold()
                    })
                    
                    Button(action: {
                        self.newColor = .blue
                    }, label: {
                        Text("Blue").bold()
                    })
                }
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIView {
    func asImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}
extension View {
    func asImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        let image = controller.view.asImage()
        return image
    }
}
