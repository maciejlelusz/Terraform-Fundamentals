Dodaj do projektu nowy resource w postaci generatora liczb pseudolosowych. Za jego pomocą będziesz generować losową wartość trzeciego oktetu podsieci, która zostanie utworzona w ramach VPC.
```
provider "random" {}

resource "random_integer" "octet" {
  max = 255
  min = 0
}
```
Do generowanie liczb pseudolosowych należy do projektu dodać providera ```random```. Aby go pobrać musisz wydać ponownie polecenie ```terrafomr init```.

Dodaj konfigurację podsieci i powiąż ją z utworzonym VPN. 
```
resource "aws_subnet" "subnet_private" {
  cidr_block = "10.0.${random_integer.octet.result}.0/24"
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = { pod = var.pod }
}
```

Generowana wartość losowa znajduje się w obiekcie ```result``` będącym składnikiem generatora. Odwołasz się do niego za pomocą konstrukcjie ```${random_integer.octet.result}```.

Wdróż i usuń tak przygotowaną konfigurację i sprawdź jaka losowa wartość została wygenerowana. Usuń konfigurację i wdróż ją ponownie. Zauważ, że wygenerowana wartość losowa uległa zmiane.

Zmodyfikuj następnie w obiekcie ```subnet_private``` wartość atrybutu ```cidr_block``` modyfikując maskę podsieci z ```/24``` na ```/25```. Wykonaj ponownie polecenia ```terraform plan``` oraz ```terraform apply``` aby wprowadzić w AWS zmiany w konfiguracji. Zauważ, że wartość losowej liczby nie uległa zmianie.

Zadeklaruj teraz zmienną typu ```output``` i przypisz jej wartość utworzonego wcześniej bloku CIDR
```
output "vpc_subnet" {
  value = aws_subnet.subnet_private.cidr_block
}
```
Wykonaj ponownie polecenia ```terraform plan``` oraz ```terraform apply```. Zobacz, że wartość zmiennej ```output``` zoztała wypisana na konsoli. Wykonaj teraz polecenia ```terraform output``` oraz ```terraform output vpc_subnet``` i porównaj wyniki na ekranie.
