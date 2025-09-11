Wdróż przygotowaną konfigurację za pomocą polecenia ```terraform apply```. Wyświetl stan wdrożenia za pomocą polecenia ```terraform show```. Zaloguj się do konsoli AWS i porównaj wartości uzyskane za pomocą ```terraform show``` z widocznymi na konsoli. Usuń wdrożenie poleceniem ```terraform destroy```

Wywołaj ponownie polecenie ```terraform apply``` z parametrem ```-auto-approve``` aby wyłączyć konieczność potwierdzania czynności na konsoli. Wyświetl stan wdrożenia poleceniem ```terraform show```. Z poziomu konsoli AWS zmodyfikuj konfigurację utworzonego VPC zmieniając parametr ```DHCP option set``` z wygenerowanego obiektu na ```No DHCP options set```. Pomnownie wydaj polecenie ```terraform show``` i zobacz, czy zaszły jakieś zmiany. Następnie wykonaj polecenie ```terraform refresh``` i sprawdź ponownie, czy w wyniku polecenia ```terraform show``` zaszły zmiany.

Usuń środowisko wydając polecenie ``terraform destroy -auto-approve``

Korzystając z konsoli AWS sprawdź, czy utworzony obiekt ```DHCP options set``` został usunięty.
