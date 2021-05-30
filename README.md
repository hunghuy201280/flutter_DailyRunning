# Daily Runing

App chạy bộ

## Project Structure


### data

chứa các `class`  để lấy data local hoặc network api

### model

chứa `model` và `viewmodel`, `viewmodel` app này sẽ sử dụng package [Provider](https://pub.dev/packages/provider)

### repo

chứa abstract `class/interface` các hàm, biến cần dùng khi lấy data từ `data`, các `interface` này 
sẽ được implement bởi các class trong `data`

### ui
    
chứa ui

### utils
    
chứa các `class` hỗ trợ vd: parse data, get data từ network

## Tham khảo: 
[Flutter và MVVM](https://viblo.asia/p/flutter-va-mvvm-L4x5xk4alBM)
           
[Flutter: MVVM Architecture](https://medium.com/flutterworld/flutter-mvvm-architecture-f8bed2521958)
