# Moduł 06: Wprowadzanie zmian

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Przywracać wcześniejsze definicje zasobów Terraform.  
2. Aktualizować konfigurację istniejących zasobów.  
3. Ponownie łączyć Internet Gateway z VPC.  

---

## Ćwiczenie: Ponowne wdrożenie i modyfikacja IGW

### Krok 1. Przywrócenie konfiguracji IGW

Przywróć poniższą konfigurację obiektu `igw`:

```hcl
resource "aws_internet_gateway" "igw" {
  tags = { pod = var.pod }
}
```

Wdróż tak przygotowaną konfigurację:

```bash
terraform apply
```

---

### Krok 2. Dodanie powiązania z VPC

Po poprawnym wdrożeniu zmodyfikuj konfigurację obiektu `igw`, aby przywrócić powiązanie z utworzonym VPC:

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { pod = var.pod }
}
```

Ponownie wykonaj:

```bash
terraform plan
terraform apply
```

Zaloguj się do konsoli AWS i sprawdź, czy **Internet Gateway** jest powiązany z utworzonym VPC.  

---

### Krok 3. Usunięcie środowiska

Na zakończenie usuń całe środowisko:

```bash
terraform destroy
```
