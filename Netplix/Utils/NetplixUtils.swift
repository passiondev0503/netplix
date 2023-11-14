//
//  NetplixUtils.swift
//  Netplix
//
//  Created by Octo Siswardhono on 10/11/23.
//

import Foundation

public enum DateFormat: String {
    case completeDateTimezone = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
}

class NetplixUtils {
    
    static let dateFormatter: DateFormatter = { _ -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormat.completeDateTimezone.rawValue
        return formatter
    }(())
}
