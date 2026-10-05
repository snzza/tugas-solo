enum StatusBayar { berhasil, pinSalah, terblokir, melebihiLimit, saldoKurang }

String pinBenar = "1234";
int saldo = 5000000;
int totalHariIni = 0;
int salahPin = 0;
bool terblokir = false;
final List<String> riwayat = [];

bool cekPin(String pin) {
  if (pin == pinBenar) {
    salahPin = 0;
    return true;
  }
  salahPin++;
  if (salahPin == 3) {
    terblokir = true;
  }
  return false;
}

bool cekSaldo(int nominal) {
  return saldo >= nominal;
}

bool cekLimit(int nominal) {
  return totalHariIni + nominal <= 2000000;
}

void simpanTransaksi(int nominal) {
  saldo = saldo - nominal;
  totalHariIni = totalHariIni + nominal;
  riwayat.add("Bayar $nominal");
}

StatusBayar bayar(String pin, int nominal) {
  if (terblokir) {
    return StatusBayar.terblokir;
  }
  if (!cekPin(pin)) {
    if (terblokir) {
      return StatusBayar.terblokir;
    }
    return StatusBayar.pinSalah;
  }
  if (!cekSaldo(nominal)) {
    return StatusBayar.saldoKurang;
  }
  if (!cekLimit(nominal)) {
    return StatusBayar.melebihiLimit;
  }
  simpanTransaksi(nominal);
  return StatusBayar.berhasil;
}

void main() {
  print(bayar("1234", 1500000));
  print(bayar("1234", 4000000));
  print(bayar("1234", 600000));
  print(bayar("0000", 100000));
  print(bayar("0000", 100000));
  print(bayar("0000", 100000));
  print(bayar("1234", 100000));
  print("Saldo akhir: $saldo");
  print("Riwayat pembayaran:");
  for (String r in riwayat) {
    print(r);
  }
}
