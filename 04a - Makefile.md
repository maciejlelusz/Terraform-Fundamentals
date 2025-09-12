# Moduł 04a. Makefile

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Wdrażać i usuwać infrastrukturę korzystając z poleceń `make`.  
2. Rozumieć, jak Makefile może uprościć obsługę Terraform.  

---

## Ćwiczenie: Użycie Makefile

Przeprowadź budowę środowiska i jego usunięcie za pomocą procedur zdefiniowanych w pliku **`Makefile`**.

Przykładowe polecenia:

```bash
make apply
make destroy
```

---

## Wskazówki

- Plik `Makefile` pozwala definiować aliasy do komend Terraform (np. `terraform init`, `terraform plan`, `terraform apply`).  
- Dzięki temu skracasz i ujednolicasz polecenia — szczególnie w większych projektach zespołowych.  
