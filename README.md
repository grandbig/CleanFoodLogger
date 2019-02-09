# CleanFoodLogger

## アーキテクチャ
本プロジェクトでは `Clean Swift` をベースとした `Clean Architecture` を採用しています。  

### Clean Swiftとは
`Clean Swift` は `View` / `ViewController` / `Interactor` / `Worker` / `Presenter` / `Model` / `Router` から構成されたアーキテクチャです。  
各関係性は次の通りです。  

![Clean Architectureの各関係性](https://user-images.githubusercontent.com/4291518/45251607-ecd0e180-b383-11e8-8b30-5324163ca932.png)

#### Viewとは
iOSアプリの見た目を表現します。  

#### ViewControllerとは

`ViewController` の責務は下記の通りです。  

1. `Interactor` に具体的な処理内容(表示ロジック)を問い合わせる  
2. `Presenter` からの指示を受けて、最適な `View` を描画する  
3. `Router` に画面遷移を依頼する  

#### Interactorとは

`Interactor` の責務は下記の通りです。  

1. `Worker` と `Presenter` を仲介する  
2. どんな条件で、 `Worker` に何の処理を依頼するのかハンドリングする  
3. `Worker` 経由で取得したレスポンスを `Presenter` に渡す  

#### Workerとは

`Worker` の責務は下記の通りです。  

1. `API` 処理や `Core Data` / `Realm` などのアプリ内ローカルデータの処理をハンドリングする  
2. 成功/失敗レスポンスをハンドリングする  

#### Presenterとは

`Presenter` の責務は下記の通りです。  

1. 受け取ったレスポンスを元に最適な表示(成功/失敗などの表示)になるようハンドリングする  
2. 受け取ったレスポンスを `Model.ViewModel` 形式に変換する  
3. `ViewController` に `Model.ViewModel` を渡して描画を依頼する  

#### Modelとは

`Model` の責務は下記の通りです。  

1. 各種コンポーネントを切り離し、各種コンポーネント間のやり取りに利用される  
2. `Request` / `Response` / `ViewModel` の3つの構造体を持つ  

3つの構造体の説明：
* `Request`  
  * ユーザの操作をInputパラメータとして内包したデータ形式  
  * `ViewController` から Interactor に渡される  
* `Response`  
  * `Worker` 処理結果を内包しているデータ形式  
  * `Interactor` から `Presenter` に渡される  
* `ViewModel`  
  * `ViewController` での描画に即したデータ形式  
  * `Presenter` から `ViewController` に渡される  

#### Routerとは

画面遷移の責務を持ちます。  

## プロジェクト構成

```
CleanFoodLogger
  ├── Models
  ├── Scenes
  │    ├── MapView
  │    │    ├── MapViewInteractor.swift
  │    │    ├── MapModels.swift
  │    │    ├── MapPresenter.swift
  │    │    ├── MapRouter.swift
  │    │    ├── MapViewController.swift
  │    │    └── MapWorker.swift
  │    └── RestaurantInformation
  ├── Services
  ├── Views
  ├── Workers
  └── Resources
```
