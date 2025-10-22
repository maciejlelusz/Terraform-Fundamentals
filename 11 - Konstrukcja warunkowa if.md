# Moduł 11: Sprawdzanie istnienia pliku klucza SSH przed odczytem

## Cel modułu

- Nauczyć się zabezpieczać konfigurację Terraform przed błędami wynikającymi z braku pliku klucza SSH.
- Poznać funkcję `fileexists()` i wykorzystanie wyrażeń warunkowych w HCL.

---

## Wprowadzenie

W poprzednich ćwiczeniach korzystaliśmy z funkcji `file()` do wczytania klucza publicznego SSH. Jeśli jednak wskazany plik nie istnieje, Terraform zgłasza błąd i przerywa wykonanie. Aby tego uniknąć, możemy sprawdzić istnienie pliku przed próbą jego odczytu.

---

## Instrukcja krok po kroku

### 1. Aktualizacja definicji zasobu `aws_key_pair`

W pliku konfiguracyjnym Terraform (`main.tf`) zmodyfikuj zasób klucza SSH w następujący sposób:

```hcl
resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = fileexists("~/.ssh/TerraformLab.pub") ? file("~/.ssh/TerraformLab.pub") : ""
  tags = {
    pod = var.pod
  }
}
```

---

### 2. Omówienie działania

- Funkcja `fileexists(path)` zwraca wartość logiczną `true` lub `false`, w zależności od tego, czy wskazany plik istnieje w systemie.
- Operator warunkowy `condition ? value_if_true : value_if_false` pozwala na przypisanie odpowiedniej wartości do parametru.
- Jeśli plik istnieje → Terraform wczyta jego zawartość funkcją `file()`.
- Jeśli plik **nie istnieje** → parametr `public_key` otrzyma pusty ciąg znaków (`""`), co zapobiegnie błędowi wykonania.

---

### 3. Weryfikacja konfiguracji

Uruchom polecenie planowania:

```bash
terraform plan
```

#### Oczekiwane zachowanie:
- Gdy plik `TerraformLab.pub` istnieje – Terraform wczyta klucz i pokaże plan utworzenia zasobu `aws_key_pair`.
- Gdy plik nie istnieje – Terraform nie zgłosi błędu, ale w podglądzie planu zobaczysz pustą wartość w polu `public_key`.

---

### 4. Dodatkowe wskazówki

- To rozwiązanie jest szczególnie przydatne w środowiskach testowych i szkoleniowych, gdzie klucz SSH może nie być jeszcze dostępny.
- W środowiskach produkcyjnych lepszym podejściem jest wymuszenie obecności pliku przez walidację zmiennych lub proces CI/CD.
- Funkcja `fileexists()` może być również wykorzystana do weryfikacji plików konfiguracyjnych, certyfikatów lub innych danych wejściowych.

---

## Podsumowanie

Zastosowanie funkcji `fileexists()` z warunkiem logicznym pozwala na bardziej odporną konfigurację Terraform. Dzięki temu unikasz błędów podczas planowania i możesz elastycznie testować różne scenariusze, nawet jeśli część zasobów lub plików jeszcze nie istnieje.

