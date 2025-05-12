class WalletModel {
  String? assetId;
  String? type;
  String? createdTime;
  String? modifedTime;

  String? thumbnailpath;
  String? minedStatus;
  String? fileStatus;
  String? privatestatus;
  String? category;
  String? videoMiningPath;
  String? isError;

  WalletModel({
    this.assetId,
    this.type,
    this.createdTime,
    this.thumbnailpath,
    this.minedStatus,
    this.fileStatus,
    this.privatestatus,
    this.modifedTime,
    this.category,
    this.videoMiningPath,
    this.isError,
  });

  WalletModel.fromJson(Map<String, dynamic> json) {
    assetId = json['assetId'];
    type = json['type'];
    createdTime = json['createdTime'];
    thumbnailpath = json['thumbnailpath'];
    minedStatus = json['minedStatus'];
    fileStatus = json['fileStatus'];
    privatestatus = json['privatestatus'];
    category = json['category'];
    videoMiningPath = json['videoMiningPath'];
    modifedTime = json['modifedTime'];
    isError = json["isError"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['assetId'] = assetId;
    data['type'] = type;
    data['createdTime'] = createdTime;
    data['minedStatus'] = minedStatus;
    data['fileStatus'] = fileStatus;
    data['privatestatus'] = privatestatus;
    data['category'] = category;
    data['videoMiningPath'] = videoMiningPath;
    data['modifedTime'] = modifedTime;
    data["isError"] = isError;
    return data;
  }
}
