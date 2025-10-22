# Modul 01: Przygotowanie do pracy z Terraform

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Zrozumieć, czym jest Terraform i dlaczego się go używa.  
2. Zainstalować Terraform na swoim komputerze.  
3. Przygotować środowisko pracy: utworzyć katalog projektu, plik konfiguracyjny i zweryfikować instalację.  
4. Pierwszy raz uruchomić Terraform: `init`, `plan`, `apply` (na małym przykładzie).

---

## Wymagania wstępne

Przed rozpoczęciem upewnij się, że masz:

- dostęp do komputera z systemem operacyjnym Linux, macOS lub Windows,  
- połączenie z internetem,  
- uprawnienia administratora / możliwość instalacji aplikacji,  
- terminal / wiersz poleceń, w którym możesz uruchamiać komendy.

---

## Lekcja: Co to jest Terraform?

- Terraform to narzędzie typu *Infrastructure as Code (IaC)* — pozwala definiować infrastrukturę w plikach, a następnie ją automatycznie tworzyć, zmieniać i usuwać.  
- Konfiguracje są deklaratywne — opisują stan docelowy, nie kolejne kroki.  
- Terraform utrzymuje stan infrastruktury (pliki `.tfstate`), by wiedzieć, które zasoby są już utworzone i jakie zmiany mają nastąpić.

---

## Instrukcja instalacji

1. Wejdź na stronę oficjalną Terraform: [terraform.io](https://terraform.io)  
2. Pobierz wersję odpowiednią do Twojego systemu operacyjnego.  
3. Rozpakuj / zainstaluj pliki.  
4. Sprawdź wersję:

   ```bash
   terraform --version
   ```

   Powinno pojawić się coś w rodzaju:

   ```
   Terraform v1.x.x
   on linux_amd64
   ```

---

## Przygotowanie projektu

1. Utwórz nowy katalog na projekt:

   ```bash
   mkdir terraform-projekt
   cd terraform-projekt
   ```

2. W tym katalogu stwórz plik konfiguracyjny `main.tf`.  

3. W pliku możesz umieścić minimalną konfigurację z providerem (np. AWS / Azure / Google) lub jedną „dummy” definicję zasobu.

---

## Pierwsze uruchomienie Terraform

1. **`terraform init`**  
   Inicjalizuje katalog jako projekt Terraform – pobiera providerów, wtyczki i przygotowuje środowisko.

2. **`terraform plan`**  
   Pokazuje, jakie zmiany Terraform wykona, jeśli zastosujesz konfigurację. To krok “suchy” — bez zmian w rzeczywistości.

3. **`terraform apply`**  
   Wykonuje zmiany zgodnie z planem.

4. (Opcjonalnie) **`terraform destroy`**  
   Usuwa zasoby stworzone przez Terraform — przydatne na etapie testów.

---

## Praktyczny przykład

Minimalna konfiguracja dla AWS:

```hcl
provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "moj-terraform-bucket-1234"
  acl    = "private"
}
```

1. Zapisz to w `main.tf`.  
2. Następnie uruchom:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Sprawdź w AWS Console, że zasób faktycznie powstał.  
4. Użyj `terraform destroy`, aby usunąć zasób.

---

## Najlepsze praktyki na start

- Trzymaj konfiguracje Terraform (pliki `.tf`) pod wersjonowaniem (Git).  
- Nie przechowuj plików stanu (`*.tfstate`) w publicznych repozytoriach.  
- Ustal jasną strukturę projektu już od początku.  
- Zawsze sprawdzaj wynik `terraform plan`, zanim wykonasz `terraform apply`.
