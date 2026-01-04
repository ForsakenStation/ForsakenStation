import 'dart:io';

enum MediaType {
  box3d, // 3dboxes
  backcover, // backcovers
  cover, // cover
  fanart, // fanart
  manual, // manuals
  marquee, // marquee
  screenshot, // screenshots
  mixImage, // miximages
  video, // videos
  physicalmedia, // physicalmedia
  titlescreen, // titlescreens
}

class Media {
  final String romName;
  final String platform;
  final MediaType type;
  final String path;

  Media({
    required this.romName,
    required this.platform,
    required this.type,
    required this.path,
  });

  bool get exists => File(path).existsSync();

  String get typeName {
    switch (type) {
      case MediaType.box3d:
        return '3D Box';
      case MediaType.cover:
        return 'Cover';
      case MediaType.marquee:
        return 'Marquee';
      case MediaType.screenshot:
        return 'Screenshot';
      case MediaType.mixImage:
        return 'Mix Image';
      case MediaType.video:
        return 'Video';
      case MediaType.backcover:
        return 'Back cover';
      case MediaType.fanart:
        return 'Fanart';
      case MediaType.manual:
        return 'Manual';
      case MediaType.physicalmedia:
        return 'Physical media';
      case MediaType.titlescreen:
        return 'Title screen';
    }
  }

  bool get isImage => type != MediaType.video;
  bool get isVideo => type == MediaType.video;

  @override
  String toString() {
    return 'Media(rom: $romName, type: $typeName, exists: $exists)';
  }
}

class RomMedia {
  final String romName;
  final String platform;
  Media? box3d;
  Media? cover;
  Media? marquee;
  Media? screenshot;
  Media? mixImage;
  Media? video;
  Media? titlescreen;

  RomMedia({
    required this.romName,
    required this.platform,
    this.box3d,
    this.cover,
    this.marquee,
    this.screenshot,
    this.mixImage,
    this.video,
    this.titlescreen,
  });

  bool get hasAnyMedia =>
      (box3d?.exists ?? false) ||
      (cover?.exists ?? false) ||
      (titlescreen?.exists ?? false) ||
      (marquee?.exists ?? false) ||
      (screenshot?.exists ?? false) ||
      (mixImage?.exists ?? false) ||
      (video?.exists ?? false);

  List<Media> get allMedia {
    final List<Media> media = [];
    if (box3d?.exists ?? false) media.add(box3d!);
    if (cover?.exists ?? false) media.add(cover!);
    if (marquee?.exists ?? false) media.add(marquee!);
    if (screenshot?.exists ?? false) media.add(screenshot!);
    if (mixImage?.exists ?? false) media.add(mixImage!);
    if (video?.exists ?? false) media.add(video!);
    if (titlescreen?.exists ?? false) media.add(titlescreen!);
    return media;
  }

  @override
  String toString() {
    return 'RomMedia(rom: $romName, hasMedia: $hasAnyMedia)';
  }
}
