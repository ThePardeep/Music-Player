import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDb {
  String path;
  dynamic database;
  Function setPlaylist;

  MyDb(this.setPlaylist) {
    initDatabase();
  }

  initDatabase() async {
    path = await getDatabasesPath();
    this.database =
        openDatabase(join(path, 'MusicData.db'), onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Playlists(id  INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,numberOfSongs INTEGER)');
      // await db.execute(
      // 'CREATE TABLE Songs(id  INTEGER PRIMARY KEY AUTOINCREMENT, path TEXT,Title TEXT,Duration TEXT,Artist TEXT,Album TEXT,Image TEXT)');
    }, version: 3);
    // this.fetchSong(setSongs);
    this.fetchPlayList(setPlaylist);
  }

  insertPlayList(Map<String, dynamic> playlistData) async {
    Database db = await database;
    db.insert('Playlists', playlistData).then((res) {
      this.fetchPlayList(setPlaylist);
    }).catchError((err) => throw err);
  }

  fetchPlayList(setPlaylist) async {
    Database db = await database;
    final List<Map<String, dynamic>> playlists =
        await db.rawQuery('SELECT * FROM Playlists');
    setPlaylist(playlists);
  }

//   void insertSongs(newList) async {
//     Database db = await database;
//     db.rawQuery('SELECT * FROM Songs').then((songs) {
//       if (songs.length <= 0) {
//         for (var i = 0; i < newList.length; i++) {
//           db.insert('Songs', newList[i]);
//         }
//         return;
//       }
//       scanSongs(songs, newList);
//     }).catchError((err) => throw err);
//   }

//   void fetchSong(setSongs) async {
//     Database db = await database;
// //     final List<Map<String, dynamic>> fg =
// //         await db.rawQuery('DELETE FROM Songs');
// //   db.execute("ALTER TABLE Songs ADD Image TEXT");
//     final List<Map<String, dynamic>> songs =
//         await db.rawQuery('SELECT * FROM Songs');
// //    print(songs);
//     setSongs(songs);
//   }

//   scanSongs(oldSongs, newSongs) {
//     Map<String, dynamic> allSongsList = {};
//     Map<String, dynamic> newSongsList = {};
//     Map<String, dynamic> deletedSong = {};
//     for (int i = 0; i < oldSongs.length; i++) {
//       allSongsList[oldSongs[i]['path']] = 0;
//     }
//     for (int i = 0; i < newSongs.length; i++) {
//       if (allSongsList[newSongs[i]['path']] == 0) {
//         allSongsList[newSongs[i]['path']]++;
//       } else {
//         allSongsList[newSongs[i]['path']] = 2;
//       }
//     }

//     allSongsList.forEach((String key, dynamic val) {
//       if (val == 2) {
//         newSongsList[key] = val;
//       } else if (val == 0) {
//         deletedSong[key] = val;
//       }
//     });

//     insertNewSong(newSongsList);
//     deleteSongs(deletedSong);
//   }

//   insertNewSong(newSongs) async {
//     Database db = await database;
//     newSongs.forEach((String key, dynamic val) async {
//       await db.insert("Songs", {"path": key});
//     });
//   }

//   deleteSongs(list) async {
//     Database db = await database;
//     list.forEach((String key, dynamic val) async {
//       await db.execute("DELETE FROM Songs WHERE path='${key}'");
//     });
//   }
}
