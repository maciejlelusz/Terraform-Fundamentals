# Moduł 09: Użycie publicznego modułu VPC (terraform-aws-modules/vpc)

**Cel ćwiczenia**

- Pokazać, jak zastąpić ręczną konfigurację VPC i podsieci publicznym, gotowym modułem z Terraform Registry.
- Zwrócić uwagę na ograniczenia gotowych moduułów oraz jak wyeliminować najczęściej pojawiający się błąd (brak AZ).

---

## Wymagania wstępne

- Poprawnie skonfigurowane AWS credentials (np. przez `~/.aws/credentials` albo zmienne środowiskowe).
- Zainstalowany Terraform (wersja kompatybilna z używanym modułem — w tym ćwiczeniu zakładamy Terraform ≥ 0.12).
- Projekt/plik Terraform z poprzedniego zadania (zawierający definicje `aws_vpc`, `aws_internet_gateway`, `aws_subnet` oraz output `vpc_subnet`).

---

## Instrukcja krok po kroku

1. **Usuń dotychczasowe zasoby z Terraform i/lub skomentuj definicje w kodzie**

   Jeśli w poprzednim zadaniu wdrożyłeś zasoby, najpierw je usuń poleceniem:

   ```bash
   terraform destroy
   ```

   Następnie w swoim kodzie Terraform (pliki `.tf`) **usuń lub zakomentuj** definicje:

   - `aws_vpc`
   - `aws_internet_gateway`
   - `aws_subnet`
   - output `vpc_subnet`

   > Uwaga: zamiast trwale usuwać pliki możesz je zakomentować (/* ... */ lub //) — ważne, by Terraform ich już nie tworzył.

2. **Dodaj wywołanie publicznego modułu VPC**

   W pliku `main.tf` (lub innym odpowiednim) wklej poniższą definicję modułu:

   ```hcl
   module "vpc" {
     source  = "terraform-aws-modules/vpc/aws"
     version = "2.21.0"

     cidr = "10.0.0.0/16"

     public_subnets  = ["10.0.${random_integer.octet.result}.0/24"]
   }
   ```

   > Link do dokumentacji modułu: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.21.0

3. **Zainicjuj Terraform**

   ```bash
   terraform init
   ```

   To pobierze moduł i jego zależności.

4. **Zaplanuj zmiany**

   ```bash
   terraform plan
   ```

   Po uruchomieniu planu najprawdopodobniej otrzymasz błąd wskazujący, że brakuje definicji co najmniej jednej Availability Zone (AZ). Moduł oczekuje listy AZ-ów przekazywanej w parametrze `azs`.

5. **Dodaj AZ do wywołania modułu**

   Zmodyfikuj definicję modułu, dodając parametr `azs`. Przykład dla regionu `eu-central-1`:

   ```hcl
   module "vpc" {
     source  = "terraform-aws-modules/vpc/aws"
     version = "2.21.0"

     cidr = "10.0.0.0/16"

     azs             = [ "eu-central-1a" ]
     public_subnets  = ["10.0.${random_integer.octet.result}.0/24"]
   }
   ```

   **Wyjaśnienie:** `azs` to lista stref dostępności, na których moduł będzie tworzył zasoby (subnets, route tables itd.). Nawet jeśli chcesz tylko jedną podsieć, musisz podać przynajmniej jedną AZ.

6. **Powtórz planowanie i wdrożenie**

   ```bash
   terraform plan
   terraform apply
   ```

   - Przejrzyj rezultat `plan`.
   - Wykonaj `apply`, jeśli wszystko wygląda poprawnie.

7. **Weryfikacja**

   - Sprawdź w konsoli AWS (VPC -> Your VPCs / Subnets) czy VPC i podsieć(-i) zostały utworzone.
   - Zwróć uwagę na nazewnictwo, tagi i przypisane routingi — moduł tworzy standardowe zasoby (route table, subnet associations, itp.).

8. **Sprzątanie**

   Po weryfikacji usuń wdrożenie:

   ```bash
   terraform destroy
   ```

   Upewnij się, że zasoby w AWS zniknęły.

9. **Przywrócenie poprzedniej topologii**

   - Przywróć (odkomentuj lub przywróć z kopii) plik topologii, który używałeś w poprzednim zadaniu — tak, by Twoje środowisko znowu zawierało wcześniejsze definicje `aws_vpc`, `aws_subnet` itd.

---

## Dodatkowe uwagi i wskazówki trenerskie

- **Zalety użycia modułu:** szybkie wdrożenie, sprawdzone wzorce, mniejsza ilość kodu do utrzymania.
- **Wady:** ograniczona elastyczność — jeśli potrzebujesz niestandardowego zachowania, możesz być zmuszony do modyfikacji modułu albo napisania własnych zasobów.
- **Wersjonowanie modułu:** zawsze określ wersję (`version = "2.21.0"`) — dzięki temu unikniesz niespodzianek przy aktualizacji.
- **Testy lokalne:** przed `apply` zawsze sprawdź `plan`. W środowisku szkoleniowym pamiętaj, by nie zostawiać niepotrzebnych zasobów (koszty!).

---

Jeśli chcesz, przygotuję krótką checklistę do wydruku (np. w formacie `README.md`) lub wersję zadania z gotowym szablonem pliku `main.tf` do skopiowania. Napisz, co preferujesz.

