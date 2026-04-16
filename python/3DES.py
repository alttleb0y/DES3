from pathlib import Path

IP = [
	58, 50, 42, 34, 26, 18, 10, 2,
	60, 52, 44, 36, 28, 20, 12, 4,
	62, 54, 46, 38, 30, 22, 14, 6,
	64, 56, 48, 40, 32, 24, 16, 8,
	57, 49, 41, 33, 25, 17, 9, 1,
	59, 51, 43, 35, 27, 19, 11, 3,
	61, 53, 45, 37, 29, 21, 13, 5,
	63, 55, 47, 39, 31, 23, 15, 7,
]

FP = [
	40, 8, 48, 16, 56, 24, 64, 32,
	39, 7, 47, 15, 55, 23, 63, 31,
	38, 6, 46, 14, 54, 22, 62, 30,
	37, 5, 45, 13, 53, 21, 61, 29,
	36, 4, 44, 12, 52, 20, 60, 28,
	35, 3, 43, 11, 51, 19, 59, 27,
	34, 2, 42, 10, 50, 18, 58, 26,
	33, 1, 41, 9, 49, 17, 57, 25,
]

E = [
	32, 1, 2, 3, 4, 5,
	4, 5, 6, 7, 8, 9,
	8, 9, 10, 11, 12, 13,
	12, 13, 14, 15, 16, 17,
	16, 17, 18, 19, 20, 21,
	20, 21, 22, 23, 24, 25,
	24, 25, 26, 27, 28, 29,
	28, 29, 30, 31, 32, 1,
]

P = [
	16, 7, 20, 21,
	29, 12, 28, 17,
	1, 15, 23, 26,
	5, 18, 31, 10,
	2, 8, 24, 14,
	32, 27, 3, 9,
	19, 13, 30, 6,
	22, 11, 4, 25,
]

PC1 = [
	57, 49, 41, 33, 25, 17, 9,
	1, 58, 50, 42, 34, 26, 18,
	10, 2, 59, 51, 43, 35, 27,
	19, 11, 3, 60, 52, 44, 36,
	63, 55, 47, 39, 31, 23, 15,
	7, 62, 54, 46, 38, 30, 22,
	14, 6, 61, 53, 45, 37, 29,
	21, 13, 5, 28, 20, 12, 4,
]

PC2 = [
	14, 17, 11, 24, 1, 5,
	3, 28, 15, 6, 21, 10,
	23, 19, 12, 4, 26, 8,
	16, 7, 27, 20, 13, 2,
	41, 52, 31, 37, 47, 55,
	30, 40, 51, 45, 33, 48,
	44, 49, 39, 56, 34, 53,
	46, 42, 50, 36, 29, 32,
]

SHIFTS = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

SBOXES = [
	[
		[14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7],
		[0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8],
		[4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0],
		[15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13],
	],
	[
		[15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10],
		[3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5],
		[0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15],
		[13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9],
	],
	[
		[10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8],
		[13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1],
		[13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7],
		[1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12],
	],
	[
		[7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15],
		[13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9],
		[10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4],
		[3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14],
	],
	[
		[2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9],
		[14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6],
		[4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14],
		[11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3],
	],
	[
		[12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11],
		[10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8],
		[9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6],
		[4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13],
	],
	[
		[4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1],
		[13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6],
		[1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2],
		[6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12],
	],
	[
		[13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7],
		[1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2],
		[7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8],
		[2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11],
	],
]


def permute(block, table, in_bits):
	out = 0
	for pos in table:
		bit = (block >> (in_bits - pos)) & 1
		out = (out << 1) | bit
	return out


def left_rotate(value, shift, width):
	mask = (1 << width) - 1
	return ((value << shift) & mask) | (value >> (width - shift))


def sbox_substitute(value48):
	out = 0
	for i in range(8):
		chunk = (value48 >> (42 - 6 * i)) & 0x3F
		row = ((chunk & 0x20) >> 4) | (chunk & 0x01)
		col = (chunk >> 1) & 0x0F
		out = (out << 4) | SBOXES[i][row][col]
	return out


def f_function(r32, k48):
	expanded = permute(r32, E, 32)
	xored = expanded ^ k48
	sboxed = sbox_substitute(xored)
	return permute(sboxed, P, 32)


def key_schedule(key64):
	key56 = permute(key64, PC1, 64)
	c = (key56 >> 28) & ((1 << 28) - 1)
	d = key56 & ((1 << 28) - 1)
	round_keys = []
	for shift in SHIFTS:
		c = left_rotate(c, shift, 28)
		d = left_rotate(d, shift, 28)
		cd = (c << 28) | d
		round_keys.append(permute(cd, PC2, 56))
	return round_keys


def des_block(block64, key64, decrypt=False):
	round_keys = key_schedule(key64)
	if decrypt:
		round_keys = list(reversed(round_keys))

	ip = permute(block64, IP, 64)
	l = (ip >> 32) & 0xFFFFFFFF
	r = ip & 0xFFFFFFFF

	for k in round_keys:
		l, r = r, l ^ f_function(r, k)

	preoutput = (r << 32) | l
	return permute(preoutput, FP, 64)


def triple_des(block64, k1, k2, k3):
	step1 = des_block(block64, k1, decrypt=False)
	step2 = des_block(step1, k2, decrypt=True)
	return des_block(step2, k3, decrypt=False)


def read_int_file(path):
	text = path.read_text(encoding="ascii").strip().split()
	values = []
	for token in text:
		if not token:
			continue
		if all(c in "01" for c in token):
			values.append(int(token, 2))
		else:
			values.append(int(token, 16))
	return values


def parse_output_value(text):
	token = text.strip()
	if not token:
		return None
	if all(c in "01" for c in token):
		return int(token, 2)
	return int(token, 16)


def reverse_bits(value, width):
	out = 0
	for _ in range(width):
		out = (out << 1) | (value & 1)
		value >>= 1
	return out


def byte_swap64(value):
	out = 0
	for i in range(8):
		out = (out << 8) | ((value >> (8 * i)) & 0xFF)
	return out


def main():
	base_dir = Path(__file__).resolve().parents[1] / "DES3"
	idata_path = base_dir / "idata.txt"
	key_path = base_dir / "key123.txt"
	out_path = base_dir / "output.txt"

	blocks = read_int_file(idata_path)
	keys = read_int_file(key_path)
	if len(keys) == 2:
		keys.append(keys[0])
	if len(keys) != 3:
		raise ValueError("key123.txt must have 2 or 3 hex keys")

	k1, k2, k3 = keys
	for block in blocks:
		out = triple_des(block, k1, k2, k3)
		out_hex = f"{out:016X}"
		out_bin = f"{out:064b}"
		print(f"3DES (hex): {out_hex}")
		print(f"3DES (bin): {out_bin}")

		if out_path.exists():
			ref_text = out_path.read_text(encoding="ascii")
			ref_val = parse_output_value(ref_text)
			if ref_val is not None:
				match = (ref_val == out)
				print(f"Compare with output.txt: {match}")
				if not match:
					rev = reverse_bits(out, 64)
					bswap = byte_swap64(out)
					rev_bswap = reverse_bits(bswap, 64)
					print(f"Compare bit-reversed: {ref_val == rev}")
					print(f"Compare byte-swapped: {ref_val == bswap}")
					print(f"Compare byte-swap+bit-rev: {ref_val == rev_bswap}")


if __name__ == "__main__":
	main()
