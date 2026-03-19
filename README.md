# SakeLog

SakeLog は、日本酒の銘柄やラベル写真、メモを記録して、自分だけの「酒ログ」を残せる iOS アプリです。

気に入った日本酒をコレクションとして振り返れるように、最近飲んだ一本の表示、酒棚ビュー、今月の記録確認などの機能を備えています。

## アプリ概要

- 日本酒の記録を手元で管理する個人向けアプリ
- ラベル写真を残して、視覚的にコレクションを振り返れる
- 初回起動時はゲストユーザーを作成してすぐに使い始められる

## 主な機能

### 1. ホーム

- 最近飲んだ日本酒の表示
- 今日の日本酒豆知識の表示
- 今月記録した銘柄数、酒蔵、地域のサマリー表示

### 2. 酒棚

- 記録済みの日本酒を一覧表示
- ラベル画像を使った 3D ボトル表示
- 各記録の詳細画面への遷移

### 3. 記録の追加・編集

- 銘柄一覧から日本酒を選択
- 種類の選択
- ラベル画像の撮影または写真ライブラリからの選択
- 画像のトリミング
- メモ付きで保存
- 保存済み記録の編集・削除

### 4. 設定

- プラン表示
- テーマ表示
- 銘柄データについての案内
- 利用規約 / プライバシーポリシーへのリンク
- 保存データの削除

## 画面構成

- `StartView`
  - オンボーディング画面
- `ContentView`
  - `Home` / `Shelf` / `Setting` の 3 タブ
- `HomeView`
  - 最近の記録、豆知識、今月の記録
- `CabinetView`
  - 酒棚一覧
- `BrandListView` / `AddBrandSheetView`
  - 日本酒の追加フロー
- `SakeLogDetailView` / `EditBrandSheetView`
  - 詳細表示と編集
- `SettingView`
  - アプリ設定

## 使用技術

- SwiftUI
- RealmSwift
- Firebase
  - Firebase Analytics
  - Firebase Crashlytics
- Google Mobile Ads
- SceneKit
- PhotosUI / UIKit ブリッジ

## データと外部サービス

- 日本酒の銘柄データは、オープンデータとして公開されている「さけのわデータ」を基に構成されています
- Firebase はアプリ初期化および分析・クラッシュ収集に使用されています
- 画像や利用データの一部は端末内に保存されます

## 開発環境

- Xcode プロジェクト: `SakeLog.xcodeproj`
- Swift: `5.0`
- iOS Deployment Target: `17.6`
- Bundle Identifier: `gakux.SakeLog`

## セットアップ

1. Xcode で `SakeLog.xcodeproj` を開きます。
2. Swift Package Manager 依存関係を解決します。
3. `SakeLog/GoogleService-Info.plist` を配置します。
4. 必要に応じて署名設定を行い、シミュレータまたは実機で起動します。

## 補足

- カメラを使ったラベル撮影機能を含みます
- ローカル保存には Realm を使用しています
- 文言管理には `Localizable.xcstrings` と `InfoPlist.xcstrings` が使われています

