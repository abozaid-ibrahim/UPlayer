import AVFoundation
import Foundation.NSURL
import Accelerate

protocol SongPlusesGenerator {
    var url: URL { get }
    func generatePulses() -> [Float]
}

extension SongPlusesGenerator {
    
    func generatePulses() -> [Float] {
        let pcmBufferPoints = self.generatePCMBufferPoints()
        let abs = self.abs(for: pcmBufferPoints)
        let desamp = self.desamp(for: abs)
        return desamp
    }
    
    private func abs(for points: [Float]) -> [Float] {
        let AStride = 1
        let CStride = 1
        let length = vDSP_Length(points.count)
        var output = [Float](repeating: 0.0, count: Int(length))
        
        vDSP_vabs(points,
                  AStride,
                  &output,
                  CStride,
                  length)
        return output
    }
    
    private func desamp(for points: [Float]) -> [Float] {
        let samplesPerPixel = 250
        let filter = [Float](repeating: 1.0 / Float(samplesPerPixel), count: Int(samplesPerPixel))
        let length = Int(points.count / samplesPerPixel)
        var output = [Float](repeating: 0.0, count: length)
        
        vDSP_desamp(points,
                    vDSP_Stride(samplesPerPixel),
                    filter,
                    &output,
                    vDSP_Length(length),
                    vDSP_Length(samplesPerPixel))
        return output
    }
    
    private func generatePCMBufferPoints() -> [Float] {
        let audioFile = self.generateAudioFile()
        let audioFormat = self.generateAudioFormat(with: audioFile)
        let audioPCMBuffer = self.generateAudioPCMBuffer(file: audioFile, format: audioFormat)
        
        do {
            try audioFile.read(into: audioPCMBuffer)
            let pulses = Array(UnsafeBufferPointer(start: audioPCMBuffer.floatChannelData?[0],
                                                   count: Int(audioPCMBuffer.frameLength)))
            return pulses
        } catch {
            fatalError("Couldn't read the file \(audioFile) into the audioPCMBuffer \(audioPCMBuffer)")
        }
    }
    
    private func generateAudioFile() -> AVAudioFile {
        let audioFile = try? AVAudioFile(forReading: self.url)
        if let audioFile = audioFile {
            return audioFile
        }
        fatalError("Couldn't get the audioFile for url: \(self.url)")
    }
    
    private func generateAudioFormat(with audioFile: AVAudioFile) -> AVAudioFormat {
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                        sampleRate: audioFile.fileFormat.sampleRate,
                                        channels: audioFile.fileFormat.channelCount,
                                        interleaved: false)
        
        if let audioFormat = audioFormat {
            return audioFormat
        }
        fatalError("Couldn't get the audioFormat for url: \(self.url)")
    }
    
    private func generateAudioPCMBuffer(file: AVAudioFile,  format: AVAudioFormat) -> AVAudioPCMBuffer{
        let buffer = AVAudioPCMBuffer(pcmFormat: format,
                                      frameCapacity: UInt32(file.length))
        
        if let buffer = buffer {
            return buffer
        }
        fatalError("Couldn't get the audioPCMBuffer for url: \(self.url)")
    }
}
