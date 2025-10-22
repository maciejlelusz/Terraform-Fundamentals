# Moduł 10: Tworzenie klucza SSH i konfiguracja uwierzytelniania EC2

## Cel modułu

- Nauczyć się, jak zdefiniować w Terraform zasób reprezentujący parę kluczy SSH (`aws_key_pair`).
- Zrozumieć, jak funkcja `file()` wczytuje klucz publiczny z lokalnego systemu plików.
- Przećwiczyć diagnostykę błędów w konfiguracji Terraform.

---

## Wymagania wstępne

- Działające środowisko AWS (konto z uprawnieniami do tworzenia zasobów EC2).
- Zainstalowany Terraform.
- Wygenerowana para kluczy SSH **lub** klucz dostarczony przez prowadzącego.

> 💡 W systemach **Linux** i **macOS** domyślnym miejscem przechowywania kluczy SSH jest katalog `~/.ssh/` w katalogu domowym użytkownika.

---

## Krok po kroku

### 1. Przygotowanie klucza SSH

Jeśli nie masz jeszcze pary kluczy SSH, możesz ją wygenerować lokalnie:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/TerraformLab
```

Po wykonaniu tego polecenia powstaną dwa pliki:

- `~/.ssh/TerraformLab` – **klucz prywatny** (nieudostępniaj go nikomu!),
- `~/.ssh/TerraformLab.pub` – **klucz publiczny**, który będziemy używać w Terraform.

---

### 2. Utworzenie zasobu `aws_key_pair`

Na początek utwórz zasób, który odwołuje się do **nieistniejącego pliku**. Dzięki temu zobaczysz, jak Terraform reaguje na błędną ścieżkę.

W pliku `main.tf` dodaj poniższy kod:

```hcl
resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = file("~/.ssh/klucz.pub")
  tags = {
    pod = var.pod
  }
}
```

---

### 3. Uruchomienie planowania

Wykonaj polecenie:

```bash
terraform plan
```

Terraform spróbuje wczytać plik `~/.ssh/klucz.pub`. Ponieważ plik nie istnieje, zobaczysz komunikat błędu informujący o braku możliwości odczytu pliku.

---

### 4. Korekta konfiguracji

Zmień konfigurację, aby wskazywała **istniejący plik z kluczem publicznym** (np. ten utworzony wcześniej lub dostarczony przez prowadzącego):

```hcl
resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = file("~/.ssh/TerraformLab.pub")
  tags = {
    pod = var.pod
  }
}
```

---

### 5. Ponowne planowanie

Uruchom ponownie plan:

```bash
terraform plan
```

Jeżeli konfiguracja jest poprawna, Terraform pokaże plan utworzenia zasobu typu `aws_key_pair`.

> ✅ W tym momencie nie powinieneś otrzymać żadnych błędów dotyczących braku pliku.

---

## Dodatkowe wskazówki

- **Bezpieczeństwo:** nigdy nie umieszczaj prywatnych kluczy SSH w repozytoriach Git ani w kodzie Terraform.
- **Ścieżki plików:** w Terraform `~` nie zawsze jest automatycznie rozwijane do katalogu domowego — jeśli występują problemy, użyj pełnej ścieżki (np. `/home/student/.ssh/TerraformLab.pub`).
- **Tagi:** parametr `tags` jest przydatny do oznaczania zasobów w środowisku współdzielonym (np. identyfikacja po numerze stanowiska lub grupie szkoleniowej).

---

W kolejnym kroku użyjemy utworzonego klucza do połączenia się z instancją EC2 i przetestujemy logowanie przez SSH.

