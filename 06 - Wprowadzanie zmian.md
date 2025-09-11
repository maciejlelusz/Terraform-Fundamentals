Przywróć ponownie poniższą konfigurację obiektu ```igw```

```
resource "aws_internet_gateway" "igw" {
  tags = { pod = var.pod} 
}
```
Wdróż tak przygotowaną konfigurację. Gdy zostanie ona poprawnie wdrożona zmodyfikuj konfigurację obiektu ```igw``` przywracając powiązanie z utworzonym VPC

```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = { pod = var.pod }
}
```
Ponownie wykonaj polecenie ```terraform plan``` i sprawdź wynik polecenia. Wdróż zmiany za pomocą ```terraform apply```. Zaloguj się do konsoli i sprawdź czy Internet Gateway jest powiązany z utworzonym VPC. Następnie skasuj całe środowisko.
