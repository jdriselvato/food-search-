//
//  Helpers.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import Foundation
import SwiftUI

extension String {
    /// Convert the HTML string to Data
    var formatHTML: AttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let nsAttributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else { return nil }
        
        return AttributedString(nsAttributedString)
    }
}
