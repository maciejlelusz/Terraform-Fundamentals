W powołanym do życia środowiku działa obecnie jedna instancja maszyny wirtualnej EC2. Zwiększymy teraz liczbę serwerów do trzech dodając parametr ```count``` w definicji instancji
```
resource "aws_instance" "ec2_server" {
  ami           = "ami-0c960b947cbb2dd16"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name = aws_key_pair.ec2key.key_name
  count = 3
  tags = { pod = var.pod }
}
```
Usuń dodane poprzednio zmienne typu ```output``` wyświetlające na ekranie publiczny i prywatny adres IP instancji. Następnie wydaj polecenia ```terraform plan``` oraz ```terraform apply```. Sprawdź w konsoli AWS czy masz uruchomione trzy instancje serwera i wszystkie znajdują się w tej samej podsieci.

Zmień wartość count na ```2``` i dokonaj zmian w środowisku.

Dodaj ponownie usunięte przed chwilą zmienne ```output``` i wydaj polecenie ```terraform plan```

Zmodyfikuj zmienne tak by uwzględnić w ich definicji odniesienie do parametru ```count```

```
output "public_ip" {
  value = aws_instance.ec2_server.*.public_ip
}

output "private_ip" {
  value = aws_instance.ec2_server.*.private_ip
}
```
Wykonaj ponownie polecenie ```terraform apply``` i sprawdź wynik.

Na koniec dodaj zmienną ```output``` jako ciąg znaków zawierający odwołanie do adresu IP instancji z indeksem 0
```
output "public_ip_instance_0" {
  value = "Adres IP instancji z indeksem 0 to ${element(aws_instance.ec2_server.*.public_ip, 0)}"
}
```
Ponownie wykonaj ponownie polecenie ```terraform apply``` i sprawdź wynik.
