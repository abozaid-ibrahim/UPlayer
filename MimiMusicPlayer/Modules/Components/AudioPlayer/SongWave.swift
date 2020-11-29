import UIKit.UIView

final class SongWave: UIView {
    
    var isActive = true
    var pulses: [Float] = []
    
    override func draw(_ rect: CGRect) {
        guard self.pulses.count > 0  else {
            return
        }

        let topPath = UIBezierPath()
        let bottomPath = UIBezierPath()
        let padding: CGFloat = 2.5
        let amplifier: CGFloat = self.frame.height
        topPath.lineWidth = 2.0
        bottomPath.lineWidth = 2.0
        topPath.move(to: CGPoint(x: 0.0 , y: rect.height/2))
        bottomPath.move(to: CGPoint(x: 0.0 , y: rect.height/2 + 1))
        
        if isActive {
            for pulse in self.pulses {
                self.drawTopPath(topPath, padding, pulse, amplifier)
                self.drawBottomPath(bottomPath, padding, pulse, amplifier)
            }
            
            UIColor.orange.set()
            topPath.stroke()
            topPath.fill()
            
            bottomPath.stroke(with: CGBlendMode.normal, alpha: 0.5)
            bottomPath.fill()
            
        } else {
            let rect = CGRect(x: rect.origin.x, y: rect.size.height/2 + 2, width: rect.size.width, height: 1)
            let path = UIBezierPath(rect: rect)
            UIColor.orange.set()
            path.stroke()
            path.fill()
        }
    }
    
    private func drawTopPath(_ topPath: UIBezierPath, _ padding: CGFloat, _ pulse: Float, _ amplifier: CGFloat) {
        topPath.move(to: CGPoint(x: topPath.currentPoint.x + padding, y: topPath.currentPoint.y))
        topPath.addLine(to: CGPoint(x: topPath.currentPoint.x, y: topPath.currentPoint.y - (CGFloat(pulse) * amplifier)))
        topPath.close()
    }
    
    private func drawBottomPath(_ bottomPath: UIBezierPath, _ padding: CGFloat, _ pulse: Float, _ amplifier: CGFloat) {
        bottomPath.move(to: CGPoint(x: bottomPath.currentPoint.x + padding, y: bottomPath.currentPoint.y))
        bottomPath.addLine(to: CGPoint(x: bottomPath.currentPoint.x, y: bottomPath.currentPoint.y - (-1 * CGFloat(pulse) * amplifier / 2)))
        bottomPath.close()
    }
}
