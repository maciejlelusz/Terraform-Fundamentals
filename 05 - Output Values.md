Zanim przejdziesz do kolejnych zadań zmodyfikuj pliki konfiguracyjne w taki sposób, aby tag związany z przydzielonym Tobie numerem PODu zdefinioway był jako zmienna. Przypisuj tagi wszystkim obiektom, które bedziesz tworzyć.

Dodaj do pliku konfiguracyjnego nową sekcję

```
resource "aws_internet_gateway" "igw" {
  tags = { pod = var.pod }
}
```
Wykonaj ponownie polecenie ```terraform plan``` i sprawdź wynik polecenia. Wdróż konfigurację za pomocą ```terraform apply```. Zaloguj się do konsoli i sprawdź czy Internet Gateway jest powiązany z utworzonym VPC. Następnie skasuj całe środowisko.

Zmodyfikuj konfigurację obiektu ```igw```

```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = { pod = var.pod }
}
```
Ponownie wykonaj polecenie ```terraform plan``` i sprawdź wynik polecenia. Wdróżn konfigurację za pomocą ```terraform apply```. Zaleguj się do konsoli i sprawdź czy Internet Gateway jest powiązany z utworzonym VPC. Następnie skasuj całe środowisko.
