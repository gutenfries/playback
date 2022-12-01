#define TRUE 1

#define OUTFILE "example_1.mid"
#define INFILE "example_2.mid"

write_var_len(value) {
	register long long value;
	register long buffer;
	buffer = value & 0x7f;
	while ((value >>= 7) > 0) {
		buffer <<= 8;
		buffer |= 0x80;
		buffer += (value & 0x7f);
	}
	while (TRUE) {
		putc(buffer, OUTFILE);
		if (buffer & 0x80)
			buffer >>= 8;
		else
			break;
	}
}
unsigned long long read_var_len() {
	register unsigned long long value;
	register unsigned char c;
	if ((value = getc(INFILE)) & 0x80) {
		value &= 0x7f;
		do {
			value = (value << 7) + ((c = getc(INFILE)) & 0x7f);
		} while (c & 0x80);
	}
	return (value);
}
