# Moduł 07. Random Values

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Wykorzystywać providera `random` w Terraform.  
2. Generować pseudolosowe wartości do konfiguracji infrastruktury.  
3. Łączyć wygenerowane wartości z innymi zasobami (np. VPC, subnet).  
4. Używać zmiennych typu `output` do wyświetlania wartości z konfiguracji.  

---

## Ćwiczenie: Generator wartości losowych

### Krok 1. Dodanie providera `random`

Dodaj do projektu nowy resource w postaci generatora liczb pseudolosowych. Za jego pomocą będziesz generować losową wartość trzeciego oktetu podsieci, która zostanie utworzona w ramach VPC.

```hcl
provider "random" {}

resource "random_integer" "octet" {
  max = 255
  min = 0
}
```

Aby pobrać providera `random`, wykonaj ponownie:

```bash
terraform init
```

---

### Krok 2. Konfiguracja podsieci

Dodaj konfigurację podsieci i powiąż ją z utworzonym VPC:

```hcl
resource "aws_subnet" "subnet_private" {
  cidr_block              = "10.0.${random_integer.octet.result}.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = { pod = var.pod }
}
```

Wygenerowana wartość losowa znajduje się w obiekcie `result` i można się do niej odwołać jako `${random_integer.octet.result}`.

---

### Krok 3. Testowanie konfiguracji

1. Wdróż konfigurację:

   ```bash
   terraform apply
   ```

2. Usuń konfigurację:

   ```bash
   terraform destroy
   ```

3. Ponownie wdróż konfigurację i sprawdź, że wygenerowana wartość losowa uległa zmianie.

---

### Krok 4. Zmiana maski podsieci

Zmodyfikuj wartość atrybutu `cidr_block` w obiekcie `subnet_private`, zmieniając maskę z `/24` na `/25`:

```hcl
resource "aws_subnet" "subnet_private" {
  cidr_block              = "10.0.${random_integer.octet.result}.0/25"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = { pod = var.pod }
}
```

Następnie wykonaj:

```bash
terraform plan
terraform apply
```

➡️ Zauważ, że wartość losowej liczby **nie uległa zmianie**.

---

### Krok 5. Zmienna `output`

Zadeklaruj zmienną typu `output` i przypisz jej wartość utworzonego wcześniej bloku CIDR:

```hcl
output "vpc_subnet" {
  value = aws_subnet.subnet_private.cidr_block
}
```

Następnie wykonaj:

```bash
terraform plan
terraform apply
```

➡️ Zobacz, że wartość zmiennej `output` została wypisana na konsoli.

Dodatkowo sprawdź wartości:

```bash
terraform output
terraform output vpc_subnet
```
