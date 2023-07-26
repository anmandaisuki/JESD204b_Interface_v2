# JESD204b_rx_controller_slide
* トランシーバ搭載のカンマ検出機能ではなく、rxslide機能を用いて、マニュアルでビットをスライドしてデータ境界を検出するようにした。おそらくこちらの方が高速になってイレギュラーなエラーが起きたときに、アレンジしやすい。

## ファイル説明
* jesd204b_rx_controller_slide.v : topモジュール。jesd204b_rx_core_slideとトランシーバモジュールを接続する。
* jesd204b_rx_core_slide.v : jesd204b規格に則ってリンクの確立を行う。
* jesd204b_lmfc_generator.v : LMFC(ローカルマルチフレームクロック)を作成する。jesd204b_rx_core_slideの内部で使用される。
* axis_convertion_interface_for_adc.v : jesd204b_rx_controller_slideから出てきたデータをAXISインターフェイスに変換する用。

## RXSLIDEの動作について詳細
* RXSLIDEのアサート間はRXUSRCLK2の32サイクル以上待たないといけない。ここで特にギリギリを攻める必要もないから、ちょっと余裕をもって33サイクル待つようにした。
* 8b10bデコーダを使用しているときは、RXSLIDEによってgtwiz_userdata_rx_outの出力がきれいに左/右にシフトしていくわけではない。なぜならデコード前の10bがシフトされており、gtwiz_userdata_rx_outはデコードされた8bだから。8b10bデコーダを使用する際は、はじめの状態では10bの境界がわからないため、RXSLIDEで10b境界をずらして、デコード結果の8bを確認している。
* RXSLIDEはRXUSRCLK2の2サイクル分の立ち上がりエッジでHにする必要あり。[(p233参照)](https://docs.xilinx.com/v/u/ja-JP/ug578-ultrascale-gty-transceivers)
* RXSLIDEを使用するときはRXPCOMMAALIGNEN,RXMCOMMAALIGNENは0にする。RXCOMMADETEENは1にする。[(p236参照)](https://docs.xilinx.com/v/u/ja-JP/ug578-ultrascale-gty-transceivers)

## クロックについて
* 今回はなるべくクロックをシンプルな構成にした。トランシーバのリファレンスクロック(gtrefclk)、トランシーバの初期化用クロック(freerunclk)、ユーザー側回路のクロック(RXUSRCLK2/RXUSRCLK)をすべて同一の周波数になるようにし、このクロックはトランシーバのMGTREFCLKからDevice Clockを入力することで得るようにした。
    * MGTREFCLKから入力されたCLKは、QPLLで位相がロックされた後、トランシーバのQPLLREFOUTCLKからユーザー側回路へ供給することができる。今回はこれをそのままRXUSRCLK2/RXUSRCLKとして使用している。

## 改善必要そうなところ
* freerunclkだけは別で取った方がいいかもしれない。トランシーバのPLLリセットにも使用される。現状の設計だと、freerunclkをトランシーバのQPLLから供給することになっている。もしかしたらダメかも。freerunclkはリセットのみで使用され、他の回路と同期しないはずなので、適当にとった方が無難。リセットできないと何もできない。

### 参照
* [カンマ検出機能を使用した方。トランシーバの基本的な使い方はこちらで説明してある。]()
* [Ultrascale FPGAs Transceivers Wizard](https://docs.xilinx.com/v/u/ja-JP/pg182-gtwizard-ultrascale)
* [7 Series FPGAs GTX/GTH Transceivers](http://padley.rice.edu/cms/OH_GE21/UG476_7Series_Transceivers.pdf)
* [Ultrascale Architechture GTH transceivers](https://docs.xilinx.com/v/u/ja-JP/ug576-ultrascale-gth-transceivers)
* [UltraScale Architechture GTY transceivers](https://docs.xilinx.com/v/u/ja-JP/ug578-ultrascale-gty-transceivers)
