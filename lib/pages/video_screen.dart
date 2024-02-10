import 'package:flutter/material.dart';
import 'package:testnewtron/models/channel_models.dart';
import 'package:testnewtron/models/video_models.dart';
import 'package:testnewtron/services/api_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final Channel channel;
  const VideoScreen({super.key, required this.id, required this.channel});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController? _controller;
  // Channel? _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget.id,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller!,
            onReady: () {
              debugPrint('Player is ready.');
            },
          ),
          SizedBox(
            height: 670.0,
            width: double.infinity,
            child: widget.channel != null
                ? NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrolDetails) {
                      if (!_isLoading &&
                          widget.channel.videos!.length !=
                              int.parse(widget.channel.videoCount) &&
                          scrolDetails.metrics.pixels ==
                              scrolDetails.metrics.maxScrollExtent) {
                        _loadMoreVideos();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: 1 + widget.channel.videos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return _buildProfileInfo();
                        }
                        Video video = widget.channel.videos![index - 1];
                        return _buildVideo(video);
                      },
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 50.0),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 45,
            backgroundImage: NetworkImage(widget.channel.profilePictureUrl),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.channel.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${widget.channel.subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id, channel: widget.channel),
        ),
      ),
      // onTap: () => VideoScreen(id: video.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        height: 90.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              image: NetworkImage(video.thumbnailUrl),
              width: 150.0,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosfromPlaylist(playlistId: widget.channel.uploadPlaylistId);
    List<Video> allVideos = widget.channel.videos!..addAll(moreVideos);
    setState(() {
      widget.channel.videos = allVideos;
    });
    _isLoading = false;
  }
}
