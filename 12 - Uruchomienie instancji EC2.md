# Moduł 12: Uruchomienie instancji EC2 z publicznym adresem IP

## Cel modułu

- Nauczyć się tworzyć kompletną infrastrukturę potrzebną do uruchomienia instancji EC2 z dostępem publicznym.
- Zrozumieć rolę poszczególnych komponentów: Security Group, Route Table i Route Table Association.
- Zbudować instancję EC2, uzyskać jej adres IP i połączyć się z nią przez SSH.

---

## Wprowadzenie

Aby uruchomić działającą instancję EC2, potrzebujemy kilku zasobów sieciowych:
- **Security Group** – kontroluje ruch przychodzący i wychodzący.
- **Route Table** – definiuje reguły trasowania ruchu sieciowego.
- **Route Table Association** – wiąże tablicę routingu z podsiecią.
- **EC2 Instance** – właściwa maszyna wirtualna w chmurze AWS.

---

## Krok po kroku

### 1. Utworzenie Security Group

Zacznij od zdefiniowania grupy bezpieczeństwa, która pozwala na dowolny ruch przychodzący i wychodzący:

```hcl
resource "aws_security_group" "sg_any" {
  name   = "sg_any"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    pod = var.pod
  }
}
```

> ⚠️ Uwaga: taka konfiguracja otwiera wszystkie porty na świat. Stosuj ją wyłącznie w środowisku testowym lub szkoleniowym.

---

### 2. Dodanie tablicy routingu

Zdefiniuj tablicę routingu, która kieruje ruch internetowy przez bramę (Internet Gateway):

```hcl
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    pod = var.pod
  }
}
```

---

### 3. Powiązanie tablicy routingu z podsiecią

Połącz tablicę routingu z wybraną podsiecią, aby ruch z niej był kierowany do Internetu:

```hcl
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.rtb_public.id
}
```

> 💡 Upewnij się, że wskazana podsieć ma możliwość przydzielania publicznych adresów IP (np. przez `map_public_ip_on_launch = true`).

---

### 4. Utworzenie instancji EC2

Teraz możesz zdefiniować i uruchomić instancję EC2:

```hcl
resource "aws_instance" "ec2_server" {
  ami                    = "ami-0c960b947cbb2dd16"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name               = aws_key_pair.ec2key.key_name

  tags = {
    pod = var.pod
  }
}
```

> AMI `ami-0c960b947cbb2dd16` to obraz Ubuntu dla regionu `eu-central-1`. Jeśli używasz innego regionu, znajdź odpowiedni identyfikator AMI w konsoli AWS.

---

### 5. Wdrożenie konfiguracji

Zapisz zmiany i wykonaj polecenia:

```bash
terraform plan
terraform apply
```

Po zakończeniu wdrożenia Terraform wyświetli m.in. informacje o uruchomionej instancji EC2. Odszukaj wśród nich **publiczny adres IP**.

---

### 6. Połączenie z serwerem

Połącz się z instancją EC2 przez SSH, korzystając z klucza prywatnego i użytkownika `ubuntu`:

```bash
ssh -i ~/.ssh/TerraformLab ubuntu@<publiczny_adres_IP>
```

---

### 7. Dodanie zmiennych typu `output`

Aby Terraform automatycznie wypisywał na ekran publiczny i prywatny adres IP, dodaj do swojej konfiguracji dwa bloki `output`:

```hcl
output "public_ip" {
  value = aws_instance.ec2_server.public_ip
}

output "private_ip" {
  value = aws_instance.ec2_server.private_ip
}
```

> Dodanie sekcji `output` nie powoduje modyfikacji działającego środowiska – możesz ją bezpiecznie dodać i uruchomić `terraform refresh` lub `terraform apply`.

---

## Weryfikacja i testy

1. Uruchom `terraform apply` i poczekaj, aż Terraform zakończy tworzenie zasobów.
2. Sprawdź w konsoli AWS, że instancja działa i ma przypisany publiczny adres IP.
3. Połącz się z nią przez SSH i zweryfikuj, że masz dostęp do systemu Ubuntu.
4. Upewnij się, że `terraform output` wyświetla oba adresy IP (publiczny i prywatny).

---

## Uwaga końcowa

Nie usuwaj wdrożonego środowiska po tym zadaniu – będzie ono wykorzystane w kolejnych modułach.
