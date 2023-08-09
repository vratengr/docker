# Docker vs XAMPP

If you are new to transferring to Docker/WSL2 from XAMPP then here are some of the main differences:
- XAMPP
    - you install this in your OS
    - it already has predefined/bundled services (Apache, MariaDB, PHP, Perl and other extensions/modules)
    - your code resides in your OS
    - and you run/access the code in your OS
- Docker with WSL2
    - your host OS is Windows, then Docker and WSL2 are installed in here
    - WSL2 contains a distro (a Linux OS)
    - your code resides in the distro which does not have any bundled services
    - you create a Dockerfile or a Docker Compose file to define your required services (Apache, MariaDB, PHP) and run it to create a Docker Container
    - the Docker Container:
        - it's like creating your own OS and XAMPP (with only the services you defined)
        - it will also have a copy of your codes
    - you access your site in your host OS


### BACKGROUND
Since my early dev years, I've been used to using WAMP/LAMP/MAMP then my favorite would be XAMPP in Ubuntu.

However, I had to reformat my laptop to Windows and figured, why not try Docker and WSL2 which I only had a glimpse before.

So here it is, my simple sample of PHP local dev environment. Well, not really the bare minimum as I've touched some topics I usually use. So feel free to pick which one you only need or clone the entire repo as your base. 😊


### PREREQUISITE
- [Basic understanding of the Docker concept](https://www.section.io/engineering-education/docker-concepts/)
- [Install WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
```
wsl install
```
- [Install VS Code](https://code.visualstudio.com/download) - Visual Studio Code has been optimized for better user experience and is [well documented](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode) when using WSL2 and Docker in Windows, which makes it a good starting point if you're new to this.
- [Install Docker Desktop](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers)


### SETUP
- All installations above are done on the host environment, in my case it's Windows
- All our codes will be inside our WSL2 distro, in my case it's Ubuntu
- We will then use VS Code to [connect to our distro](https://code.visualstudio.com/docs/remote/wsl) and deploy/access the codes as if it's just within our host environment
    - If you are using Git for your codes, install Git within the distro and clone your codes in there
    

### ABOUT THE CODE
Comments are added inline in each file so you can decide which are required, which ones you need, which can be customized.

- This demo creates 3 containers:
    - [PHP with Apache](https://hub.docker.com/_/php)
    - [MariaDB](https://hub.docker.com/_/mariadb) for our database
    - [phpMyAdmin](https://hub.docker.com/_/phpmyadmin) for graphical interface of our database
- PHP with Apache
    - part of the container's definition is in `compose.yaml`, but the majority of the setup is defined in the `Dockerfile`
    - a vhost file has been defined so that the app can be accessed thru an alias rather than localhost
        - you can replace `vratengr.com` with your own alias
        - in `compose.yaml`, the alias is defined in `extra_vhosts`, which creates an entry in the container's /etc/hosts file
        - and since we're using Docker with WSL2, we have to define the alias as well in the host environment, which is in C:\Windows\System32\drivers\etc\hosts
            - localhost works out of the box since it is defined automatically in Windows, in WSL2 instance and in the Docker Container
    - the codes are mounted so that the changes we make in our WSL files will reflect in the container, see `volumes`
- MariaDB
    - this is our database, it's based on MySQL but an enhanced one, so you could use all MySQL process here
    - we've setup an initial dump by copying a dump file into /docker-entrypoint-initdb.d, see `volumes`
    - DB data is persisted which means, even if the container/image is stopped, data will remain as it was last left, see 2nd line in `volumes`
    - Docker volumes are like a hard disk where Docker stores data separately
- phpMyAdmin
    - I just like having a GUI for the database, this is optional, in any case, this just reads our MariaDB database

If you're uncertain where to start, check out `compose.yaml`.
- To create your dev environment, open the terminal and run: `docker compose up -d`
    - this checks your `compose.yaml` file and create the images based on your definitions
    - -d runs the installation in detached mode
        - you can then check the status in Docker Desktop
    - alternative compose file names are `docker-compose.yml`, `docker-compose.yaml`, `compose.yaml`, `compose.yml`
        - as per [the official documentation](https://docs.docker.com/compose/compose-file/03-compose-file/), `compose.yaml` is preferred
    - run the command where the compose file is located. it's ideal to put it in your project's root directory but you are free to put it anywhere, just check the relative paths used within the file and run docker compose where your compose file is


### NOTES / REFERENCES
- To create a container, at the bare minimum, you can just have a Dockerfile to define it
- In full-pledged sites, it takes more than one service to get your app up and running.
    - For example, in a PHP website, you would need at least: PHP, Apache and a database
    - Each container by default is independent, and in order for them to communicate with each other, you need to create a network to house them.
    - Docker Compose helps set up the relationship and build complex networks.
- When using a docker image, if no version has been provided, it uses the latest.
    - It's best to specify the version to ensure that your app will always work as you have tested since the latest build could be different per release
- [Docker Cheatsheet](https://github.com/eon01/DockerCheatSheet)

### TECHNOLOGIES
- Docker
- Docker Compose
- WSL2
- PHP
- Apache
- MariaDB
- phpMyAdmin
- Git
- Vhost
- [SSL](https://realtechtalk.com/%5Bwarn%5D_RSA_server_certificate_is_a_CA_certificate_BasicConstraints_CA_TRUE__Apache_Error_Solution-1870-articles)