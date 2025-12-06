//
//  SakeTips.swift
//  SakeLog
//
//  Created by Takane on 2025/12/06.
//

import Foundation

struct SakeTip: Identifiable {
    let id = UUID()
    let emoji: String
    let text: String
}

let sakeTips: [SakeTip] = [
    SakeTip(emoji: "🌀", text: "精米歩合が低いほど、雑味が少なくスッキリした味わいになりやすい。"),
    SakeTip(emoji: "🌸", text: "吟醸香は、低温でゆっくり発酵させることで生まれる華やかな香り。"),
    SakeTip(emoji: "🍚", text: "純米酒には醸造アルコールが一切入っていない。"),
    SakeTip(emoji: "❄️", text: "生酒は火入れをしていないので、冷蔵保存が基本。"),
    SakeTip(emoji: "🍶", text: "同じ銘柄でも、季節ごとに味わいが微妙に変わることがある。"),
    SakeTip(emoji: "📏", text: "日本酒度がプラスだと辛口、マイナスだと甘口の傾向。"),
    SakeTip(emoji: "🔥", text: "燗酒は温度によって名前が変わり、15段階以上ある。"),
    SakeTip(emoji: "🍷", text: "日本酒はワイングラスで飲むと香りが感じやすい。"),
    SakeTip(emoji: "👑", text: "純米大吟醸は“最高クラス”のお酒と言われることが多い。"),
    SakeTip(emoji: "🏷️", text: "ラベルの「特別」は、特別な造りや規格を満たしたお酒のサイン。"),
    SakeTip(emoji: "🌾", text: "無濾過はあえて濾過を少なくし、味わいが濃厚になりやすい。"),
    SakeTip(emoji: "🆕", text: "新酒は冬〜春にかけて楽しめる、できたての日本酒。"),
    SakeTip(emoji: "🍁", text: "ひやおろしは夏を越えてまろやかになった秋限定の味わい。"),
    SakeTip(emoji: "💧", text: "日本酒の味は、米・酵母・水の3つで大きく決まる。"),
    SakeTip(emoji: "🌡️", text: "同じ日本酒でも、常温・冷酒・燗酒で全く違う表情を見せる。"),
    SakeTip(emoji: "🥛", text: "にごり酒は、あえて米の成分を残したクリーミーなお酒。"),
    SakeTip(emoji: "🗾", text: "酒蔵の多い県トップは新潟・長野・兵庫が有名。"),
    SakeTip(emoji: "⏳", text: "熟成した古酒は、カラメルのような香りや琥珀色になることもある。"),
    SakeTip(emoji: "🧪", text: "山廃造りはコクが深く力強い味になることが多い。"),
    SakeTip(emoji: "🔢", text: "アルコール度数はワインより少し高い14〜16度が一般的。")
]

