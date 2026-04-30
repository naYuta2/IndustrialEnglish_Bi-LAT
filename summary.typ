#import "@preview/grayness:0.4.1": image-transparency

#set page(
  paper: "presentation-16-9",
  footer: context [
    #if counter(page).get().first() > 1 [
      #align(center)[
        #line(length: 90%, stroke: 1pt + gray)
        #v(12pt, weak: true)
        #text(11pt)[
          工業英語 論文要約 「Bi-LAT: Bilateral Control-Based Imitation Learning via Natural Language and Action Chunking with Transformers」
        ]
      ]\
      #place(
        bottom + right,
        dx: 15pt, dy: -15pt,
      )[
        #text(size: 16pt, [#{counter(page).get().first() - 1}])
      ]
    ]
  ],
  // background: [
  //   #image-transparency(
  //     read("assets/bg.png", encoding: none),
  //     alpha: 0.3, width: 100%, height: 100%
  //   )
  // ],
  margin: (
    top: 50pt,
    bottom: 50pt,
  ),
  numbering: "1",
  number-align: right
)

#set text(
  font: "Century Gothic",
  size: 18pt,
)

#show heading: it => {
  set text(green.lighten(-30%), size: 32pt - 4pt * it.level)
  it
}

#show figure.caption: it => {
  set text(size: 11pt, style: "italic", gray)
  it
}

#set list(marker: text("・", green.lighten(-40%)), spacing: 20pt)

#place(center)[
  #v(100pt)
  = #("論文要約
  「Bi-LAT: Bilateral Control-Based Imitation Learning via Natural Language and Action Chunking with Transformers」")
  #v(20pt)
  #align(right)[
    #text(20pt)[f21151 5J-36 三浦 璃久]
  ]
]

#pagebreak()

= Reference

#bibliography("ref.bib", title: none, style: "ieee")


#pagebreak()

= Abstract
- 従来の模倣学習では主に「位置」や「軌道」の再現に依存しており、「力加減 (トルク) 」を制御する事が困難であった
- 双方向制御と、Action Chunking with Transformers (ACT) を組み合わせたフレームワーク「Bi-LAT」@bilat2025 を提案
- コップ積み、スポンジ絞りのタスクを実施
  - Bi-LATは「強く」「弱く」といった言語指示を正確に解釈、トルクや把持力を動的に変化させることに成功

#pagebreak()

= I INTRODUCTION
== 背景
- 従来の産業用ロボットは事前プログラムされた反復動作に依存
  - 動的環境への適応、多様な形状・素材の物体への対応が求められる

== 模倣学習の可能性と限界
- 人間のデモンストレーションからロボットが直接スキルを習得できる
  - しかし…位置コマンドのみを模倣する従来の方法では力加減やトルクの制御が困難

== LLMの可能性と限界
- 大規模言語モデル (LLM) の登場により自然言語を介したロボット制御の可能性が大きく広がる
  - しかし…力加減やトルクの制御においては不十分だった

#pagebreak()

== Bi-LAT: Bilateral Control-Based Imitation Learning via Natural Language and Action Chunking with Transformers

双方向制御とAction Chunking with Transformers (ACT) を組み合わせたフレームワーク
- 双方向制御 (Bilateral Control)
  - 人間がロボットを遠隔操作する際に、ロボットの状態を人間にフィードバックする制御方式
- Action Chunking with Transformers (ACT)
  - Transformerベースのモデル
  - 時系列データをチャンク（一定の時間幅の行動のまとまり）に分割して処理
双方向制御のセンサーから得られるトルク値をACTの入力に組み込み、未来の目標位置やトルクを予測

#pagebreak()

= II RELATED WORKS

== II-A Bilateral Control-Based Imitation Learning
- *バイラテラル制御*を模倣学習に応用
  - 人間がリーダーロボットを操作し、フォロワーロボットがリーダーの動きを模倣
  - 人間の直感に近い動作データを収集可能

*バイラテラル制御 x 模倣学習の先行研究*
- LSTM (長短期記憶) ネットワークを用いた模倣学習
- Transformerベースのロボット制御
  - Bi-ACT (バイラテラル制御 x ACT)

本研究ではBi-ACTを拡張し、自然言語処理を統合する事で人間の言語指示に基づきアクションを生成しながら*力情報も考慮*するフレームワークBi-LATを提案

#pagebreak()

== II-B Imitation Learning Using Language Models
- 従来のロボット制御から言語制御へのパラダイムシフト
  - 言語モデルの登場により自然言語指示によるロボット制御が可能に

- VLM (Vision-Language Model) の登場
  - 画像・映像と言語コマンドを並行して処理・解釈が可能に

Bi-LATは言語情報とバイラテラル制御が提供する触覚フィードバックを結びつける
→人間オペレーターの指示する精密な力加減でタスクを実行できるように

#pagebreak()

= III Bi-LAT: Bilateral Control-Based Imitation Learning via Natural Language And Action Chunking with Transformers

== III-A Overview
Bi-ACTはバイラテラル制御を活用し位置情報と力情報の両方を用いたロボット制御を行う
- 未知の物体に対しても適応
- RGBカメラの画像データも取り込み視覚ベースの制御を実現

Bi-LATではこれを基盤として言語エンコーダを統合
- 生成されるアクションがオペレーターの指定した力レベルに対応するよう設計
- 自然言語処理技術の導入によりユーザーが提供する自然言語に基づきタスクを実行

#pagebreak()

#image("assets/tsr5.jpg")

#pagebreak()

== III-B Data Collection

*4チャンネルバイラテラル制御*を採用
- $theta_1 - theta_f = 0$ : リーダーとフォロワーの関節角度が一致
- $tau_1 - tau_f = 0$ : リーダーとフォロワーのトルクが等値逆符号

  - 関節角度はエンコーダで取得
  - トルクは外乱オブザーバー (DOB) と反力オブザーバー (RFOB) を用いて測定<br>
  　　→ 力 / トルクセンサーが不要に

- オペレーターが提供する自然言語指示をデータ収集プロセスに組み込んでいる
- プロンプトエンジニアリングを採用
  - プロンプトの冒頭に「a photo of a」というフレーズを追加する事で精度が向上

#pagebreak()

#image("assets/bi-lat_collect.jpg")

#pagebreak()

== III-C Language Encoder
自然言語指示を分散表現に変換するため、CLIP市リースとBERTシリーズから計4種類の言語エンコーダを採用
- CLIP (Contrastive Language-Image Pre-training)
- SigLIP: CLIPの派生モデル
- DistillBERT: BERTの軽量版
- ModernBERT: Transformerベースの言語理解モデル

CLIPベースのモデル: 視覚情報とテキスト情報の統合に優れる
BERTベースのモデル: 自然言語理解に特化

#figure(
  
  image("assets/bi-lat_le.jpg", height: 200pt),
  caption: "Bi-LATの言語エンコーダの構成"
)

#pagebreak()

== III-D Learning Model
Transformer駆動のCVAE (条件付き変分オートエンコーダ) アーキテクチャで構成
- 入力: フォロワーロボットの関節角度・速度・トルクデータ、視覚入力、自然言語指示
- 出力: リーダーロボットの予測関節角度・速度・トルクを含むアクションチャンクシーケンス

言語指示は専用の言語エンコーダ (LE) によって変換
- ResNet-18で抽出された視覚特徴とフォロワーの関節データと統合 \ 包括的な潜在表現を形成
- 洗剤表現がCVAEベースのTransformerに入力、未来のリーダーロボットのアクションチャンクが予測される
- 学習はバイラテラル制御オペレーション中に収集された実際のリーダー関節データとの誤差を最小化する事で行われる

#pagebreak()

#figure(
  image("assets/bi-lat.jpg"),
  caption: "Bi-LATの学習モデルの構成"
)

#pagebreak()

== III-E Inference

Bi-LAT
- 入力: フォロワーの最新の関節データ、対応するカメラ画像、自然言語指示
- 予測: リーダーロボットの関節情報のアクションチャンク
- 出力: 各関節の角度・速度・トルク等のアクションデータ

出力はバイラテラル制御システムの計算により各関節に必要な電流値に変換される

#pagebreak()

#figure(
  image("assets/bi-lat_inference.jpg"),
  caption: "Bi-LATの推論プロセスの構成"
)

#pagebreak()

= IV Unimanual Experiment

== IV-A Hardware

- ロボット: ROBOTIS社 OpenManipulator-X
  - 回転用4関節 (Joint 1 ～ 4) + グリッパー用Joint5 で構成
  - リーダーとフォロワーの二台を使用
- カメラ: ELP USBカメラ 3台
  - 上方・側面・グリッパー上の3視点
  - 640 x 360 pxのRGB画像を取得

#figure(
  image("assets/ex1_hardware.jpg")
)

#pagebreak()

== IV-B Experimental Conditions

3つの紙コップを使ったカップ積み上げ実験
- タスク
  - Pick (掴む): 初期位置から移動しグリッパーを動かしてコップを把持
  - Move (運ぶ): 把持したまま中央に置かれた2つのコップの頂部へ移動
  - Place (置く): グリッパーを開いてコップを開放・配置

収集したデモンストレーションの言語指示は以下の2種類
- 「Softly grasp the cup」(軽い把持力)
- 「Strongly grasp the cup」(強い把持力)

これらの指示によって特に把持フェーズで顕著に異なるトルクプロファイルが生成された

#figure(
  image("assets/ex1_cup_stack.jpg")
)

#pagebreak()

== IV-C Training Setup

- 関節角度・角速度・トルクは1000Hzで記録
- リーダー、フォロワーそれぞれで15次元の関節データが得られた
- RGBカメラ画像は100Hzで同時取得

「softly」が3回、「strongly」が3回、計6回のデモンストレーションを収集
- 「softly」指示時: 関節角度は2.45～2.60 rad、トルクは0～0.05 Nm
- 「strongly」指示時: 関節速度は2.65～2.75 rad、トルクは0.15～0.20 Nm
訓練データの拡張にDABIを使用
- 高頻度のロボットセンサーデータと低頻度の画像データを収集するのに適した手法

#figure(
  image("assets/ex1_distilbert.jpg")
)

#pagebreak()

== IV-D Experiment Result

- 全ての手法でタスク成功率は100%を達成
- 力の精度には大きな差が生じた

#figure(
  table(
    columns: 4,
    align: center,
    stroke: 0.5pt,

    // ヘッダー背景色
    fill: (col, row) => if row == 0 { luma(220) } else { none },

    // ヘッダー行
    [*Method*], [*Instruction*], [*Success Rate*], [*Force Accuracy*],

    // Bi-ACT
    [Bi-ACT(None)], [No Instruction], [5/5(100%)], [×],

    // Bi-LAT(DistilBERT)
    table.cell(rowspan: 2, align: horizon + center)[Bi-LAT(DistilBERT)],
    [Softly],   [5/5(100%)], [△],
    [Strongly], [5/5(100%)], [△],

    // Bi-LAT(ModernBERT)
    table.cell(rowspan: 2, align: horizon + center)[Bi-LAT(ModernBERT)],
    [Softly],   [5/5(100%)], [×],
    [Strongly], [5/5(100%)], [×],

    // Bi-LAT(CLIP)
    table.cell(rowspan: 2, align: horizon + center)[Bi-LAT(CLIP)],
    [Softly],   [5/5(100%)], [×],
    [Strongly], [5/5(100%)], [×],

    // Bi-LAT(SigLIP)
    table.cell(rowspan: 2, align: horizon + center)[Bi-LAT(SigLIP)],
    [Softly],   [5/5(100%)], [○],
    [Strongly], [5/5(100%)], [○],
  ),
  caption: [Cup-Stacking Success Rates],
)

#pagebreak()

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(image("assets/ex1_no_language.jpg"), caption: "Bi-ACT (None)"),
  figure(image("assets/ex1_distilbert.jpg"), caption: "Bi-LAT (DistilBERT)"),
  figure(image("assets/ex1_modernbert.jpg"), caption: "Bi-LAT (ModernBERT)"),
  figure(image("assets/ex1_clip.jpg"), caption: "Bi-LAT (CLIP)"),
  figure(image("assets/ex1_siglip.jpg"), caption: "Bi-LAT (SigLIP)"),
)
#pagebreak()

- 言語指示なしのBi-ACTは常に強い把持力でタスクを実行
- SigLIPを使ったBi-LATのみ両指示に対して適切な力の使い分けを実現
- DistilBERTは部分的な改善に留まる
- ModernBERTとCLIPは言語指示の力の調整に効果が見られなかった

SigLIPが優れた理由
- シグモイドロスを使った学習
  - CLIPよりも優れた言語・視覚の対応付け能力
  - 力の程度を表す言葉と実際のロボットの力レベルをより正確に結びつけることができたと考察

#pagebreak()

#image("assets/ex1_result.jpg")

#pagebreak()

= V Bimanual Experiment

== V-A Hardware

ALPHA-$alpha$プラットフォームを使用
- リーダーロボット 2台
- フォロワーロボット 2台
- ロボットの構成
  - 多様な動作のための 6 自由度 (DOF) とグリッパー用の 1 DOF
- バイラテラル制御の周期は1000Hz
- RGBカメラ: 4台
  - 上方・側面・左右のグリッパー関節部の4視点

#image("assets/alpha.jpg")

#pagebreak()

== V-B Experimental Conditions

Bi-LATとSigLIPを組み合わせた手法の有効性を評価するためにスポンジ絞りタスクを実施

- タスク
  - Grab (掴む): グリッパーを開き全身してスポンジを把持
  - Lift (持ち上げる): スポンジをテーブルから持ち上げ
  - Twist (ねじる): 把持したままスポンジをねじる

- 言語指示
  - 「Softly twist the sponge」 (やさしくねじる)
  - 「Strongly twist the sponge」（強くねじる）

変形可能な素材のため、把持・ねじりフェーズで顕著に異なるトルクプロファイルが生じた

#image("assets/ex2_tele.jpg")

#pagebreak()

== V-C Training Setup

- 4チャンネルバイラテラル制御システムにより1000Hzでリーダー・フォロワー両ロボットの関節角度・角速度・トルクを記録
- 1台のロボットあたり21次元 (3値 x 7関節) のデータを取得
- 4台のカメラから100HzでRGB画像を収集

デモンストレーション
- 「sofly」を3回、「strongly」を3回の計6回を収集
- DABIを用いて1000Hzのデータをダウンサンプリング、データセットを10倍に拡張
- SigLIPテキストエンコーダを使用し、エンコーダ4層・デコーダ7層で構成

トレーニングデータにおける関節角度・トルクの分布
- 「softly」条件: 関節角度は3.0～3.25 rad、トルクは 0～0.10 Nm
- 「strongly」条件: 関節角度は3.25～3.5 rad、トルクは 0.10～0.30 Nm

#image("assets/spg_train_all.jpg")

#pagebreak()

== V-D Experiment Result

#figure(
  table(
    columns: 5,
    align: center,
    stroke: 0.5pt,

    // ヘッダー背景色
    fill: (col, row) => if row == 0 { luma(220) } else { none },

    // ヘッダー行
    [*Instruction*], [*Pick*], [*Lift*], [*Twist*], [*Overall*],

    // Softly
    [Softly], [5/5 (100%)], [5/5 (100%)], [5/5 (100%)], [5/5 (100%)],

    // Strongly
    [Strongly], [5/5 (100%)], [5/5 (100%)], [4/5 (80%)], [4/5 (80%)]
  ),
  caption: [Sponge-Twisting Success Rates by Stage(Bi-LAT with SigLIP)],
)

- 「Softly」
  - 全てのフェーズで成功率100%を達成
- 「Strongly」
  - Twistのみ80％の成功率に留まる
  - スポンジの内部抵抗が高くねじり動作中にロボットがスポンジを把持できなくなることが原因と判明

#image("assets/spg_ex_all.jpg")

#pagebreak()

自律実行中、Bi-LATモデルは寮条件でほぼ同一の軌道をたどりながらも明確に異なるトルクプロファイルを生成
- 把持・ねじりフェーズにおいてトルク値が顕著に分岐、関節角度・トルクのヒストグラムでも2つの条件が明確に異なる分布を形成、トレーニングデータと一致

結果はモデルが自然言語指示に基づいて力を調整する能力を持つ事を示しており、バイラテラル制御ベースの模倣学習フレームワークに言語的手がかりを統合する事の有効性を実証している

#pagebreak()

= VI CONCLUSIONS

本論文でBi-LATを掲示
- バイラテラル制御ベースの模倣学習 x 自然言語処理
- Bi-ACTを基盤として視覚・固有感覚・言語データを活用

結果
- 単腕・両腕の実験を実施
  - SigLIPを使用したBi-LATが幅広い力レベルを適切に再現できる
  - 動的なマニュピレーションタスクへの適応におけるフレームワークの堅牢性を示す

#pagebreak()

= VI CONCLUSIONS

意義
- ロボットマニピュレーションの適応性と直感性を高める
- 多様な応用分野におけるシームレスな人間-ロボット協働という広い展望に沿うものである

課題
- より多様な物体特性への対応
- リアルタイム言語インタラクションの改善
- 汎用化性能向上のための大規模データセットの活用

#pagebreak()

= Word List

#let word_list = csv("words.csv")

#{
  set text(size: 12pt)
  table(
    columns: 5,
    ..word_list.flatten(),
  )
}