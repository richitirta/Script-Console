

--nilai pajak tidak terbentuk karena nota claim tidak terbentuk
--1)	Jika di script CLDED tidak ada kolom VAT dan TAX, maka script ini sebaiknya dijalankan
--2)	Otomatis script inisialisasi PNOMINAL_VAT dan TAX juga harus dijalankan

Update CLDED Set VAT=0, Tax=0, VATAMOUNT=0, TAXAMOUNT=0
go