.text
	li   s0, 0x12345678     # s0 = 0x12345678
	
	srli s1, s0, 24         # Trích xuất MSB của thanh ghi s0
	
	andi s0, s0, 0xFFFFFF00 # Xóa LSB của thanh ghi s0
	
	ori  s0, s0, 0x11       # Thiết lập LSB của thanh ghi s0 (bit 7 đến bit 0 được thiết lập bằng 1)
	
	andi s0, s0, 0x00000000 # Xóa thanh ghi s0 bằng cách dùng các lệnh logic (s0 = 0)