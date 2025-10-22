# Moduł 05: Output Values

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Definiować tagi w konfiguracji jako zmienne.  
2. Tworzyć zasób Internet Gateway w Terraform.  
3. Łączyć Internet Gateway z VPC.  
4. Usuwać całe środowisko i ponownie je wdrażać.  

---

## Ćwiczenie: Internet Gateway i zmienne

### Krok 1. Definicja zmiennej

Zanim przejdziesz do kolejnych zadań, zmodyfikuj pliki konfiguracyjne w taki sposób, aby **tag związany z przydzielonym numerem POD** był zdefiniowany jako zmienna.

Przykład w pliku `variables.tf`:

```hcl
variable "pod" {}
```

W plikach konfiguracyjnych przypisuj ten tag wszystkim obiektom, które będziesz tworzyć.

---

### Krok 2. Dodanie Internet Gateway

Dodaj do pliku konfiguracyjnego sekcję:

```hcl
resource "aws_internet_gateway" "igw" {
  tags = { pod = var.pod }
}
```

Następnie:

```bash
terraform plan
terraform apply
```

Zaloguj się do konsoli AWS i sprawdź, czy **Internet Gateway** jest powiązany z utworzonym VPC.  
Następnie skasuj całe środowisko:

```bash
terraform destroy
```

---

### Krok 3. Powiązanie Internet Gateway z VPC

Zmodyfikuj konfigurację obiektu `igw`:

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
Następnie usuń całe środowisko:

```bash
terraform destroy
```
