//
//  SetAlarmView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import SwiftUI
import ComposableArchitecture

struct SetAlarmView: View {
    @Bindable var store: StoreOf<SetAlarmFeature>
    @State var t = ""
    @State private var selectedDays: [Int] = []
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Rectangle().frame(height: 0)
                    VStack(spacing: 8) {
                        HStack {
                            AppText(text: "장소 선택",
                                    style: .body2_m_14,
                                    color: .gray300)
                            Spacer()
                        }

                        AppSearchBarPreView(text: $store.place.name.sending(\.selectedPlaceName),
                                            placeholder: "도착 목표 장소는?")
                            .onTapGesture {
                                store.send(.searchBarTapped)
                            }
                        
                        HStack() {
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                HStack(spacing: 4) {
                                    Image(.Image.icMapBlack22)
                                    AppText(text: "지도에서 찾기",
                                            style: .body2_m_14,
                                            color: .white)
                                }
                            }
                            
                        }
                    }
                    VStack(spacing: 8) {
                        HStack {
                            AppText(text: "알람 목적",
                                    style: .body2_m_14,
                                    color: .gray300)
                            Spacer()
                        }
                        
                        AppTextField(text: $store.alarm.title.sending(\.alarmTitle),
                                     placeholder: "눈 떠!")
                        
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            AppText(text: "알람 시간",
                                    style: .body2_m_14,
                                    color: .gray300)
                            Spacer()
                        }
                        
                        AlarmTimePicker()
                        
                    }
                    
                    VStack(spacing: 12) {
                        HStack {
                            AppText(text: "반복 요일",
                                    style: .body2_m_14,
                                    color: .gray300)
                            Spacer()
                        }
                        
                        WeekdayPicker(selectedDays: $selectedDays)
                        
                    }
                    
                    HStack(spacing: 4) {
                        AppText(text: "알람 소리",
                                style: .body2_m_14,
                                color: .gray300)
                        
                        Spacer()
                        
                        AppText(text: "진동모드",
                                style: .body4_m_12,
                                color: .gray500)
                        
                        Image(.Image.icRightArrowWhite22)
                    }
                    .padding(.vertical, 12)
                }
            }
        
            
            VStack {
                Spacer()
                AppButton(title: "저장하기",
                          size: .h48,
                          type: .line,
                          state: .disabled) {
                    
                }
                Spacer().frame(height: 40)
            }
            
        }
        .padding(.horizontal, AppLayout.horizontalPadding)
        .customNavigationBar(
            leftView: {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(.Image.icLeftArrowBlack28)
                }
            },
            centerView: {
                AppText(text: "알람 설정",
                        style: .subtitle5_b_16,
                        color: .gray50)
            }
        )
        .background(Color.gray900)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    SetAlarmView(store: Store(initialState: SetAlarmFeature.State(), reducer: {
        SetAlarmFeature()
    }))
}
