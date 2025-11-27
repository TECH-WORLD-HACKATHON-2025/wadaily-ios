//
//  DiscoverView.swift
//  Wadaily
//
//  Created by 浦山秀斗 on 2025/11/28.
//

import SwiftUI

struct AnimatedShape: Identifiable {
    let id = UUID()
    var offset: CGSize
    var scale: CGFloat
    var opacity: Double
    var color: Color
}

struct DiscoverView: View {
    @State private var shapes: [AnimatedShape] = []
    
    // サンプルデータ
    let partners = [
        CallPartner(name: "うらっしゅ", imageUrl: nil, backgroundImageUrl: nil, status: "online", topics: []),
        CallPartner(name: "Sui", imageUrl: nil, backgroundImageUrl: nil, status: "online", topics: []),
        CallPartner(name: "Tsukasa", imageUrl: nil, backgroundImageUrl: nil, status: "offline", topics: []),
        CallPartner(name: "toku", imageUrl: nil, backgroundImageUrl: nil, status: "online", topics: []),
    ]
    
    var body: some View {
        ZStack {
            ForEach(shapes) { shape in
                Circle()
                    .fill(shape.color.opacity(shape.opacity))
                    .frame(width: 150, height: 150)
                    .scaleEffect(shape.scale)
                    .offset(shape.offset)
                    .blur(radius: 20)
            }
            
            VStack {
                Text("Wadaily")
                    .font(Font.largeTitle.bold())
                Text("話し相手をみつけよう")
                    .font(.callout)
                
                ScrollView {
                    ForEach(partners) { partner in
                        CallPartnerCell(partner: partner)
                            .shadow(radius: 5)
                            .padding(8)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        shapes = (0..<5).map { _ in
            AnimatedShape(
                offset: randomOffset(),
                scale: Double.random(in: 0.5...3.0),
                opacity: Double.random(in: 0.1...0.2),
                color: [Color.blue, Color.purple, Color.pink, Color.orange].randomElement()!
            )
        }

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 3)) {
                for i in 0..<shapes.count {
                    shapes[i].offset = randomOffset()
                    shapes[i].scale = Double.random(in: 0.5...3.0)
                }
            }
        }
    }
    
    private func randomOffset() -> CGSize {
        CGSize(
            width: CGFloat.random(in: -300...300),
            height: CGFloat.random(in: -400...400)
        )
    }
}

extension DiscoverView {
    private func CallPartnerCell(partner: CallPartner) -> some View {
        ZStack {
            // 背景画像またはデフォルト背景
            if partner.backgroundImageUrl != nil {
                // TODO: 実際の画像URLから読み込み
                Color.blue.opacity(0.3)
            } else {
                Image("hotel")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .opacity(0.2)
                    .overlay {
                        if partner.isOnline {
                            RoundedRectangle(cornerRadius: 36)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom))
                                .opacity(0.3)
                        }
                        else
                        {
                            RoundedRectangle(cornerRadius: 36)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
                                .opacity(0.3)
                        }
                    }
            }
            
            HStack {
                // プロフィール画像
                Image("guest1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(partner.name)
                        .font(.title2)
                        .bold()

                    Text(partner.status)
                        .font(.headline)
                        .foregroundColor(partner.isOnline ? .green : .gray)
                        .shadow(color: .white, radius: 1)
                    
                }
                
                Spacer()
                
                // 通話ボタン
                Button(action: {
                    // 通話開始処理
                }) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(partner.isOnline ? .green : .gray)
                        .clipShape(Circle())
                }
            }
            .padding(16)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 38)
                .stroke(Color.white, lineWidth: 10)
        )
        .cornerRadius(38)
        
    }
}

#Preview {
    DiscoverView()
}
