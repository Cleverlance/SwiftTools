//
//  File.swift
//
//
//  Created by Jan Halousek on 12.01.2021.
//

import CommonCrypto
import Foundation

public protocol HashService {
    func makeHashString(for string: String) -> String
}

final class HashServiceImpl: HashService {
    func makeHashString(for string: String) -> String {
        let data = Data(string.utf8)
        let hash = generateHash(for: data)
        return hash.reduce("") { $0 + String(format: "%02hhX", $1) }
    }

    private func generateHash(for data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        var data = [UInt8](data)
        _ = CC_SHA1(&data, CC_LONG(data.count), &hash)
        return Data(hash)
    }
}
