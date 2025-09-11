Aby uruchomić instancję EC2 z publicznym adresem i dozwolonym ruchem potrzebujemy jeszcze kilku komponentów: security group, tablicy routingu i definicji samej instancji. Dodajmy je po kolei:

Na początek definicja security groupy, która będzie pozwalała na dowolny ruch przychodzący i wychodzący
```
resource "aws_security_group" "sg_any" {
  name = "sg_any"
  vpc_id = aws_vpc.vpc.id
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { pod = var.pod }
}
```

Następnie dodaj tablice routingu
```
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
  }
  tags = { pod = var.pod }
}
```

Na koniec powiąż tablicę routingu z podsiecią
```
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.rtb_public.id
}
```

W tym momencie mamy już wszystkie komponenty niezbędne do uruchomienia instancji EC2.
```
resource "aws_instance" "ec2_server" {
  ami           = "ami-0c960b947cbb2dd16"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name = aws_key_pair.ec2key.key_name
  tags = { pod = var.pod }
}
```
Wdróż tak przygotowaną konfigurację. Z informacji, które zostały wypisane na ekranie odczytaj publiczny adres IP, który AWS przydzielił powołanej do działania instancji EC2. Połącz się z uruchomionym serwerem po SSH korzystając z klucza SSH. Jako nazwę użytkownika podaj ```ubuntu```

Dodaj teraz dwie zmienne typu ```output``` aby wyświetlić na ekranie konsoli publiczny i prywatny adres powołanego do życia serwera. Możesz zbudować całe środowisko od nowa lub odświeżyć już działające. Zróć uwagę, że dodanie zmiennych typu ```output``` nie powoduje modyfikacji działającego środowiska
```
output "public_ip" {
  value = aws_instance.ec2_server.public_ip
}

output "private_ip" {
  value = aws_instance.ec2_server.private_ip
}
```

Nie usuwaj uruchomionego w tym zadaniu środowiska.