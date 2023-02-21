//
//  ContentView.swift
//  demodraw
//
//  Created by MacBook Pro on 15/02/23.
//

import SwiftUI

struct MyColor: Codable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(uiColor: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    var uiColor: UIColor { UIColor(red: red, green: green, blue: blue, alpha: alpha) }
}

struct Arrow: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()

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

        return path
    }
}



struct Line: Codable {
    var points:[CGPoint] = [CGPoint]()
    var color:Color = .red
    var lineWidth: Double = 1.0
    var shape: String = "arrow"
    
    
    init(points: [CGPoint], color: Color, lineWidth: Double, shape: String) {
            self.points = points
            self.color = color
            self.lineWidth = lineWidth
            self.shape = shape
        }
    
    enum CodingKeys: String, CodingKey {
           case points
           case color
           case lineWidth
           case shape
       }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            points = try values.decode([CGPoint].self, forKey: .points)
            
            //let uiColor = try values.decode(UIColor.self, forKey: .color)
            //color = Color(uiColor)
            
            lineWidth = try values.decode(Double.self, forKey: .lineWidth)
            shape = try values.decode(String.self, forKey: .shape)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(points, forKey: .points)
            //try container.encode(color.uiColor, forKey: .color)
            try container.encode(lineWidth, forKey: .lineWidth)
            try container.encode(shape, forKey: .shape)
        }
}

struct ContentView: View {
    
    @State private var currentLine = Line(points:[], color: .red, lineWidth: 1.0, shape: "line" )
    @State private var lines: [Line] = []
    @State private var startPoint: CGPoint!
    @State private var endPoint: CGPoint!
    @State private var newShape: String = "arrow"
    @State private var newColor: UIColor = .red
    @State private var isDrawing = false
    
    
    func saveLines(_ lines: [Line]) {
        let data = try! JSONEncoder().encode(lines)
        UserDefaults.standard.set(data, forKey: "arrow")
    }

    func loadLines(from data: Data? = nil) -> [Line] {
        
        guard let data = data ?? UserDefaults.standard.data(forKey: "arrow") else {
               return []
        }
       
        return try! JSONDecoder().decode([Line].self, from: data)
    }
    
    
    var imageDrawingView: some View {
    
        ZStack {
            Image("carro")
                    .resizable()
                    .frame(width: 400, height: 300)
            
            Canvas {context , size in
               
                for line in lines {
                    
                    switch line.shape {
                    case "arrow":
             
                        var path = Arrow(start: line.points.first ?? .zero, end: line.points.last ?? .zero).path(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                                    
//                        path = path.strokedPath(StrokeStyle(lineWidth: CGFloat(line.lineWidth), lineCap: .round, lineJoin: .round))
                                    
                                
                                    context.stroke(path, with:  .color(line.color))
                        
//                        if endPoint != nil {
                   
//                            var path = Path()
//                            let start = CGPoint(x: (Int.random(in: 1..<300)), y: (Int.random(in: 1..<350))) //startPoint! //
//                            let end = CGPoint(x: Int.random(in: 1..<150), y: Int.random(in: 1..<300))  //endPoint! //
//
//                            print("---------------")
//                            print("start \(start)")
//                            print("end \(end)")
//                            print("---------------")
//
//                            let arrowAngle = CGFloat(Double.pi / 8)
//                            let pointerLineLength = CGFloat(15)
//
//                            let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
//                            let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
//                            let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

                            //path.move(to: start)
//                            path.addLine(to: end)

//                            path.addLine(to: arrowLine1)
//                            path.move(to: end)
//                            path.addLine(to: arrowLine2)
//                            path.addLines(line.points)
//                            context.stroke(path, with: .color(line.color), lineWidth: 5.0)
                            
                            
//                        }
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
                    isDrawing = true
                        startPoint = value.startLocation
                        endPoint = value.location
                    if self.currentLine.points.count == 0 {
                        self.startPoint = value.location
                        print("startPoint \(startPoint)")
                    }
                    
                    self.currentLine.points.append(value.location)
                    self.currentLine.shape = newShape
                    self.currentLine.color = .red
                    self.lines.append(currentLine)
                    saveLines(lines)
                    
                    
                }).onEnded({ value in
                    self.currentLine = Line(points:[], color: .red, lineWidth: 1.0, shape: "line")
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
                        self.newColor =  .red
                    }, label: {
                        Text("Red").bold()
                    })
                    
                    Button(action: {
                        self.newColor =  .blue
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






