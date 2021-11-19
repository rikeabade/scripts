#!/bin/bash

# Informações que serão solicitadas na configuração via Web do Bareos
# Please choose a director: localhost-dir
# Username: 4linux
# Password: bareos
# Please choose a language: Portuguese (BR): Login

# Variável da Data Inicial para calcular o tempo de execução do script 
# opção do comando date: +%T (Time)

HORAINICIAL=$(date +%T)


# Variáveis para validar o ambiente, verificando se o usuário é "root", versão do ubuntu e kernel
# opções do comando id: -u (user)
# opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release)
# opções do comando cut: -d (delimiter), -f (fields)
# opção do shell script: pipe | = Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais

USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
KERNEL=$(uname -r | cut -d'.' -f1,2)

# Variável do caminho do Log dos Script utilizado 
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)

LOG="/var/log/$(echo $0 | cut -d'/' -f2)"

# Declarando a variável de download do BareOS 
RELEASE="http://download.bareos.org/bareos/release/latest/xUbuntu_18.04/"
USER="4linux"
PASSWD="bareos"
PROFILE="webui-admin"
POSTFIX="No configuration"

# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração
export DEBIAN_FRONTEND="noninteractive"

# Verificando se as dependências do BareOS estão instaladas
# opção do dpkg: -s (status), opção do echo: -e (interpretador de escapes de barra invertida), -n (permite nova linha)
# || (operador lógico OU), 2> (redirecionar de saída de erro STDERR), && = operador lógico AND, { } = agrupa comandos em blocos
# [ ] = testa uma expressão, retornando 0 ou 1, -ne = é diferente (NotEqual)

echo -n "Verificando as dependências do BareOS, aguarde... "
	for name in mysql-server mysql-common apache2 php
	do
  		[[ $(dpkg -s $name 2> /dev/null) ]] || { 
              echo -en "\n\nO software: $name precisa ser instalado. \nUse o comando 'apt install $name'\n";
              deps=1; 
              }
	done
		[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { 
            echo -en "\nInstale as dependências acima e execute novamente este script\n";
            exit 1; 
            }
		sleep 5

# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração
export DEBIAN_FRONTEND="noninteractive"

# Script de instalação do BareOS no GNU/Linux  Debian 
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando cut: -d (delimiter), -f (fields)

echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
clear

echo
echo -e "Instalação do BareOS no GNU/Linux Debian\n"
echo -e "Após a instalação do BareOS acessar a URL: http://`hostname -I | cut -d' ' -f1`/bareos-webui\n"
echo -e "Aguarde, esse processo demora um pouco dependendo do seu Link de Internet...\n"
sleep 5

echo -e "Adicionando o Repositório Universal do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	add-apt-repository universe &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Adicionando o Repositório Multiversão do Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	add-apt-repository multiverse &>> $LOG
echo -e "Repositório adicionado com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Atualizando as listas do Apt, aguarde..."
	#opção do comando: &>> (redirecionar a saída padrão)
	apt update &>> $LOG
echo -e "Listas atualizadas com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Atualizando o sistema, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y upgrade &>> $LOG
echo -e "Sistema atualizado com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Removendo software desnecessários, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes)
	apt -y autoremove &>> $LOG
echo -e "Software removidos com sucesso!!!, continuando com o script..."
sleep 5

echo -e "Instalando o BareOS, aguarde...\n"

echo -e "Adicionando o repositório do BareOS, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	# opção do comando wget: -q -O- (file)
	# opção do redirecionador |: Conecta a saída padrão com a entrada padrão de outro comando
	# opção do comando apt-key: add (file name), - (arquivo recebido dO redirecionar | piper)
	cp -v conf/bareos.list /etc/apt/sources.list.d/bareos.list &>> $LOG
	wget -q $RELEASE/Release.key -O- | apt-key add - &>> $LOG
	apt update &>> $LOG
echo -e "Repositório do BareOS criado com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Configurando as variáveis do Debconf do BareOS para o Apt, aguarde..."
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando | (piper): (Conecta a saída padrão com a entrada padrão de outro comando)
	echo "bareos-database-common bareos-database-common/dbconfig-install boolean true" | debconf-set-selections
	echo "bareos-database-common bareos-database-common/mysql/app-pass password $PASSWD" | debconf-set-selections
	echo "bareos-database-common bareos-database-common/app-password-confirm password $PASSWD" | debconf-set-selections
	echo "postfix postfix/main_mailer_type string $POSTFIX" | debconf-set-selections
	debconf-show bareos-database-common &>> $LOG
	debconf-show postfix &>> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Instalando o BareOS Server e criando a Base de Dados em MySQL, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando apt: -y (yes)
	apt -y install bareos bareos-database-mysql bareos-tools bareos-bconsole &>> $LOG
echo -e "BareOS instalado com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Instalando o BareOS Webgui, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando apt: -y (yes)
	apt -y install bareos-webui &>> $LOG
echo -e "BareOS Webgui instalado com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Reinicializando os Serviços do BareOS Server, aguarde..."
	# bareos-dir: Bareos Director.
	# bareos-sd: Bareos Storage Daemon.
	# bareos-fd: Bareos File Daemon
	# bareos-webui: Bareos Web Configurator
	systemctl start bareos-dir &>> $LOG
	systemctl start bareos-sd &>> $LOG
	systemctl start bareos-fd &>> $LOG
	systemctl restart apache2 &>> $LOG
echo -e "Serviços reinicializados com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Criando o usuário de administração do BareOS Webgui, aguarde..."
	# opção do comando: &>> (redirecionar a saida padrão)
	# opção do comando | (piper): (Conecta a saída padrão com a entrada padrão de outro comando)
	# opções do comando bconsole: configure (configurar o BareOS), add (adicionar), console (gerenciamento do console)
	# name (nome do usuário), password (senha do usuário), profile (perfil do usuário), tlsenable (habilitar ou desabilitar TLS)
	# reload (aplicar as mudanças)
	echo -e "configure add console name=$USER password=$PASSWD profile=$PROFILE tlsenable=no" | bconsole &>> $LOG
	echo -e "reload" | bconsole &>> $LOG
echo -e "Usuário criado com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Verificando as portas de Conexões do BareOS, aguarde..."
	# opção do comando netstat: -a (all), -n (numeric)
	netstat -an | grep '9102\|9103'
echo -e "Portas de conexões verificadas com sucesso!!!, continuando com o script..."
sleep 5
echo

echo -e "Instalação do BareOS feita com Sucesso!!!."
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=$(date +%T)
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=$(date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S")
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
exit 1
