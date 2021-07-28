import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/video_model.dart';
import 'package:flutter_complete_guide/screens/video_screen.dart';

class YoutubeItem extends StatefulWidget {

  final Video video;
  final int piro;
  YoutubeItem(this.piro, this.video);

  @override
  _YoutubeItemState createState() => _YoutubeItemState();
}

class _YoutubeItemState extends State<YoutubeItem> {
  @override
  Widget build(BuildContext context) {
    String convertToTitleCase(String text) {
      if (text.length <= 1) {
        return text.toUpperCase();
      }
      bool wkwk = widget.video.title!.contains(' | #SEKOLAHBONSAIGRATIS');
      bool wkwk2 = widget.video.title!.contains(' || #SEKOLAHBONSAIGRATIS');
      if (wkwk) {
        text = widget.video.title!
            .substring(
                0, widget.video.title!.indexOf(' | #SEKOLAHBONSAIGRATIS'))
            .toLowerCase();
      }
      if (wkwk2) {
        text = widget.video.title!
            .substring(
                0, widget.video.title!.indexOf(' || #SEKOLAHBONSAIGRATIS'))
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
    return Stack(
      children: [
        InkWell(
          splashColor: Theme.of(context).primaryColor,
          focusColor: Colors.lime,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => YoutubeAppDemo(
                id: widget.video.id,
                index: widget.piro,
                image: widget.video.thumbnailUrl,
              ),
            ));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            padding: EdgeInsets.all(10.0),
            height: MediaQuery.of(context).size.height / 8.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    blurRadius: 10.0),
              ],
            ),
            child: Row(
              children: <Widget>[
                Hero(
                  tag: widget.piro,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[700]!,
                          offset: Offset(3, 5),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    height: 67.5,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/yg.png',
                        image: widget.video.thumbnailUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    convertToTitleCase(widget.video.title!),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 14,
            top: 0,
            child: CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.green[900],
              child: Text(
                widget.piro.toString(),
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.right,
              ),
            )),
      ],
    );
  }
}
