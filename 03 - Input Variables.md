# Moduł 03. Input Variables

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Korzystać z input variables w Terraform.  
2. Oddzielać dane konfiguracyjne od kodu infrastruktury.  
3. Używać zmiennych zdefiniowanych w plikach, przekazywanych przez CLI oraz przez `terraform.tfvars`.  

---

## Ćwiczenie: Praca ze zmiennymi wejściowymi

### Krok 1. Modyfikacja środowiska

- Usuń środowisko **`aws-dev`**.  
- Usuń alias ze środowiska **`aws-prod`**.

⚠️ Uwaga! Sprawdź przed pracą:

- czy nie masz ustawionych zmiennych środowiskowych `AWS_ACCESS_KEY_ID` i `AWS_SECRET_ACCESS_KEY`,  
- czy w katalogu domowym `$HOME` nie masz zapisanej konfiguracji AWS CLI w folderze `.aws`.  

---

### Krok 2. Dodanie nowego zasobu VPC

Zmodyfikuj plik konfiguracyjny topologii, dodając:

```hcl
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { pod = "POD01" }
}
```

Następnie uruchom:

```bash
terraform plan
```

i sprawdź rezultat.

---

### Krok 3. Testowe klucze providera

Dodaj do konfiguracji providera klucze `access_key` oraz `secret_key`, nadając im wartość `"test"`:

```hcl
provider "aws" {
  region     = "eu-central-1"
  access_key = "test"
  secret_key = "test"
}
```

Uruchom ponownie:

```bash
terraform plan
```

i sprawdź rezultat.

---

### Krok 4. Klucze produkcyjne

Zmień `access_key` oraz `secret_key` na wartości przekazane przez instruktora i ponownie uruchom:

```bash
terraform plan
```

---

### Krok 5. Definicja zmiennych w pliku

Utwórz w głównym folderze projektu plik **`variables.tf`** o zawartości:

```hcl
variable "lab_aws_key" {}
variable "lab_aws_secret" {}
```

Zmodyfikuj konfigurację providera:

```hcl
provider "aws" {
  region     = "eu-central-1"
  access_key = var.lab_aws_key
  secret_key = var.lab_aws_secret
}
```

Wykonaj:

```bash
terraform plan
```

i sprawdź rezultat.

---

### Krok 6. Przekazywanie zmiennych z CLI

Uruchom `terraform plan` z parametrami `-var`, np.:

```bash
terraform plan -var "lab_aws_key=XXX" -var "lab_aws_secret=YYY"
```

---

### Krok 7. Plik `terraform.tfvars`

Utwórz plik **`terraform.tfvars`** w katalogu głównym projektu z zawartością:

```hcl
lab_aws_key    = "test"
lab_aws_secret = "test"
```

Wykonaj:

```bash
terraform plan
```

i sprawdź rezultat.

Następnie zmodyfikuj wartości zmiennych (`lab_aws_key` i `lab_aws_secret`), wpisując dane przekazane przez instruktora, i ponownie uruchom:

```bash
terraform plan
```
