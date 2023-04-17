#!/usr/bin/env swift

import Foundation

@discardableResult
func shell(_ args: [String]) -> Int32 {
  print(args.joined(separator: " "))
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

let sizes = [
  "40mm": 162,
  "41mm": 176,
  "44mm": 184,
  "45mm": 198,
  "49mm": 205,
]

// TODO: load from filesystem instead
let locales = [
  "ar",
  "da",
  "de",
  "el",
  "en",
  "es",
  "fi",
  "fr",
  "he",
  "ja",
  "nl",
  "ro",
  "ru",
  "sv",
  "zh-Hans",
  "zh-Hant",
]

//for size in sizes.keys {
//  for locale in locales {
//    shell([
//      "convert",
//      "+append",
//      "DatePicker-1@\(size)~\(locale).png",
//      "DatePicker-2@\(size)~\(locale).png",
//      "DatePicker-3@\(size)~\(locale).png",
//      "-background", "transparent",
//      "-splice", "8x0+0+0",
//      "+append",
//      "-chop", "8x0+0+0",
//      "DatePicker@\(size)~\(locale).png"
//    ])
//
//    shell([
//      "convert",
//      "+append",
//      "DatePicker_date-1@\(size)~\(locale).png",
//      "DatePicker_date-2@\(size)~\(locale).png",
//      "-background", "transparent",
//      "-splice", "8x0+0+0",
//      "+append",
//      "-chop", "8x0+0+0",
//      "DatePicker_date@\(size)~\(locale).png"
//    ])
//
//    shell([
//      "convert",
//      "+append",
//      "DatePicker_hourAndMinute-1@\(size)~\(locale).png",
//      "DatePicker_hourAndMinute-2@\(size)~\(locale).png",
//      "-background", "transparent",
//      "-splice", "8x0+0+0",
//      "+append",
//      "-chop", "8x0+0+0",
//      "DatePicker_hourAndMinute@\(size)~\(locale).png"
//    ])
//  }

//  shell([
//    "convert",
//    "-delay", "10"
//  ] + locales.map {
//    "DatePicker@\(size)~\($0).png"
//  } + [
//    "-loop", "0",
//    "apng:DatePicker@\(size)~all.png"
//  ])
//}

//for size in sizes.keys {
//  for locale in locales {
//    shell([
//      "convert",
//      "-delay", "25",
//      "TimeInputView@\(size)~\(locale).png",
//      "TimeInputView@\(size)~\(locale)~system.png",
//      "-loop", "0",
//      "apng:TimeInputViewComparison@\(size)~\(locale).png"
//    ])
//  }
//}

var string = String()
string.append("<title>WDP QA</title>")
string.append("<link rel='stylesheet' href='./qa.css'/>")
string.append("<body>")

func table(_ class: String = "", _ filename: (String) -> String, _ alternateFilename: ((String) -> String)? = nil) {
  //string.append("<h2>\(filename(""))</h2>")
  string.append("<table class='" + `class` + "'>")
  string.append("  <thead>")
  string.append("    <tr>")
  string.append("      <th/>")
  for locale in locales {
    string.append("<th>\(locale)</th>")
  }
  string.append("    </tr>")
  string.append("  </thead>")
  for (size, width) in sizes.sorted(by: <) {
    string.append("<tr class='\(size)'>")
    string.append("  <th>\(size)</th>")
    for locale in locales {
      string.append("<td class='\(alternateFilename != nil ? "alternating" : "")'>")
      string.append("  <img src='./\(filename("@\(size)~\(locale)")).png' width='\(width)'/>")
      if let alternateFilename = alternateFilename?("@\(size)~\(locale)") {
        string.append("<img src='./\(alternateFilename).png' width='\(width)' class='alternate'/>")
      }
      string.append("</td>")
    }
    string.append("</tr>")
  }
  string.append("</table>")
}

//table { "TimeInputViewComparison\($0)" }
//table({ "TimeInputView\($0)" }, { "TimeInputView\($0)~system" })
table { "TimeInputView\($0)" }
table { "TimeInputView\($0)~system" }

table { "DatePicker-1\($0)" }
table { "DatePicker-2\($0)" }
table { "DatePicker-3\($0)" }

table { "DatePicker_date-1\($0)" }
table { "DatePicker_date-2\($0)" }

table { "DatePicker_date-2-D\($0)" }
table { "DatePicker_date-2-M\($0)" }
table { "DatePicker_date-2-Y\($0)" }

table { "DatePicker_hourAndMinute-1\($0)" }
table { "DatePicker_hourAndMinute-2\($0)" }

table("nomask") { "StandaloneDateInputView\($0)" }
table("nomask") { "StandaloneTimeInputView\($0)" }

try! string.write(toFile: "./index.html", atomically: true, encoding: .utf8)
