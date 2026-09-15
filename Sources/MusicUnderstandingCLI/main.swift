import Foundation
import MusicUnderstanding
import AVFoundation

let arguments = CommandLine.arguments
guard arguments.count > 1 else {
    FileHandle.standardError.write("Usage: \n full analysis - mu-cli /path/to/audio/file.mp3 \n only loudness - mu-cli -l /path/to/audio/file.mp3\n ".data(using: .utf8)!)
    exit(1)
}

let fileURL = URL(fileURLWithPath: arguments.last ?? "")

do {
    let asset = AVURLAsset(
        url: fileURL,
        options: [AVURLAssetPreferPreciseDurationAndTimingKey: true]
    )

    let session = try await MusicUnderstandingSession(asset: asset)
    
    let results = switch arguments[1]  {
        case "-l":  ( try await session.analyze(for: [.loudness]) )
        default:    ( try await session.analyze() )}

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    encoder.nonConformingFloatEncodingStrategy = .convertToString(
        positiveInfinity: "Infinity",
        negativeInfinity: "-Infinity",
        nan: "NaN"
    )
    let jsonData = try encoder.encode(results)

    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }

    exit(0)   // <-- guarantees a clean exit
} catch {
    FileHandle.standardError.write("Analysis failed: \(error)\n".data(using: .utf8)!)
    exit(1)
}
