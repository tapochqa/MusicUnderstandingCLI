import Foundation
import MusicUnderstanding
import AVFoundation

let arguments = CommandLine.arguments
guard arguments.count > 1 else {
    FileHandle.standardError.write("Usage: MyMusicCLI /path/to/audio/file.mp3\n".data(using: .utf8)!)
    exit(1)
}

let fileURL = URL(fileURLWithPath: arguments[1])

do {
    let asset = AVURLAsset(
        url: fileURL,
        options: [AVURLAssetPreferPreciseDurationAndTimingKey: true]
    )

    let session = try await MusicUnderstandingSession(asset: asset)
    let results = try await session.analyze()

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let jsonData = try encoder.encode(results)

    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }

    exit(0)   // <-- guarantees a clean exit
} catch {
    FileHandle.standardError.write("Analysis failed: \(error)\n".data(using: .utf8)!)
    exit(1)
}
