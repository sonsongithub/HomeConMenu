//
//  MenuView.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/29.
//

import SwiftUI

struct ONOFFItem: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
            Text("OK")
        }
    }
}

struct MenuView: View {
    @ObservedObject public var object = MainData()
    
    init(appDelegate: AppDelegate) {
        appDelegate.menuView = self
    }
    
    @ObservedObject public var data = MenuData()
    
    var body: some View {
        ForEach(data.rooms) { room in
            Text(room.name)
//            Button("メニュー項目", action: {
//                print("push")
//            })
//            Button {
//                print("a")
//            } label: {
//                Image(systemName: "checkmark")
//                Text("メニュー")
//            }
//            Menu(content: {
//                Text("aaaaaa")
////                SUColorPanel().frame(width: 200, height: 110)
//            }) {
//                Image(systemName: "checkmark")
//                Text("aa")
//            }
//            ForEach(room.accessories) { accessory in
//                Menu(accessory.name) {
//                    ForEach(accessory.charateristics) { charateristic in
//                        switch charateristic {
//                        case let obj as SUTemperature:
//                            Text("\(obj.temperature)")
//                        case let obj as SUSwitch:
//                            if obj.status {
//                                Text("ON")
////                                Menu(content: <#T##() -> _#>, label: <#T##() -> _#>)
////                                Label("ok", systemImage: "checkmark")
////                                HStack {
////                                    Image(nsImage: NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)!)
////                                    Text("ON")
////                                }
//                            } else {
//                                Text("OFF")
//                            }
//                        default:
//                            Text("object")
//                        }
//                    }
//                }
//            }
            Divider()
        }
    }
}
