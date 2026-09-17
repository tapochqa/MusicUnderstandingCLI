import Foundation
import MusicUnderstanding
import AVFoundation


let helpStr = "usage: mu-cli [--loudness --rhythm] [--peak --integrated --short-term --momentary --bpm] file\n"


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
    FileHandle.standardOutput.write("Music Understanding CLI 0.4\n".data(using: .utf8)!)
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
    
    
    let jsonData = switch arguments[2] {
               case "--bpm", "-b": ( try encoder.encode (results.rhythm?.beatsPerMinute) )
              case "--peak", "-p": ( try encoder.encode (results.loudness?.peak.value) )
        case "--integrated", "-i": ( try encoder.encode (results.loudness?.integrated.value) )
        case "--short-term", "-s": ( try encoder.encode (results.loudness?.shortTerm.max(by:
                                                        { ($0.value) < ($1.value)  })?.value))
         case "--momentary", "-m": ( try encoder.encode (results.loudness?.momentary.max(by:
                                                    { ($0.value) < ($1.value)  })?.value))
                          default: ( try encoder.encode(results) )
    }
    

    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }

    exit(0)   
} catch {
    FileHandle.standardError.write("Analysis failed: \(error)\n".data(using: .utf8)!)
    exit(1)
}
