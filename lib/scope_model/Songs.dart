import 'package:scoped_model/scoped_model.dart';
import '../Database/Database.dart';
import 'dart:io';
import 'package:deepmusicfinder/deepmusicfinder.dart';
import 'package:permission_handler/permission_handler.dart';

class SongsModel extends Model {
  List<Map<String, dynamic>> _songsList = [];
  List<Map<String, dynamic>> _queueList = [];
  int _selectedSongIndex;
  int _selectedQueueSongIndex = -1;
  bool _showPlayer = false;
  List<Map<String, dynamic>> _artistSongs = [];
  List<Map<String, dynamic>> _albumSongs = [];

  bool playerListenerBool = false;

  Duration position;
  Duration duration;

  List<Map<String, dynamic>> _playLists = [];

  String url;
  bool stop = true;
  bool paused = true;
  Map<String, dynamic> error = {"msg": "", "error": false};

  MyDb database;
  Deepmusicfinder _deepmusicfinder;

  SongsModel() {
    _deepmusicfinder = new Deepmusicfinder();
    database = new MyDb(setPlaylist);
    print('songsmodel');
    this.getPermission();
  }

  void initPlayerListner() {
    _deepmusicfinder.onPositionChange.listen((p) {
      if (p > _songsList[_selectedSongIndex]["Duration"]) {
        return;
      } else {
        Duration position = new Duration(milliseconds: p);
        this.position = position;
        notifyListeners();
      }
    });

    _deepmusicfinder.onComplete.listen((e) async {
      onFinished();
      duration = new Duration();
      position = new Duration();
    });

    _deepmusicfinder.getDuration.listen((pos) {
      Duration duration = new Duration(milliseconds: pos);
      this.duration = duration;
      notifyListeners();
    });
  }

  void getPermission() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((checkPermissionStatus) {
      if (checkPermissionStatus == PermissionStatus.granted) {
        this.fetchSongs();
      } else {
        PermissionHandler().requestPermissions([PermissionGroup.storage]).then(
            (reqPermissions) {
          if (reqPermissions[PermissionGroup.storage] ==
              PermissionStatus.granted) {
            this.fetchSongs();
          }
        });
      }
    });
  }

  fetchSongs() async {
    try {
      dynamic result = await _deepmusicfinder.fetchSong;

      if (result['error'] == true) {
        print(result['errorMsg']);

        return;
      }

      dynamic data = result["songs"];
      setSongs(data);
    } catch (err) {
      print(err);
    }
  }

  List<Map<String, dynamic>> get getSongs {
    return List.from(_songsList);
  }

  List<Map<String, dynamic>> get getQueue {
    return List.from(_queueList);
  }

  List<Map<String, dynamic>> get getPlaylists {
    return List.from(_playLists);
  }

  List<Map<String, dynamic>> get getArtistSongs {
    return List.from(_artistSongs);
  }

  List<Map<String, dynamic>> get getAlbumSongs {
    return List.from(_albumSongs);
  }

  int get getSelectedSongIndex {
    return _selectedSongIndex;
  }

  bool get showPlayer {
    return _showPlayer;
  }

  bool get isPaused {
    return paused;
  }

  //FETCH PLAYLISTS
  void setPlaylist(dynamic playLists) {
    _playLists = playLists;
    notifyListeners();
  }

  void insertPlaylist(data) {
    database.insertPlayList(data);
  }

  void setSongs(newList) {
    _songsList = newList;
    // database.insertSongs(newList);
    this.filterSongArtist();
    this.filterSongAlbum();
    notifyListeners();
  }

  void setSelectedSongIndex(int index) {
    this.insertToQueue(_songsList[index]);
  }

  Map<String, dynamic> getSelectedSong(index) {
    if (_selectedSongIndex == null) {
      return null;
    }
    return _songsList[_selectedSongIndex];
  }

  void filterSongArtist() {
    Map<String, dynamic> artistSongs = {};
    for (int i = 0; i < _songsList.length; i++) {
      if (artistSongs[_songsList[i]["Artist"]] != null) {
        artistSongs[_songsList[i]["Artist"]].add(_songsList[i]);
      } else {
        artistSongs[_songsList[i]["Artist"]] = [_songsList[i]];
      }
    }

    artistSongs.forEach((key, value) {
      _artistSongs.add({"Artist": key, "Songs": value});
    });
  }

  void filterSongAlbum() {
    Map<String, dynamic> albumSongs = {};
    for (int i = 0; i < _songsList.length; i++) {
      if (albumSongs[_songsList[i]["Album"]] != null) {
        albumSongs[_songsList[i]["Album"]].add(_songsList[i]);
      } else {
        albumSongs[_songsList[i]["Album"]] = [_songsList[i]];
      }
    }

    albumSongs.forEach((key, value) {
      _albumSongs.add({"Album": key, "Songs": value});
    });
  }

  void insertToQueue(Map<String, dynamic> song) {
    bool isAllreadyInQueue = false;
    _queueList.forEach((s) {
      if (s['path'] == song['path']) {
        isAllreadyInQueue = true;
        return;
      }
    });
    if (isAllreadyInQueue) {
      return;
    }
    _queueList.add(song);

    if (_queueList.length == 1) {
      this.playFromQueueList(0);
      return;
    }
    notifyListeners();
  }

  void removeFromQueueList(int index) {
    _queueList.removeAt(index);

    notifyListeners();
  }

  void playFromQueueList(index) {
    String path = _queueList[index]['path'];
    _selectedQueueSongIndex = index;
    for (int i = 0; i < _songsList.length; i++) {
      if (path == _songsList[i]['path']) {
        index = i;
        break;
      }
    }

    _selectedSongIndex = index;
    File songFile = new File(_songsList[index]['path']);

    this.play(songFile.path);
  }

  void insertToQueueUsingPath(path) {
    int index;

    for (int i = 0; i < _songsList.length; i++) {
      if (path == _songsList[i]['path']) {
        index = i;
        break;
      }
    }

    this.insertToQueue(_songsList[index]);
  }

  void addToPlaylist(int index) {}

  void addToPlaylistFromQueue() {}

  void playDirect(index) {
    _selectedSongIndex = index;
    _selectedQueueSongIndex = _queueList.length;
    this.insertToQueue(_songsList[index]);
    this.play(_songsList[index]['path']);
  }

  void playDirectWithPath(path) {
    int index;

    for (int i = 0; i < _songsList.length; i++) {
      if (path == _songsList[i]['path']) {
        index = i;
        break;
      }
    }

    _selectedSongIndex = index;
    _selectedQueueSongIndex = _queueList.length;
    this.insertToQueue(_songsList[index]);
    this.play(_songsList[index]['path']);
  }

  Duration get getPosition {
    return position;
  }

  Duration get getDuration {
    return duration;
  }

  void play(url) async {
    int result;
    _showPlayer = true;

    if (url == 'null') {
      return;
    }

    if (this.url == url && paused == false) {
      return;
    }
    this.stopSong();
    this.url = url;

    result = await _deepmusicfinder.play(url);

    if (result == 1) {
      paused = false;
      stop = false;
      duration = new Duration(
          milliseconds: _songsList[_selectedSongIndex]["Duration"]);

      if (!playerListenerBool) {
        this.initPlayerListner();
        playerListenerBool = true;
      }
    } else {
      paused = true;
      stop = true;
      error = {'error': true, 'msg': 'Song Not Playing'};
      notifyListeners();
      return;
    }
    notifyListeners();
  }

  void stopSong() async {
    int result = await _deepmusicfinder.stop();
    if (result == 1) {
      paused = true;
      stop = true;
    } else {
      error = {'error': true, 'msg': 'Song Not Stop'};
    }
    notifyListeners();
  }

  void resume() async {
    if (stop) {
      return;
    }
    int result = await _deepmusicfinder.play(url);
    if (result == 1) {
      paused = false;
    } else {
      paused = true;
      error = {'error': true, 'msg': 'Song Not Resume'};
    }
    notifyListeners();
  }

  pause() async {
    int result = await _deepmusicfinder.pause();
    if (result == 1) {
      paused = true;
    } else {
      paused = false;
      error = {'error': true, 'msg': 'Song Not Stop'};
    }
    notifyListeners();
  }

  onSeek(int d) async {
    position = new Duration(milliseconds: d);
    int result = await _deepmusicfinder.seek(d);
    if (result == 1) {
    } else {
      stop = true;
      paused = true;
    }
    notifyListeners();
  }

  void onFinished() {
    stop = true;
    paused = true;

    if (_queueList.length <= 0) {
      _showPlayer = false;
      notifyListeners();
      return;
    }
    _selectedQueueSongIndex++;

    if (_selectedQueueSongIndex > _queueList.length - 1) {
      playFromQueueList(0);
    } else {
      playFromQueueList(_selectedQueueSongIndex);
    }
  }

  void playNext() {
    if (_queueList.length <= 0) {
      return;
    }

    if (_queueList.length == 1) {
      playFromQueueList(0);
      return;
    }

    _selectedQueueSongIndex++;

    if (_selectedQueueSongIndex > _queueList.length - 1) {
      playFromQueueList(0);
    } else {
      playFromQueueList(_selectedQueueSongIndex);
    }
  }

  void playPrev() {

    if (_queueList.length <= 0) {
      return;
    }

    if (_queueList.length == 1) {
      playFromQueueList(0);
      return;
    }

    _selectedQueueSongIndex--;

    if (_selectedQueueSongIndex <= 0) {
      playFromQueueList(0);
    } else {
      playFromQueueList(_selectedQueueSongIndex);
    }
  }
}
