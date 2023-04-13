import 'package:aura/common_widget/favoritewidget.dart';
import 'package:aura/common_widget/listtilecustom.dart';
import 'package:aura/screens/commonscreen/add_to_playlist.dart';
import 'package:aura/screens/favorite.dart';
import 'package:aura/screens/splash_screen.dart';
import 'package:aura/songs/songs.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Search extends StatelessWidget {
  Search({super.key});
  ValueNotifier<List<Songs>> data = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 30, 124),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF000000), Color(0xFF0B0E38), Color(0xFF202EAF)],
            ),
          ),
          child: allsongs.isEmpty
              ? const Center(
                  child: Text(
                    'No songs found',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 10, left: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 10),
                                prefixIcon: const Icon(Icons.search),
                                hintStyle: const TextStyle(fontSize: 20),
                                hintText: 'Search',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: const Color(0xFFCFD2EB)),
                            onChanged: (value) => search(value),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: data,
                        builder: (context, value, child) => Expanded(
                            child: searchController.text.isEmpty ||
                                    searchController.text.trim().isEmpty
                                ? fullListshow(context)
                                : data.value.isEmpty
                                    ? searchisempty()
                                    : searchfound(context)),
                      )
                    ],
                  ),
                )),
    );
  }

  Widget searchisempty() {
    return SizedBox(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.do_not_disturb_rounded,
              color: Color(0xFF9C9C9C),
            ),
            Text(
              'File not found',
              style: TextStyle(fontSize: 20, color: Color(0xFF9C9C9C)),
            )
          ],
        ),
      ),
    );
  }

  Widget searchfound(context) {
    return ListView.builder(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
      itemBuilder: (context, index) => ListTileCustom(
          index: index,
          context: context,
          leading: QueryArtworkWidget(
            size: 3000,
            quality: 100,
            artworkQuality: FilterQuality.high,
            artworkBorder: BorderRadius.circular(10),
            artworkFit: BoxFit.cover,
            id: data.value[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                'assets/images/audiobg.png',
              ),
            ),
          ),
          tilecolor: const Color(0xFF939DF5),
          title: Text(
            data.value[index].songname ?? 'Unknown',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                overflow: TextOverflow.ellipsis),
          ),
          subtitle: Text(
            data.value[index].artist != null
                ? '${data.value[index].artist}'
                : 'Unknown',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
          trailing1: FavoriteButton(
              isfav: favorite.value.contains(data.value[index]),
              currentSong: data.value[index]),
          trailing2: PopupMenuButton(
            onSelected: (value) {
              if (value == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddToPlaylist(addingsong: data.value[index]),
                ));
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            itemBuilder: (context) =>
                const [PopupMenuItem(value: 0, child: Text('Add to playlist'))],
          )),
      itemCount: data.value.length,
    );
  }

  Widget fullListshow(context) {
    return ListView.builder(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
      itemBuilder: (context, index) => ListTileCustom(
          index: index,
          context: context,
          leading: QueryArtworkWidget(
            size: 3000,
            quality: 100,
            artworkQuality: FilterQuality.high,
            artworkBorder: BorderRadius.circular(10),
            artworkFit: BoxFit.cover,
            id: allsongs[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                'assets/images/audiobg.png',
              ),
            ),
          ),
          tilecolor: const Color(0xFF939DF5),
          title: Text(
            allsongs[index].songname ?? 'Unknown',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            '${allsongs[index].artist}',
            style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing1: FavoriteButton(
            isfav: favorite.value.contains(allsongs[index]),
            currentSong: allsongs[index],
          ),
          trailing2: PopupMenuButton(
            onSelected: (value) {
              if (value == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddToPlaylist(addingsong: allsongs[index]),
                ));
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            itemBuilder: (context) =>
                [const PopupMenuItem(value: 0, child: Text('Add to playlist'))],
          )),
      itemCount: allsongs.length,
    );
  }

  search(String querry) {
    data.value = allsongs
        .where((element) => element.songname!
            .toLowerCase()
            .contains(querry.toLowerCase().trim()))
        .toList();
  }
}