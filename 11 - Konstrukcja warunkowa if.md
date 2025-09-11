Dodamy teraz sprawdzenie, czy wskazany plik z kluczem SSH istnieje na dysku, aby uniknąć błędów w przetwarzaniu opisu infrastruktury, gdyby pliku brakowało. Zastosujemy konstrukcję warunkową ```if``` oraz funkcję systemową ```fileexists()```. Jeżeli plik nie zostanie znaleziony zamiast zwracać błąd w parametrze ```public_key``` umieszczamy pustą wartość.

```
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = fileexists("~/.ssh/TerraformLab.pub") ? file("~/.ssh/TerraformLab.pub") : ""
  tags = { pod = var.pod }
}
```
Wykonaj ponownie polecenie ```terraform plan```

