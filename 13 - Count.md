# Moduł 13: Skalowanie liczby instancji EC2 i praca z parametrem `count`

## Cel modułu

- Poznać mechanizm powielania zasobów w Terraform przy użyciu parametru `count`.
- Zrozumieć, jak zarządzać wyjściami (`output`) w przypadku wielu instancji.
- Przećwiczyć modyfikację istniejącej infrastruktury bez jej całkowitego usuwania.

---

## Wprowadzenie

Dotychczas środowisko zawierało jedną instancję EC2. Terraform pozwala łatwo zwiększyć liczbę instancji tego samego typu za pomocą parametru `count`. Dzięki temu możemy uruchomić kilka identycznych maszyn w ramach tej samej definicji zasobu.

---

## Krok po kroku

### 1. Modyfikacja zasobu EC2 — dodanie parametru `count`

W pliku `main.tf` zmodyfikuj definicję zasobu `aws_instance`:

```hcl
resource "aws_instance" "ec2_server" {
  ami                    = "ami-0c960b947cbb2dd16"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name               = aws_key_pair.ec2key.key_name

  count = 3

  tags = {
    pod = var.pod
  }
}
```

> 💡 Parametr `count` określa, ile instancji danego zasobu ma zostać utworzonych. Terraform automatycznie przypisze im indeksy `0`, `1`, `2`, itd.

---

### 2. Usunięcie poprzednich zmiennych `output`

Usuń wcześniejsze zmienne `output`, które wyświetlały pojedyncze adresy IP instancji:

```hcl
# Usuń lub zakomentuj poniższe sekcje
# output "public_ip" {
#   value = aws_instance.ec2_server.public_ip
# }

# output "private_ip" {
#   value = aws_instance.ec2_server.private_ip
# }
```

---

### 3. Planowanie i wdrożenie zmian

Uruchom polecenia:

```bash
terraform plan
terraform apply
```

Po wdrożeniu sprawdź w **AWS Console**, że zostały uruchomione **trzy instancje EC2** i wszystkie znajdują się w tej samej podsieci (`subnet_private`).

---

### 4. Zmniejszenie liczby instancji

Zmień wartość `count` na `2`:

```hcl
count = 2
```

Następnie ponownie wykonaj:

```bash
terraform apply
```

Terraform automatycznie **usunie jedną instancję**, pozostawiając dwie aktywne.

---

### 5. Ponowne dodanie zmiennych `output`

Dodaj z powrotem zmienne `output`, ale tym razem z uwzględnieniem wielu instancji poprzez operator splat (`*`):

```hcl
output "public_ip" {
  value = aws_instance.ec2_server.*.public_ip
}

output "private_ip" {
  value = aws_instance.ec2_server.*.private_ip
}
```

Uruchom:

```bash
terraform plan
```

Zwróć uwagę, że Terraform poprawnie rozpozna wiele wartości dla każdego z wyjść (listy adresów IP).

---

### 6. Wdrożenie i test

Zastosuj zmiany:

```bash
terraform apply
```

Sprawdź w konsoli AWS oraz w wynikach polecenia, że zmienne `output` zwracają listy adresów publicznych i prywatnych dla wszystkich instancji EC2.

---

### 7. Wyświetlenie adresu IP wybranej instancji (indeks 0)

Dodaj kolejną zmienną `output`, która wypisze adres IP instancji o indeksie `0` w formie czytelnego komunikatu:

```hcl
output "public_ip_instance_0" {
  value = "Adres IP instancji z indeksem 0 to ${element(aws_instance.ec2_server.*.public_ip, 0)}"
}
```

Wykonaj ponownie:

```bash
terraform apply
```

Wynik na ekranie powinien zawierać wpis podobny do:

```
public_ip_instance_0 = "Adres IP instancji z indeksem 0 to 18.194.123.45"
```

---

## Podsumowanie

- `count` pozwala łatwo skalować liczbę zasobów w Terraform.
- Operatory splat (`*`) umożliwiają zwracanie list właściwości z wielu instancji.
- Funkcja `element()` pozwala na precyzyjne odwołanie do konkretnego elementu listy (np. konkretnej instancji).

Środowisko z wieloma instancjami EC2 pozostaw uruchomione — będzie ono potrzebne w kolejnym module.

