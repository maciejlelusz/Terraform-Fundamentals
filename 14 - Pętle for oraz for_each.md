Dotychczas za pomocą Terraforma powoływaliśmy kompletne środowisko sieciowe VPC z jedną podsiecią, w której znajdowały się serwery. Zmodyfikujemy teraz przygotowywaną konfigurację, aby za pomocą Terraforma wdrożyć trzy podsieci, każda w innej availability zone w ramach utworzonego VPC, i w każdej z nich jeden serwer.

Definicje obiektów ```aws_internet_gateway```, ```aws_key_pair```, ```aws_route_table``` oraz ```aws_security_group``` nie ulegają zmianie. Usuwamy obiekty ```random_integer``` oraz parametry ```count```.

Pod definicją providera zdefiniuj lokalna wartość, wskazującą na blok CIDR przypisany do VPC.
```
locals {
  vpc_cidr_block = "10.0.0.0/16"
}
```

Lokalną zmienną wykorzystamy najpierw w definicji VPC, która ulega tylko lekkiej modyfikacji

```
resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { pod = var.pod }
}
```

Definiujemy nową zmienną
```
variable "subnets_in_az" {
  default = {
    "eu-central-1a" = 0,
    "eu-central-1b" = 1,
    "eu-central-1c" = 2
  }
}
```

Następnie wykorzystując wartości zapisane w utworzonej zmiennej korzystając z pętli ```for_each``` tworzymy listę zawierającą obiekty typu ```aws_subnet```. Do podziału na podsieci wykorzystamy funkcję ```cidrsubnet()```, która przydzieli nam kolejne podsieci do poszczególnych obiektów. Do aktualnie przetwarzanego w pętli klucza i przypisanej mu wartości odwołujemy się za pomocą ```each.key``` oraz ```each.value```

```
resource "aws_subnet" "subnet_private" {
  for_each = var.subnets_in_az

  availability_zone = each.key
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 9, each.value)
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = { pod = var.pod }
}
```

Także za pomocą pętli ```for_each``` przypisujemy kolejno utworzone podsieci do tablicy routingu
```
resource "aws_route_table_association" "rta_subnet_public" {
  for_each = var.subnets_in_az

  subnet_id      = aws_subnet.subnet_private[each.key].id
  route_table_id = aws_route_table.rtb_public.id
}
```

W ten sam sposób konstuujemy definicję instancji EC2
```
resource "aws_instance" "ec2_server" {
  for_each = var.subnets_in_az

  ami           = "ami-0c960b947cbb2dd16"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_private[each.key].id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name = aws_key_pair.ec2key.key_name
  tags = { pod = var.pod }
}
```

Na koniec musimy zmodyfikować wartości zmiennych ```output```, ponieważ poprzez przypisanie wartości w pętli zawierają one teraz struktury danych. Odpowienie wartości odczytujemy za pomocą iteracji pętli ```for```
```
output "vpc_subnet" {
  value = {
    for az in aws_subnet.subnet_private:
        az.availability_zone => az.cidr_block
  }
}

output "public_ip" {
  value = {
    for az in aws_instance.ec2_server:
        az.availability_zone => az.public_ip
  }
}

output "private_ip" {
  value = {
    for az in aws_instance.ec2_server:
        az.availability_zone => az.private_ip
  }
}
```