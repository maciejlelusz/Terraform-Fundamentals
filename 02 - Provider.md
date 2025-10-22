# Moduł 02: Provider

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Zrozumieć pojęcie providera w Terraform.  
2. Skonfigurować provider — ustawić region, autentykację.  
3. Używać providerów w swoich plikach Terraform.

---

## Co to jest provider?

Provider to plugin, który umożliwia Terraformowi komunikację z zewnętrzną platformą (np. AWS, Azure, Google Cloud). Dotyczy on:

- Tworzenia,
- Modyfikacji,
- Usuwania zasobów w danym systemie.

---

## Konfiguracja providera

1. W pliku `.tf` deklarujesz provider:

   ```hcl
   provider "aws" {
     region  = "eu-central-1"
     version = "~> 5.0"
   }
   ```

2. Autentykacja — przykładowe metody:

   - Zmienna środowiskowa (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)  
   - Plik kredencji (np. `~/.aws/credentials`)  
   - Usługi zarządzane (np. IAM role, jeśli działasz w EC2)

3. Ustawienia dodatkowe:

   - wersja providera (np. `version` w bloku `provider`)  
   - aliasy (np. gdy używasz kilku regionów albo takie samego providera wiele razy)  
   - konfiguracje backendu, jeśli provider wymaga (np. dla state, plików etc.), choć backend zwykle konfigurujesz osobno

---

## Przykład praktyczny

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Główny provider
provider "aws" {
  region = "eu-central-1"
}

# Dodatkowy provider z aliasem (np. inny region)
provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

resource "aws_s3_bucket" "bucket_main" {
  bucket = "projekt-bucket-glowny"
  acl    = "private"
}

resource "aws_s3_bucket" "bucket_west" {
  provider = aws.us_west
  bucket   = "projekt-bucket-west"
  acl      = "private"
}
```

---

## Najlepsze praktyki

- Zawsze określ **źródło** (`source`) i **wersję** (`version`) w `required_providers`.  
- Używaj aliasów, jeśli masz działające różne konfiguracje providera (np. regiony, konta).  
- Trzymaj konfigurację autentykacji w bezpiecznym miejscu — nie wrzucaj kluczy do repozytorium.  
- Sprawdzaj kompatybilność wersji providera ze swoją wersją Terraform.

---

## Zadanie domowe / ćwiczenie

- Stwórz projekt, który używa providera AWS i GCP jednocześnie.  
- Zdefiniuj po jednym zasobie (np. S3 bucket / Cloud Storage bucket) dla każdego providera.  
- Upewnij się, że konfiguracje autentykacji i regionów są poprawnie ustawione.  
- Przetestuj: `terraform init`, `terraform plan`, `terraform apply`, a potem `terraform destroy`.
