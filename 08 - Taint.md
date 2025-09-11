Korzystając z przygotownej i wdrożonej w poprzednim labie konfiguracji oznacz tworzony zasób podsieci jako ```tainted```, czyli przeznaczony do ponownego wykreowania
```
terraform taint aws_subnet.subnet_private
```

Wykonaj ```terraform plan```, zwróć uwagę które zasoby zostaną usunięte i utworzone ponownie. Zaaplikuj zmianę za pomocą ```terraform apply```

Oznacz teraz jako ```tainted``` utworzony obiekt zmiennej losowej
```
terraform taint random_integer.octet
```
Wykonaj ponownie ```terraform plan```. Zwróć uwagę, że ponowne utworzenie zmiennej losowej spowoduje wygenerowanie nowej wartości a także ponowne utworzenie podsieci. Zaaplikuj zmiany za pomocą ```terraform apply```
