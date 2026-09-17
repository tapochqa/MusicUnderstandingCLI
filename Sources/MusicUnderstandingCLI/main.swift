import Foundation
import MusicUnderstanding
import AVFoundation


let helpStr = "Usage: \n full analysis - mu-cli filepath \n only loudness - mu-cli --loudness filepath\n only rhythm —   mu-cli --rhythm filepath\n"


let arguments = CommandLine.arguments

guard arguments.count > 1 else {
    FileHandle.standardError.write(helpStr.data(using: .utf8)!)
    exit(1)
}

if arguments[1] == "--help" {
    FileHandle.standardOutput.write(helpStr.data(using: .utf8)!)
    exit(0)
}

if arguments[1] == "--version" || arguments[1] == "-v" {
    FileHandle.standardOutput.write("Music Understanding CLI 0.3\n".data(using: .utf8)!)
    exit(0)
}


let fileURL = URL(fileURLWithPath: arguments.last ?? "")

do {
    let asset = AVURLAsset(
        url: fileURL,
        options: [AVURLAssetPreferPreciseDurationAndTimingKey: true]
    )

    let session = try await MusicUnderstandingSession(asset: asset)
    

    
    let results = switch arguments[1]  {
        case "--loudness", "-l":  ( try await session.analyze(for: [.loudness]) )
        case "--rhythm", "-r":    ( try await session.analyze(for: [.rhythm]) )
        default:                  ( try await session.analyze() )}

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
