# Créez un groupe de sécurité pour contrôler l'accès au serveur
resource "aws_security_group" "django_server_sg" {
  name_prefix = "django-server-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Vous pouvez également ajouter des règles pour SSH (port 22) si nécessaire pour le débogage
}


resource "aws_instance" "django_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # AMI Ubuntu 20.04 (Vérifiez la disponibilité dans votre région)
  instance_type = "t2.micro"  # Instance de type gratuit, vous pouvez changer selon les besoins

  # Attachez le groupe de sécurité créé à l'instance EC2
  vpc_security_group_ids = [aws_security_group.django_server_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Mise à jour du système et installation des dépendances
              sudo apt-get update
              sudo apt-get install -y python3 python3-pip

              # Clonez votre application depuis GitHub ou un autre référentiel
              git clone https://github.com/votre-utilisateur/votre-repo.git /home/ubuntu/django-app

              # Installez les dépendances de votre application Django
              cd /home/ubuntu/django-app
              pip3 install -r requirements.txt

              # Lancez votre application Django (remplacez "manage.py" par le nom du script de lancement de votre application)
              python3 manage.py runserver 0.0.0.0:80
              EOF

  tags = {
    Name = "django-server"
  }
}

