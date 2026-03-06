# Bài 2 - Tập lệnh, các lệnh cơ bản, các chỉ thị biên dịch

---

## Assignment 1 - Lệnh gán số nguyên nhỏ 12-bit

### Chương trình mẫu

```asm
# Laboratory Exercise 2, Assignment 1
.text
    addi s0, zero, 0x512   # s0 = 0 + 0x512; I-type: chỉ có thể lưu
                           # được hằng số có dấu 12 bits
    add  s0, x0, zero      # s0 = 0 + 0; R-type: có thể sử dụng số
                           # hiệu thanh ghi thay cho tên thanh ghi
```

### Quan sát khi chạy từng bước

- Sau lệnh `addi s0, zero, 0x512`: thanh ghi `s0` = 0x00000512 = 1298 (thập phân). `pc` tăng từ 0x00400000 lên 0x00400004.
- Sau lệnh `add s0, x0, zero`: thanh ghi `s0` = 0x00000000. `pc` tăng lên 0x00400008.

### Kiểm tra khuôn dạng lệnh trong Text Segment

Lệnh `addi s0, zero, 0x512` (I-type):

| imm[11:0] | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|
| 0x512 | 00000 | 000 | 01000 | 0010011 |

Mã máy: `0x51200413`

Lệnh `add s0, x0, zero` (R-type):

| funct7 | rs2 | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|---|
| 0000000 | 00000 | 00000 | 000 | 01000 | 0110011 |

Mã máy: `0x00000433`

### Khi sửa thành `addi s0, zero, 0x20232024`

```asm
addi s0, zero, 0x20232024
```

Kết quả: **lỗi biên dịch** - "Operand out of range". Lệnh `addi` chỉ chứa được immediate 12-bit có dấu (từ -2048 đến 2047), không thể biểu diễn giá trị 0x20232024.

---

## Assignment 2 - Lệnh gán số 32-bit

### Chương trình mẫu

```asm
# Laboratory Exercise 2, Assignment 2
# Load 0x20232024 to s0 register
.text
    lui  s0, 0x20232    # s0 = 0x20232
    addi s0, s0, 0x024  # s0 = s0 + 0x024
```

### Quan sát khi chạy từng bước

- Sau `lui s0, 0x20232`: thanh ghi `s0` = 0x20232000. `pc` = 0x00400004.
- Sau `addi s0, s0, 0x024`: thanh ghi `s0` = 0x20232024. `pc` = 0x00400008.

Trong cửa sổ **Data Segment**: vùng `.text` chứa mã máy của hai lệnh trên. Không có dữ liệu trong `.data` vì chương trình chưa khai báo biến.

---

## Assignment 3 - Lệnh gán (giả lệnh)

### Chương trình mẫu

```asm
# Laboratory Exercise 2, Assignment 3
.text
    li s0, 0x20232024
    li s0, 0x20
```

### Quan sát trong cửa sổ Text Segment

- `li s0, 0x20232024` là lệnh giả (pseudo instruction), assembler dịch thành **hai lệnh** cơ bản:
  - `lui s0, 0x20232`
  - `addi s0, s0, 0x024`
- `li s0, 0x20` là lệnh giả, assembler dịch thành **một lệnh** cơ bản:
  - `addi s0, zero, 0x20` (vì giá trị nằm trong phạm vi 12-bit)

Cột **Source** hiển thị lệnh giả gốc; cột **Basic** hiển thị lệnh chính thống tương ứng. Lệnh giả giúp viết code ngắn gọn hơn nhưng không phải là một phần của tập lệnh RISC-V thực sự.

---

## Assignment 4 - Tính biểu thức 2x + y = ?

### Chương trình mẫu

```asm
# Laboratory Exercise 2, Assignment 4
.text
    # Assign X, Y into t1, t2 register
    addi t1, zero, 5    # X = t1 = ?
    addi t2, zero, -1   # Y = t2 = ?

    # Expression Z = 2X + Y
    add s0, t1, t1      # s0 = t1 + t1 = X + X = 2X
    add s0, s0, t2      # s0 = s0 + t2 = 2X + Y
```

### Kết quả

Thanh ghi `s0` sau khi chạy xong = 9 = 2*5 + (-1). Đúng với biểu thức 2X + Y.

### Kiểm tra khuôn dạng lệnh trong Text Segment

Lệnh `addi t1, zero, 5` (I-type):

| imm[11:0] | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|
| 000000000101 | 00000 | 000 | 00110 | 0010011 |

Lệnh `add s0, t1, t1` (R-type):

| funct7 | rs2 | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|---|
| 0000000 | 00110 | 00110 | 000 | 01000 | 0110011 |

Sự khác biệt giữa I-type và R-type: I-type có trường `imm[11:0]` thay thế cho `funct7 + rs2` trong R-type.

---

## Assignment 5 - Phép nhân

### Chương trình mẫu

```asm
# Laboratory Exercise 2, Assignment 5
.text
    # Assign X, Y into t1, t2 register
    addi t1, zero, 4    # X = t1 = ?
    addi t2, zero, 5    # Y = t2 = ?

    # Expression Z = X * Y
    mul s1, t1, t2      # s1 chứa 32 bit thấp
```

### Quan sát kết quả

Thanh ghi `s1` = 20 = 4 * 5. Kết quả đúng.

### Giải thích đoạn lệnh

- `addi t1, zero, 4` - gán giá trị 4 vào thanh ghi `t1` (X = 4).
- `addi t2, zero, 5` - gán giá trị 5 vào thanh ghi `t2` (Y = 5).
- `mul s1, t1, t2` - nhân `t1` với `t2`, ghi 32-bit **trọng số thấp** của kết quả vào `s1`. Thuộc extension RV32M.

### Phép chia

Các lệnh chia cũng thuộc extension RV32M:
- `div rd, rs1, rs2` - chia có dấu, lấy thương.
- `divu rd, rs1, rs2` - chia không dấu, lấy thương.
- `rem rd, rs1, rs2` - chia có dấu, lấy phần dư.
- `remu rd, rs1, rs2` - chia không dấu, lấy phần dư.

Ví dụ minh họa luồng tính Z = X / Y với X = 10, Y = 3:

```asm
.text
    addi t1, zero, 10   # t1 = X = 10
    addi t2, zero, 3    # t2 = Y = 3
    div  s0, t1, t2     # s0 = 10 / 3 = 3 (thương)
    rem  s1, t1, t2     # s1 = 10 % 3 = 1 (phần dư)
```

---

## Assignment 6 - Tạo biến và truy cập biến

### Chương trình mẫu

```asm
# Laboratory Exercise 2, Assignment 6
.data                   # Khởi tạo biến (declare memory)
    X: .word 5          # Biến X, kiểu word (4 bytes), giá trị khởi tạo = 5
    Y: .word -1         # Biến Y, kiểu word (4 bytes), giá trị khởi tạo = -1
    Z: .word 0          # Biến Z, kiểu word (4 bytes), giá trị khởi tạo = 0

.text                   # Khởi tạo lệnh (declare instruction)
    # Nạp giá trị X và Y vào thanh ghi
    la  t5, X           # Lấy địa chỉ của X trong vùng nhớ chứa dữ liệu
    la  t6, Y           # Lấy địa chỉ của Y
    lw  t1, 0(t5)       # t1 = X
    lw  t2, 0(t6)       # t2 = Y

    # Tính biểu thức Z = 2X + Y với các thanh ghi
    add s0, t1, t1
    add s0, s0, t2

    # Lưu kết quả từ thanh ghi vào bộ nhớ
    la  t4, Z           # Lấy địa chỉ của Z
    sw  s0, 0(t4)       # Lưu giá trị của Z từ thanh ghi vào bộ nhớ
```

### Quan sát khi chạy từng bước

- **Lệnh `la`** (load address): lệnh giả, assembler dịch thành `auipc rd, offset_hi` + `addi rd, rd, offset_lo`. `pc` được dùng làm căn cứ để tính địa chỉ tuyệt đối của nhãn.

Trong cửa sổ **Labels**, có thể thấy địa chỉ của X, Y, Z trong vùng `.data` (bắt đầu từ 0x10010000 trong RARS). Double click vào nhãn để nhảy đến vị trí tương ứng trong cửa sổ Data Segment và xác nhận giá trị.

### Xác định vai trò của `lw` và `sw`

- `lw` (load word) - đọc dữ liệu từ bộ nhớ vào thanh ghi.
- `sw` (store word) - ghi dữ liệu từ thanh ghi ra bộ nhớ.

Các lệnh tương tự cho kích thước khác:
- `lb` / `sb` - load/store 1 byte (có sign-extend với `lb`).
- `lh` / `sh` - load/store 2 bytes (halfword).
- `lbu`, `lhu` - load byte/halfword không dấu (zero-extend).
