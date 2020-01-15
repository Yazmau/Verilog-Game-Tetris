## 遊戲主程式STG
![](https://i.imgur.com/N65xuoI.png)

依照 module 的功能與分工，將所有遊戲主程式 module 分成三大類：
## 1. Top module
控制遊戲當前要執行的操作，並將遊戲呈現所需要的資訊（遊戲版面）輸出給螢幕顯示的 module。

屬於本類型的 module：
- GameEngine

## 2. Transition module
根據 Top module 狀態（欲執行的操作），調用 Function module 來更新遊戲資訊。主要針對無法直接調用 Function module 處理的更新。

屬於本類型的 module：
- generate_piece_TRAN
- get_input_TRAN
- hold_TRAN
- clear_line_TRAN

## 3. Function module
實現遊戲執行所需的核心功能。

屬於本類型的 module：
- board_controller
- falling_piece_update
- random_tetris

### 示意圖
![](https://i.imgur.com/ofszoV4.png)
