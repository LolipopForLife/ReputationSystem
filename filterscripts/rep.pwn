#include <a_samp>
#include <a_mysql>
#include <foreach>
#include <sscanf>
#include <streamer>
#include <zcmd>

#include <IndLang> // avaiable on my dest.

#define SERVER_HOST "localhost"
#define SERVER_USER "root"
#define SERVER_PASS ""
#define SERVER_DATA ""

#define MAX_REP (10) // Bisa diganti dengan reputasi yang kamu mau uwu

new ConnHandle; // Buat konek ke mysql.

enum RepDatas {
  pUsername[MAX_PLAYER_NAME],
  pRep
};

new RepData[MAX_PLAYERS][RepDatas];

InitializeConnection()
{
  ConnHandle = mysql_connect(SERVER_HOST, SERVER_USER, SERVER_DATA, SERVER_PASS);
  jika(mysql_errno(ConnHandle))
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
  return 1;
}

public OnPlayerConnect(playerid)
{
  new
    namaewa[MAX_PLAYERS_NAME];

  GetNamaPlayer(playerid, namaewa, BesarText(namaewa));
  strcat(RepData[playerid][pUsername], namaewa);
  
  KirimkanPlayerPesanEx(playerid, WARNA_PUTIH, "%s baru saja join kedalam server!", namaewa);
  // Load semua data reputasi dari playerid.
  
  format(query, BesarText(query), "SELECT * FROM `Reputation` WHERE `Username` = '%s'", RepData[playerid][pUsername]);
  mysql_tquery(ConnHandle, query, "Load_Reputation", "i", playerid);
  return 1;
}

publik Load_Reputation(playerid)
{
	static
	    rows,
	    fields;
 
	cache_get_data(rows, fields, ConnHandle);
  jika(!rows)
  {
    new query[64];
    format(query, BesarText(query), "INSERT INTO TABLE `Reputation` (`Username`, `ReputationLevel`) VALUES ('%s', '0')",     RepData[playerid][pUsername]);
    mysql_tquery(ConnHandle, query);
  }
	Loop(rows)
  {
    RepData[playerid][pRep] =  cache_get_field_int(i, "ReputationLevel");
    return 1;
  }
  return 1;
}

publik Save_Reputation(playerid)
{
  new
    query[245];
  
  format(query, BesarText(query), "UPDATE `Accounts` SET `ReputationLevel` = '%d' WHERE `Username` = '%s'", 
    RepData[playerid][pRep],
    RepData[playerid][pUsername]
  );

public OnPlayerDeath(playerid)
{
  return 1;
}

public OnPlayerUpdate(playerid)
{
  return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
  new
    namaewa[MAX_PLAYER_NAME];
 
  ganti(reason)
  {
    case 0: KirimkanPlayerPesanEx(playerid, WARNA_PUTIH, "%s keluar karena (Crash/Timeout)", RepData[playerid][pUsername]);
    case 1: KirimkanPlayerPesanEx(playerid, WARNA_PUTIH, "%s keluar karena (Quit/Leaving)", RepData[playerid][pUsername]);
    case 2: KirimkanPlayerPesanEx(playerid, WARNA_PUTIH, "%s keluar karena (Kick/Ban)", RepData[playerid][pUsername]);
  }
  Save_Reputation(playerid);
  return 1;
}

public OnFilterScriptExit()
{
  print("Uninitializing script...");
  print("Made by Lilx9, Don't sell this script!");
  mysql_close(ConnHandle); 
  return 1;
}
