#include <a_samp>
#include <a_mysql>
#include <foreach>
#include <sscanf>
#include <streamer>
#include <zcmd>

#define SERVER_HOST "localhost"
#define SERVER_USER "root"
#define SERVER_PASS ""
#define SERVER_DATA ""

#define MAX_REP (10) // Bisa diganti dengan reputasi yang kamu mau uwu

new ConnHandle; // Buat konek ke mysql.
new RepData[MAX_PLAYERS][pRep];

InitializeConnection()
{
  ConnHandle = mysql_connect(SERVER_HOST, SERVER_USER, SERVER_DATA, SERVER_PASS);
  if(mysql_errno(ConnHandle))
  {
    printf("Sambungan koneksi ke %s gagal, silahkan coba lain kali hehe.", SERVER_HOST);
    print("Data cannot loading with this!");
  }
  else
  {
    printf("Sambungan koneksi ke %s berhasil, sekarang script akan di load!.", SERVER_HOST);
    print("Script load successfully...");
  }
}

public OnFilterScriptInit()
{
  print("Initializing script...");
  print("Made by Lilx9, Don't sell this script!");
  InitializeConnection();
  mysql_tquery(ConnHandle, "SELECT * FROM `Reputation`", "OnReputationLoad", "i", playerid); // Bisa diganti sendiri dengan yang kalian inginkan.
  return 1;
}

public OnFilterScriptExit()
{
  print("Uninitializing script...");
  print("Made by Lilx9, Don't sell this script!");
  mysql_close(ConnHandle); 
  return 1;
}
