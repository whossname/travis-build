travis_setup_mssql_server() {
  local mssql_version="${1}"

  if [[ -z "${mssql_version}" ]]; then
    mssql_version='2017'
  fi

  echo -e "mssql version: ${mssql_version}"

  local ubuntu_version

  case "${TRAVIS_DIST}" in
  trusty)
    ubuntu_version='14.04'
    ;;
  xenial)
    ubuntu_version='16.04'
    ;;
  bionic)
    ubuntu_version='18.04'
    ;;
  *)
    echo -e "${ANSI_RED}Unrecognized operating system.${ANSI_CLEAR}"
    ;;
  esac

  # install
  echo -e "${ANSI_YELLOW}Installing MssqlServer${ANSI_CLEAR}"

  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

  local package_uri="https://packages.microsoft.com/config/ubuntu/${ubuntu_version}"
  sudo add-apt-repository "$(wget -qO- ${package_uri}/mssql-server-${mssql_version}.list)"
  curl ${package_uri}/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list

  sudo apt-get update
  env ACCEPT_EULA=Y apt-get install -y mssql-server
  env ACCEPT_EULA=Y apt install -y msodbcsql17
  env ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

  export PATH="$PATH:/opt/mssql-tools/bin"
  source ~/.bashrc

  # start server
  echo -e "${ANSI_YELLOW}Starting MssqlServer${ANSI_CLEAR}"
  # TODO set password
  export MSSQL_SA_PASSWORD="Password1!"
  sudo -E /opt/mssql/bin/mssql-conf -n setup
  systemctl status mssql-server --no-pager

  export SQLCMDPASSWORD=$MSSQL_SA_PASSWORD
  export SQLCMDUSER='sa'
}