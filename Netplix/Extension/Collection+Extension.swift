//
//  Collection+Extension.swift
//  Netplix
//
//  Created by Octo Siswardhono on 11/11/23.
//

import Foundation

extension Collection {
  /// Accesses the element at the specified index if it exists.
  ///
  /// This subscript returns `nil` if the index is `nil` or if it is out of range for the collection.
  ///
  /// - Parameter safe: The optional index to access the element at.
  ///
  /// - Returns: The element at the specified index if it exists, otherwise `nil`.
  subscript(safe index: Index?) -> Element? {
    guard let index else { return nil }
    return indices.contains(index) ? self[index] : nil
  }
}
