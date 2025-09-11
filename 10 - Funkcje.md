Aby podłączyć się do instancji EC2 będziemy potrzebowali klucza SSH, za pomocą którego dokonamy uwierzytelniania. Możesz skorzystać z klucza dostaerczonego przez prowadzącego lub wygenerować własną parę. Jeżeli używasz systemu Linux lub MacOS wgraj pliki z klucze prywatnym i publicznym do katalogu o nazwie ```.ssh``` znajdującego się w głównym katalogu Twojego konta.

Utwórz nowy obiekt reprezentujący klucz publiczny SSH, lecz odwołaj się do nieistniejącego pliku za pomocą funkcji ```file()```
```
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = file("~/.ssh/klucz.pub")
  tags = { pod = var.pod }
}
```
Wykonaj teraz polecenie ```terraform plan``` i sprawdź jego rezultat. Popraw konfigurację aby odwoływała się do istniejącego pliku
```
resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = file("~/.ssh/TerraformLab.pub")
  tags = { pod = var.pod }
}
```
Wykonaj ponownie polecenie ```terraform plan```
