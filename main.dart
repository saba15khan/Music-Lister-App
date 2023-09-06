import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(PlaylistApp());
}

class PlaylistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playlist App',
      home: Builder(
        builder: (context) {
          final mediaQueryData = MediaQuery.of(context);
          final screenHeight = mediaQueryData.size.height;
          
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/playlist');
                        },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      routes: {
        '/playlist': (context) => PlaylistScreen(),
      },
    );
  }
}

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}
class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Song> playlist = [];

  TextEditingController songTitleController = TextEditingController();
  TextEditingController composerController = TextEditingController();
  TextEditingController musicLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Manager 🎵'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a Song to Playlist',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: songTitleController,
              decoration: InputDecoration(
                labelText: 'Song Title',
              ),
            ),
            TextFormField(
              controller: composerController,
              decoration: InputDecoration(
                labelText: 'Composer',
              ),
            ),
            TextFormField(
              controller: musicLinkController,
              decoration: InputDecoration(
                labelText: 'Music Link',
                contentPadding: EdgeInsets.only(bottom: 16.0),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addSongToPlaylist();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              child: Text(
                'Add Song',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Playlist',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      title: Text(
                        playlist[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Composer: ${playlist[index].composer}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              _launchMusicLink(playlist[index].musicLink);
                            },
                            child: Text(
                              'Listen Now',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteSongFromPlaylist(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addSongToPlaylist() {
    setState(() {
      final song = Song(
        title: songTitleController.text,
        composer: composerController.text,
        musicLink: musicLinkController.text,
      );
      playlist.add(song);
      songTitleController.clear();
      composerController.clear();
      musicLinkController.clear();
    });
  }

  void deleteSongFromPlaylist(int index) {
    setState(() {
      playlist.removeAt(index);
    });
  }

  Future<void> _launchMusicLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Song {
  final String title;
  final String composer;
  final String musicLink;

  Song({
    required this.title,
    required this.composer,
    required this.musicLink,
  });
}
