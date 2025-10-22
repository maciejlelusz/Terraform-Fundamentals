# Moduł 08: Oznaczanie zasobów jako Tainted

## Cel modułu

Po ukończeniu tego modułu uczestnicy będą potrafili:

1. Oznaczać zasoby jako **tainted** (przeznaczone do ponownego utworzenia).  
2. Analizować wpływ oznaczania zasobów na plan wdrożenia.  
3. Rozumieć zależności między zasobami przy ponownym tworzeniu infrastruktury.  

---

## Ćwiczenie: Oznaczanie zasobów jako Tainted

### Krok 1. Oznaczanie podsieci jako Tainted

Korzystając z przygotowanej i wdrożonej wcześniej konfiguracji, oznacz tworzony zasób podsieci jako **tainted**, czyli przeznaczony do ponownego utworzenia:

```bash
terraform taint aws_subnet.subnet_private
```

Następnie sprawdź plan zmian:

```bash
terraform plan
```

Zwróć uwagę, które zasoby zostaną **usunięte i utworzone ponownie**.  
Wdróż zmianę:

```bash
terraform apply
```

---

### Krok 2. Oznaczanie zmiennej losowej jako Tainted

Teraz oznacz jako tainted utworzony obiekt zmiennej losowej:

```bash
terraform taint random_integer.octet
```

Sprawdź ponownie plan zmian:

```bash
terraform plan
```

Zwróć uwagę, że ponowne utworzenie zmiennej losowej spowoduje:

- wygenerowanie **nowej wartości losowej**,  
- **ponowne utworzenie podsieci**, która z niej korzysta.

Wdróż zmiany:

```bash
terraform apply
```
