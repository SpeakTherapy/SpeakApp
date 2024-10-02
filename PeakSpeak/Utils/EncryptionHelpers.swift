//
//  EncryptionHelpers.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 8/6/24.
//

import Foundation
import CryptoKit

struct KeyPair {
    let privateKey: SecKey
    let publicKey: SecKey
}

func generateKeyPair() -> KeyPair? {
    let attributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits as String: 2048
    ]

    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
        print("Error generating private key: \(error!.takeRetainedValue())")
        return nil
    }

    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
        print("Error getting public key from private key")
        return nil
    }

    return KeyPair(privateKey: privateKey, publicKey: publicKey)
}

func storePrivateKey(_ privateKey: SecKey) -> Bool {
    let query: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecValueRef as String: privateKey,
        kSecAttrApplicationTag as String: "com.peakspeak.privatekey"
    ]

    SecItemDelete(query as CFDictionary) // Remove any existing key
    let status = SecItemAdd(query as CFDictionary, nil)
    return status == errSecSuccess
}

func retrievePrivateKey() -> SecKey? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrApplicationTag as String: "com.peakspeak.privatekey",
        kSecReturnRef as String: true
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    return status == errSecSuccess ? (item as! SecKey?) : nil
}

func encrypt(data: Data, with key: SymmetricKey) -> Data? {
    let sealedBox = try? AES.GCM.seal(data, using: key)
    return sealedBox?.combined
}

func decrypt(data: Data, with key: SymmetricKey) -> Data? {
    guard let sealedBox = try? AES.GCM.SealedBox(combined: data) else {
        return nil
    }
    return try? AES.GCM.open(sealedBox, using: key)
}
