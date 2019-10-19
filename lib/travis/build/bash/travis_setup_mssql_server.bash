travis_setup_mssql_server() {
  # install
  export ACCEPT_EULA=Y 
  echo -e "${ANSI_YELLOW}Installing MssqlServer${ANSI_CLEAR}"

  # TODO check operating system
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

  sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"
  curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

  sudo apt-get update
  sudo apt-get install -y mssql-server
  apt install -y msodbcsql17
  apt-get install -y mssql-tools unixodbc-dev

  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
  echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
  source ~/.bashrc

  # start server
  echo -e "${ANSI_YELLOW}Starting MssqlServer${ANSI_CLEAR}"
  # TODO set password
  export MSSQL_SA_PASSWORD="Password1!"
  sudo -E /opt/mssql/bin/mssql-conf -n setup
  systemctl status mssql-server --no-pager
}