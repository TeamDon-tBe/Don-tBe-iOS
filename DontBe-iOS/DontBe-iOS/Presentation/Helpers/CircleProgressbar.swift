//
//  CircleProgressbar.swift
//  DontBe-iOS
//
//  Created by 변상우 on 1/9/24.
//

import UIKit

final class CircleProgressbar: UIView {
    
    var lineWidth: CGFloat = 2
    var circleBackgroundColor: UIColor = .gray
    var circleTintColor: UIColor = .black
    
    var value: Double? {
        didSet {
            guard let _ = value else { return }
            setProgress(self.bounds)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()

        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX - ((lineWidth - 1) / 2), startAngle: 0, endAngle: .pi * 2, clockwise: true)

        bezierPath.lineWidth = lineWidth
        circleBackgroundColor.set()
        bezierPath.stroke()
    }
    
    func setProgress(_ rect: CGRect) {
        guard let value = self.value else {
            return
        }
        
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let bezierPath = UIBezierPath()

        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX - ((lineWidth - 1) / 2), startAngle: -.pi / 2, endAngle: ((.pi * 2) * value) - (.pi / 2), clockwise: true)

        let shapeLayer = CAShapeLayer()

        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineCap = .square

        shapeLayer.strokeColor = circleTintColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth

        self.layer.addSublayer(shapeLayer)
    }
}

