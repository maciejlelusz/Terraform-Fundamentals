# Moduł 14: Tworzenie wielu podsieci i instancji EC2 w różnych strefach dostępności

## Cel modułu

- Utworzenie trzech podsieci w ramach jednego VPC – każdej w innej Availability Zone (AZ).
- Uruchomienie jednej instancji EC2 w każdej podsieci.
- Zastosowanie konstrukcji `for_each` i funkcji `cidrsubnet()` do dynamicznego tworzenia zasobów.

---

## 1. Przygotowanie konfiguracji

Dotychczas Terraform tworzył jedną podsieć i jedną instancję EC2. W tym ćwiczeniu rozbudujemy konfigurację tak, aby w VPC znajdowały się **trzy podsieci**, każda w innej strefie dostępności, i aby w każdej z nich została uruchomiona **jedna instancja EC2**.

Zachowaj dotychczasowe definicje następujących zasobów, ponieważ nie wymagają one zmian:

- `aws_internet_gateway`
- `aws_key_pair`
- `aws_route_table`
- `aws_security_group`

Usuń natomiast zasoby `random_integer` oraz parametr `count` z definicji instancji EC2.

---

## 2. Definicja lokalnej wartości CIDR dla VPC

Bezpośrednio pod definicją providera dodaj lokalną wartość, wskazującą na blok CIDR przypisany do VPC:

```hcl
locals {
  vpc_cidr_block = "10.0.0.0/16"
}
```

---

## 3. Modyfikacja definicji VPC

Wykorzystaj lokalną zmienną `local.vpc_cidr_block` w definicji VPC:

```hcl
resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { pod = var.pod }
}
```

---

## 4. Zmienna z listą stref dostępności i indeksów podsieci

Zdefiniuj nową zmienną, która przypisuje poszczególnym strefom dostępności numery identyfikacyjne:

```hcl
variable "subnets_in_az" {
  default = {
    "eu-central-1a" = 0,
    "eu-central-1b" = 1,
    "eu-central-1c" = 2
  }
}
```

---

## 5. Tworzenie podsieci w pętli `for_each`

Użyj pętli `for_each`, aby utworzyć podsieci na podstawie zmiennej `subnets_in_az`. Funkcja `cidrsubnet()` automatycznie wydzieli kolejne podsieci z głównego bloku VPC.

```hcl
resource "aws_subnet" "subnet_private" {
  for_each = var.subnets_in_az

  availability_zone      = each.key
  cidr_block             = cidrsubnet(aws_vpc.vpc.cidr_block, 9, each.value)
  vpc_id                 = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  
  tags = { pod = var.pod }
}
```

> 💡 Parametry `each.key` i `each.value` pozwalają w pętli `for_each` odwoływać się do bieżącego klucza i jego wartości — w tym przypadku: nazwy strefy AZ oraz indeksu podsieci.

---

## 6. Powiązanie podsieci z tablicą routingu

Analogicznie, wykorzystaj `for_each`, aby przypisać każdą podsieć do istniejącej tablicy routingu:

```hcl
resource "aws_route_table_association" "rta_subnet_public" {
  for_each = var.subnets_in_az

  subnet_id      = aws_subnet.subnet_private[each.key].id
  route_table_id = aws_route_table.rtb_public.id
}
```

---

## 7. Definicja instancji EC2 w wielu strefach

Każda podsieć otrzyma własną instancję EC2 — również za pomocą pętli `for_each`:

```hcl
resource "aws_instance" "ec2_server" {
  for_each = var.subnets_in_az

  ami                    = "ami-0c960b947cbb2dd16"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_private[each.key].id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name               = aws_key_pair.ec2key.key_name

  tags = { pod = var.pod }
}
```

> 🧠 Każda instancja zostanie umieszczona w innej strefie AZ, zgodnie z mapowaniem w zmiennej `subnets_in_az`.

---

## 8. Zmiana definicji `output`

Ponieważ teraz tworzysz wiele zasobów, zmienne `output` muszą obsługiwać dane w postaci struktur (map). Terraform pozwala na iterację po elementach w pętli `for`:

```hcl
output "vpc_subnet" {
  value = {
    for az in aws_subnet.subnet_private:
      az.availability_zone => az.cidr_block
  }
}

output "public_ip" {
  value = {
    for az in aws_instance.ec2_server:
      az.availability_zone => az.public_ip
  }
}

output "private_ip" {
  value = {
    for az in aws_instance.ec2_server:
      az.availability_zone => az.private_ip
  }
}
```

---

## 9. Wdrożenie i weryfikacja

1. Uruchom plan wdrożenia:
   ```bash
   terraform plan
   ```
2. Następnie zastosuj konfigurację:
   ```bash
   terraform apply
   ```
3. W konsoli AWS zweryfikuj, że powstały:
   - trzy podsieci (`subnet_private`), każda w innej AZ,
   - trzy instancje EC2 — po jednej w każdej podsieci.

---

## Podsumowanie

W tym module:

- Poznałeś użycie `for_each` do dynamicznego tworzenia wielu zasobów.
- Zastosowałeś funkcję `cidrsubnet()` do automatycznego podziału przestrzeni adresowej.
- Zrozumiałeś, jak prezentować dane wyjściowe (`output`) w formacie mapy, łącząc zasoby z ich strefami dostępności.

Tak przygotowane środowisko stanowi podstawę do dalszej automatyzacji i skalowania infrastruktury w chmurze AWS.

