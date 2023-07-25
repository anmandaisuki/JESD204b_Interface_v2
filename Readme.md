# AXIS_INTERFACE_CONVERTION_FOR_ADC
* ADCから送られてきたパラレルデータをAXISインターフェイスに変換するIP
    * 高速ADCの信号はトランシーバとかでデシリアライズされて、パラレル化されてる。
* AXISの動作クロック(axis_aclk)はADCから送られてくるパラレルデータの同期クロックと一致させる。
    * 一致させない場合、非同期FIFO必要でちょっと面倒。そもそもADCデータを大容量RAMとかに送るためのAXISインターフェイスなので、AXISインターフェイスのFIFOは同期FIFOで必要最低限にしておく。
    * このIPからAXIS用のm_axis_aclkを出力するようにした。

## 概要
* ADCのパラレルデータはIP接続前に整理しておく。このIPはただAXISインターフェイスに変換するだけ。
    * 例えば、8bitデータ(@ 600MHz)4つをまとめて、32bit(@ 150MHz)で転送する際のデータ整理は、このIP接続前に処理する。
* i_con_adcsideがHのときに、ADCデータがFIFOに書き込まれて、i_con_axissideがHのときにAXISから出力される。ただしFIFOがfullになったら、ADCからの書き込みを止める。またFIFOがemptyになったらAXISからの出力を停止する。
    * 基本的にi_con_adcside, i_con_axiside両方Hにして使用することを想定。

## 使い方
* 高速トランシーバーでデシリアライズされたADCの信号をDRAMとかに転送するときに使用することを想定。トランシーバからのデータをAXISインターフェイスに変換して、AXI_DMAとかでRAMに転送するのが典型的な使い方。

## 必要なIP
* [FIFO_SYNC](https://github.com/sota5460/HDL_Source_Storage/blob/main/fifo/fifo_sync.v)


