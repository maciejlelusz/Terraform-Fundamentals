Do stworzenia VPN i podsieci możemy zamiennie do naszego kodu wykorzystać dostępny publicznie moduł. Jeżeli się na niego zdecydujemy jesteśmy ograniczeni jego funkcjonalnością, co nie zawsze jest porządane.

Usuń wdrożoną w poprzednim zadaniu konfigurację a następnie usuń lub zakomentuj w swojej konfiguracji definicję obiektów ```aws_vpc```, ```aws_internet_gateway```, ```aws_subnet``` oraz outputu ```vpc_subnet```

Dodaj do konfiguracji wywołanie modułu

```
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  cidr = "10.0.0.0/16"

  public_subnets  = ["10.0.${random_integer.octet.result}.0/24"]

}
```

Dokumentację modułu znajdziesz pod adresem https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.21.0

Zainstaluj moduł poleceniem ```terraform init```, następnie zaplanuj zmiany poleceniem ```terraform plan```

Z komuniktu błędu odczytamy, że brakuje definicji co najmniej jednej Avalability Zone. Zmodyfikuj wywołanie modułu
```
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  cidr = "10.0.0.0/16"

  azs             = [ "eu-central-1a" ]
  public_subnets  = ["10.0.${random_integer.octet.result}.0/24"]

}
```

Ponownie zaplanuj a następnie przeprowadź wdrożenie. Po poprawnej weryfikacji usuń wdrożenie. Przywróć też zawartość swojego pliku topologii z poprzedniego zadania.


