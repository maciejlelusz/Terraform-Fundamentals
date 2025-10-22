# Moduł 04: Deployment

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Wdrażać infrastrukturę przy użyciu `terraform apply`.  
2. Sprawdzać stan wdrożenia za pomocą `terraform show`.  
3. Porównywać stan zasobów Terraform z rzeczywistym stanem w AWS Console.  
4. Używać opcji `-auto-approve` oraz komendy `terraform refresh`.  
5. Usuwać wdrożoną infrastrukturę z wykorzystaniem `terraform destroy`.  

---

## Ćwiczenie: Wdrażanie i zarządzanie stanem

### Krok 1. Wdrożenie infrastruktury

Wdróż przygotowaną konfigurację:

```bash
terraform apply
```

Wyświetl stan wdrożenia:

```bash
terraform show
```

Zaloguj się do konsoli AWS i porównaj wartości widoczne w `terraform show` z tymi w AWS Console.

Następnie usuń wdrożenie:

```bash
terraform destroy
```

---

### Krok 2. Automatyczne zatwierdzanie

Uruchom ponownie wdrożenie z wyłączeniem potwierdzania:

```bash
terraform apply -auto-approve
```

Wyświetl stan:

```bash
terraform show
```

---

### Krok 3. Modyfikacja zasobu poza Terraform

1. Z poziomu AWS Console zmodyfikuj utworzone VPC:  
   - zmień parametr **DHCP option set** z wygenerowanego obiektu na **No DHCP options set**.

2. Sprawdź w Terraform:

   ```bash
   terraform show
   ```

   ➡️ Zobacz, czy zaszły jakieś zmiany.

3. Odśwież stan w Terraform:

   ```bash
   terraform refresh
   terraform show
   ```

   ➡️ Sprawdź ponownie, czy zaszły zmiany.

---

### Krok 4. Usunięcie środowiska

Usuń wdrożoną infrastrukturę bez konieczności zatwierdzania:

```bash
terraform destroy -auto-approve
```

Z poziomu AWS Console upewnij się, że utworzony obiekt **DHCP options set** został usunięty.
