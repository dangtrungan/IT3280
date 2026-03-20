# Báo cáo Bài 4: Các lệnh số học và logic

---

## Assignment 1 — Chạy mô phỏng Home Assignment trên RARS

### Mô tả

Assignment 1 yêu cầu tạo project trong RARS để thực thi chương trình từ Home Assignment 1, sau đó dịch và chạy mô phỏng. Cụ thể, sinh viên phải khởi tạo các toán hạng, chạy từng lệnh, và quan sát giá trị thanh ghi cũng như trạng thái bộ nhớ.

Chương trình được thực thi là thuật toán phát hiện tràn số có dấu (signed overflow) khi cộng hai số 32-bit `s1` và `s2`. Kết quả được lưu vào thanh ghi `t0`: bằng `1` nếu tràn số xảy ra, bằng `0` nếu không.

### Code (từ Home Assignment 1)

```asm
# Laboratory Exercise 4, Home Assignment 1
.text
    # TODO: Thiết lập giá trị cho s1 và s2 với trường hợp khác nhau
    # Thuật toán xác định tràn số
    addi t0, zero, 0       # Mặc định không có tràn số
    add  s3, s1, s2        # s3 = s1 + s2
    xor  t1, s1, s2        # Kiểm tra s1 với s2 có cùng dấu
    blt  t1, zero, EXIT    # Nếu t1 là số âm, s1 và s2 khác dấu → không tràn
    blt  s1, zero, NEGATIVE # Kiểm tra s1 và s2 là số âm hay không âm
    bge  s3, s1, EXIT      # s1 không âm, nếu s3 >= s1 → không tràn
    jal  x0, OVERFLOW

NEGATIVE:
    bge  s1, s3, EXIT      # s1 âm, nếu s1 >= s3 → không tràn

OVERFLOW:
    addi t0, zero, 1       # Tràn số xảy ra

EXIT:
```

### Nguyên lý phát hiện tràn số

Tràn số có dấu chỉ có thể xảy ra khi hai toán hạng **cùng dấu**. Cụ thể:

- Nếu `s1` và `s2` **khác dấu** (`t1 = s1 XOR s2` có bit dấu bằng 1 → âm): tràn số **không thể** xảy ra, nhảy thẳng đến `EXIT`.
- Nếu cả hai **không âm** và tổng `s3 < s1`: tràn số **xảy ra**.
- Nếu cả hai **âm** và tổng `s3 > s1`: tràn số **xảy ra**.

### Các bước thực hiện trong RARS

1. Mở RARS và tạo file mới, nhập đoạn code trên.
2. Thiết lập giá trị cho `s1` và `s2` bằng lệnh `li` phía trên đoạn thuật toán để kiểm thử từng trường hợp.
3. Chọn **Assemble** để dịch chương trình.
4. Dùng chức năng **Step** để chạy từng lệnh một.
5. Quan sát cửa sổ **Registers** sau mỗi bước, chú ý giá trị `t0`, `t1`, `s3` và thanh ghi `pc`.

### Các trường hợp kiểm thử gợi ý

| `s1`          | `s2`          | Kết quả `t0` | Giải thích              |
|---------------|---------------|-------------|-------------------------|
| `0x7FFFFFFF`  | `0x00000001`  | `1`         | INT_MAX + 1 → tràn dương |
| `0x80000000`  | `0xFFFFFFFF`  | `1`         | INT_MIN + (-1) → tràn âm |
| `0x00000010`  | `0x00000020`  | `0`         | Cộng bình thường         |
| `0x7FFFFFFF`  | `0x80000000`  | `0`         | Khác dấu, không tràn    |

---

## Assignment 2 — Thao tác Bit trên Thanh ghi

### Mô tả

Bài này thực hiện một chuỗi thao tác bit trên thanh ghi `s0` với giá trị khởi đầu là `0x12345678`.

### Code

```asm
.text
    li   s0, 0x12345678     # s0 = 0x12345678

    srli s1, s0, 24         # Trích xuất MSB của thanh ghi s0

    andi s0, s0, 0xFFFFFF00 # Xóa LSB của thanh ghi s0

    ori  s0, s0, 0x11       # Thiết lập LSB của thanh ghi s0 (bit 7 đến bit 0 được thiết lập bằng 1)

    andi s0, s0, 0x00000000 # Xóa thanh ghi s0 bằng cách dùng các lệnh logic (s0 = 0)
```

### Giải thích từng bước

1. **Khởi tạo:** `s0 = 0x12345678`
2. **Trích xuất MSB:** Dịch phải logic 24 bit → `s1 = 0x12` (byte cao nhất của `s0`)
3. **Xóa LSB:** AND với `0xFFFFFF00` → `s0 = 0x12345600` (byte thấp nhất bị xóa)
4. **Thiết lập LSB:** OR với `0x11` → `s0 = 0x12345611` (ghi đè byte thấp thành `0x11`)
5. **Xóa thanh ghi:** AND với `0x00000000` → `s0 = 0x00000000`

### Kết quả

| Thanh ghi | Giá trị cuối |
|-----------|-------------|
| `s0`      | `0x00000000` |
| `s1`      | `0x00000012` |

---

## Assignment 3 — Các phép toán cơ bản

Bài này gồm bốn bài nhỏ (3a–3d), mỗi bài minh họa một phép toán hoặc cấu trúc điều kiện khác nhau.

---

### Assignment 3a — Phủ định số nguyên (Negation)

#### Code

```asm
.text
    li   s1, 36
    sub  s0, zero, s1
```

#### Giải thích

Lấy `zero - s1` để tính phủ định của `s1`. Đây là cách chuẩn trong RISC-V để tính số đối mà không cần lệnh `neg` riêng.

#### Kết quả

| Thanh ghi | Giá trị |
|-----------|---------|
| `s1`      | `36`    |
| `s0`      | `-36`   |

---

### Assignment 3b — Sao chép giá trị (Move)

#### Code

```asm
.text
    li   s1, 36
    add  s2, zero, s1
```

#### Giải thích

Cộng `zero + s1` để sao chép giá trị từ `s1` sang `s2`. Đây là cách mô phỏng lệnh `mv` bằng lệnh `add`.

#### Kết quả

| Thanh ghi | Giá trị |
|-----------|---------|
| `s1`      | `36`    |
| `s2`      | `36`    |

---

### Assignment 3c — Đảo bit (Bitwise NOT)

#### Code

```asm
.text
    li   s0, 36
    xori s0, s0, -1
```

#### Giải thích

XOR với `-1` (tất cả các bit đều là `1`) tương đương với phép đảo bit NOT. Kết quả là phần bù 1 của `36`.

- `36` ở dạng nhị phân 32-bit: `0x00000024`
- Sau `xori` với `-1` (`0xFFFFFFFF`): `s0 = 0xFFFFFFDB` (tức `-37` ở dạng bù 2)

#### Kết quả

| Thanh ghi | Giá trị (hex) | Giá trị (decimal, signed) |
|-----------|--------------|--------------------------|
| `s0`      | `0xFFFFFFDB` | `-37`                    |

---

### Assignment 3d — So sánh có điều kiện (Conditional Branch)

#### Code

```asm
.text
    li   s1, 36
    li   s2, 18
    bge  s2, s1, exit

exit:
```

#### Giải thích

Lệnh `bge s2, s1, exit` nhảy đến `exit` nếu `s2 >= s1`, tức `18 >= 36`. Điều kiện này **sai**, nên chương trình tiếp tục chạy tuần tự và tự nhiên đến nhãn `exit` mà không nhảy.

#### Kết quả

Nhánh **không** được thực thi; luồng thực thi chạy thẳng xuống `exit` theo thứ tự tuần tự.

---

## Assignment 4 — Phát hiện Tràn số (Overflow Detection)

### Mô tả

Bài này kiểm tra xem phép cộng hai số nguyên có dấu có gây tràn số hay không, sau đó tăng biến đếm `t0` lên `1` nếu phát hiện tràn.

### Code

```asm
.text
    li   t0, 0
    li   s1, 0x7FFFFFFF
    li   s2, 1
    add  s3, s1, s2
    xor  t1, s1, s2
    blt  t1, zero, EXIT
    xor  t2, s1, s3
    bge  t2, zero, EXIT
    jal  x0, OVERFLOW

OVERFLOW:
    addi t0, t0, 1

EXIT:
```

### Giải thích từng bước

1. **Khởi tạo:** `t0 = 0`, `s1 = 0x7FFFFFFF` (INT_MAX), `s2 = 1`
2. **Thực hiện phép cộng:** `s3 = s1 + s2 = 0x80000000` (tràn về số âm)
3. **Kiểm tra dấu đầu vào:** XOR hai toán hạng `s1` và `s2`. Nếu kết quả âm (hai số khác dấu), tràn số **không thể** xảy ra → nhảy đến `EXIT`.
   - `0x7FFFFFFF XOR 0x00000001 = 0x7FFFFFFE` → dương → không thoát sớm
4. **Kiểm tra dấu đầu ra:** XOR `s1` với kết quả `s3`. Nếu kết quả dương (cùng dấu với đầu vào), tràn số **không xảy ra** → nhảy đến `EXIT`.
   - `0x7FFFFFFF XOR 0x80000000 = 0xFFFFFFFF` → âm → tràn số được xác nhận
5. **Xử lý tràn:** Nhảy đến `OVERFLOW`, tăng `t0` lên `1`.

### Thuật toán phát hiện tràn

Tràn số xảy ra khi hai điều kiện cùng đúng:
- Hai toán hạng **cùng dấu** (bit dấu của `s1 XOR s2` bằng 0)
- Kết quả **khác dấu** với toán hạng (bit dấu của `s1 XOR s3` bằng 1)

### Kết quả

| Thanh ghi | Giá trị      | Ghi chú                     |
|-----------|--------------|-----------------------------|
| `s1`      | `0x7FFFFFFF` | INT_MAX                     |
| `s2`      | `0x00000001` |                             |
| `s3`      | `0x80000000` | Kết quả tràn (INT_MIN)      |
| `t0`      | `1`          | Tràn số được phát hiện      |

---

## Assignment 5 — Nhân bằng Dịch bit (Multiplication via Shift)

### Mô tả

Bài này thực hiện phép nhân `t1 * t2` (tức `6 * 8`) bằng cách tìm `n` sao cho `t2 = 2^n`, rồi dùng phép dịch trái `SLL` thay cho phép nhân trực tiếp.

### Code

```asm
.text
    li   t1, 6             # t1 = 6
    li   t2, 8             # t2 = 8

    mv   t3, t2            # t3 = t2.copy()
    li   t4, 0             # t4 = 0

find_n:
    li   t5, 1
    beq  t3, t5, done_find  # if t3 == 1 break;
    srli t3, t3, 1         # t3 = t3 >> 1
    addi t4, t4, 1         # n += 1
    j    find_n

done_find:
    sll  t0, t1, t4
```

### Giải thích từng bước

1. **Khởi tạo:** `t1 = 6`, `t2 = 8`
2. **Tìm số mũ `n`:** Vòng lặp `find_n` dịch `t3` (bản sao của `t2`) sang phải 1 bit mỗi lần, đếm số lần dịch vào `t4`, cho đến khi `t3 == 1`.
   - Lần 1: `t3 = 8 >> 1 = 4`, `t4 = 1`
   - Lần 2: `t3 = 4 >> 1 = 2`, `t4 = 2`
   - Lần 3: `t3 = 2 >> 1 = 1`, `t4 = 3` → thoát vòng lặp
3. **Tính kết quả:** `t0 = t1 << t4 = 6 << 3 = 48`

### Tại sao đúng

Vì `8 = 2^3`, nên `6 × 8 = 6 × 2^3 = 6 << 3`. Kỹ thuật này chỉ đúng khi `t2` là lũy thừa của 2.

### Kết quả

| Thanh ghi | Giá trị | Ghi chú               |
|-----------|---------|-----------------------|
| `t1`      | `6`     |                       |
| `t2`      | `8`     | `= 2^3`               |
| `t4`      | `3`     | Số mũ tìm được        |
| `t0`      | `48`    | Kết quả `6 × 8 = 48`  |

---
