//
//  AlarmTimePickerView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import SwiftUI

struct AlarmTimePicker: View {
    @State private var ampm: String = "오전"
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    
    private let ampmList = ["오전", "오후"]
    private let hours = Array(0...11)
    private let minutes = Array(0...59)
    
    var body: some View {
        HStack(spacing: 0) {
            // 오전/오후 피커
            Picker("", selection: $ampm) {
                ForEach(ampmList, id: \.self) { value in
                    AppText(text: value,
                            style: .title3_b_28,
                            color: ampm == value
                            ? .white
                            : .gray400)
                    .frame(width: 74, height: 50)
  
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 74, height: 120)
            .clipped()
            .background(Color.clear)
            .compositingGroup()
            .labelsHidden()
            
            // 시 피커
            Picker("", selection: $hour) {
                ForEach(hours, id: \.self) { value in
                    AppText(text: String(format: "%02d", value),
                            style: .number1_b_28,
                            color: hour == value
                            ? .white
                            : .gray400)
                    .frame(width: 74, height: 50)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 74, height: 120)
            .clipped()
            .background(Color.clear)
            .compositingGroup()
            .labelsHidden()
            
            AppText(text: ":",
                    style: .number1_b_28,
                    color: .white)
            
            // 분 피커
            Picker("", selection: $minute) {
                ForEach(minutes, id: \.self) { value in
                    AppText(text: String(format: "%02d", value),
                            style: .number1_b_28,
                            color: minute == value
                            ? .white
                            : .gray400)
                    .frame(width: 74, height: 50)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 74, height: 120)
            .clipped()
            .background(Color.clear)
            .compositingGroup()
            .labelsHidden()
        }
        .frame(height: 120)
        .background(Color.clear)
    }
}

struct AlarmTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            AlarmTimePicker()
        }
    }
}

