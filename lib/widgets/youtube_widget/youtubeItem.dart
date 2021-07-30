import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/video_model.dart';
import 'package:flutter_complete_guide/route/custom_route.dart';
import 'package:flutter_complete_guide/screens/video_screen.dart';

class YoutubeItem extends StatelessWidget {
  final Video video;
  final int piro;
  YoutubeItem(this.piro, this.video);



  @override
  Widget build(BuildContext context) {
    String convertToTitleCase(String text) {
      if (text.length <= 1) {
        return text.toUpperCase();
      }
      bool wkwk =video.title!.contains(' | #SEKOLAHBONSAIGRATIS');
      bool wkwk2 =video.title!.contains(' || #SEKOLAHBONSAIGRATIS');
      if (wkwk) {
        text =video.title!
            .substring(
                0,video.title!.indexOf(' | #SEKOLAHBONSAIGRATIS'))
            .toLowerCase();
      }
      if (wkwk2) {
        text =video.title!
            .substring(
                0,video.title!.indexOf(' || #SEKOLAHBONSAIGRATIS'))
            .toLowerCase();
      }
      // Split string into multiple words
      final List<String> words = text.split(' ');

      // Capitalize first letter of each words
      final capitalizedWords = words.map((word) {
        final String firstLetter = word.substring(0, 1).toUpperCase();
        final String remainingLetters = word.substring(1);

        return '$firstLetter$remainingLetters';
      });

      // Join/Merge all words back to one String
      return capitalizedWords.join(' ');
    }

    print('build video');
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
     
      height: MediaQuery.of(context).size.height / 8.0,padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, offset: Offset(2, 2), blurRadius: 10.0),
        ],
      ),
      child: ListTile(contentPadding: EdgeInsets.all(10),dense: false,
          onTap: () {
            Navigator.of(context).push(CustomRoute(
              builder: (context) => YoutubeAppDemo(
                id:video.id,title:  convertToTitleCase(video.title!),
                index:piro,
                image:video.thumbnailUrl,
              ),
            ));
          },
          leading: Hero(
            tag:piro,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 10.0),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/yg.png',
                    image:video.thumbnailUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            convertToTitleCase(video.title!),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
          trailing:  Text(
             piro.toString(),
              style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
             
            
          )),
    );
  }
}
