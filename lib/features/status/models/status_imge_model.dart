

class StatusImage{

  final String? url;
  final String? type;
  final List<String>? viewers;

  StatusImage({this.url, this.viewers, this.type});


  factory StatusImage.fromJson(Map<String, dynamic> json) {
    return StatusImage(
        url: json['url'],
        type: json['type'],
        viewers: List.from(json['viewers'])
    );
  }

  static Map<String, dynamic> toJsonStatic(StatusImage statusImageEntity) => {
    "url": statusImageEntity.url,
    "viewers": statusImageEntity.viewers,
    "type": statusImageEntity.type,
  };
  Map<String, dynamic> toJson() => {
    "url": url,
    "viewers": viewers,
    "type": type,
  };

}