///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class SubscriptionsData {
/*
{
  "user": "6682724beeaf4b71f48bd68d",
  "productId": "monthly_subscription",
  "purchaseToken": "dfhpmoaemngjemiofobpmlmd.AO-J1OwBHt92VDJSPtUiy7F-NKxqVI6ZubbFO4ihA7EW3VwFCIVCDEKYoEduJswlHakoIBu6AtLO5b_04ffEV6VLc_TF074eaQ",
  "transactionId": "GPA.3350-4280-0547-98447",
  "startDate": "2024-11-05T12:08:55.997Z",
  "endDate": "2024-12-05T12:08:55.997Z",
  "status": "active",
  "_id": "672a0ad79d29b42b168005ee",
  "createdAt": "2024-11-05T12:08:56.005Z",
  "updatedAt": "2024-11-05T12:08:56.005Z",
  "v": 0
}
*/

  String? user;
  String? productId;
  String? purchaseToken;
  String? transactionId;
  String? startDate;
  String? endDate;
  String? status;
  String? Id;
  String? createdAt;
  String? updatedAt;
  int? v;

  SubscriptionsData({
    this.user,
    this.productId,
    this.purchaseToken,
    this.transactionId,
    this.startDate,
    this.endDate,
    this.status,
    this.Id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
  SubscriptionsData.fromJson(Map<String, dynamic> json) {
    user = json['user']?.toString();
    productId = json['productId']?.toString();
    purchaseToken = json['purchaseToken']?.toString();
    transactionId = json['transactionId']?.toString();
    startDate = json['startDate']?.toString();
    endDate = json['endDate']?.toString();
    status = json['status']?.toString();
    Id = json['_id']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    v = json['v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user'] = user;
    data['productId'] = productId;
    data['purchaseToken'] = purchaseToken;
    data['transactionId'] = transactionId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['status'] = status;
    data['_id'] = Id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['v'] = v;
    return data;
  }
}

class Subscriptions {
/*
{
  "data": {
    "user": "6682724beeaf4b71f48bd68d",
    "productId": "monthly_subscription",
    "purchaseToken": "dfhpmoaemngjemiofobpmlmd.AO-J1OwBHt92VDJSPtUiy7F-NKxqVI6ZubbFO4ihA7EW3VwFCIVCDEKYoEduJswlHakoIBu6AtLO5b_04ffEV6VLc_TF074eaQ",
    "transactionId": "GPA.3350-4280-0547-98447",
    "startDate": "2024-11-05T12:08:55.997Z",
    "endDate": "2024-12-05T12:08:55.997Z",
    "status": "active",
    "_id": "672a0ad79d29b42b168005ee",
    "createdAt": "2024-11-05T12:08:56.005Z",
    "updatedAt": "2024-11-05T12:08:56.005Z",
    "v": 0
  },
  "status": true,
  "message": "Subscription added successfully"
}
*/

  SubscriptionsData? data;
  bool? status;
  String? message;

  Subscriptions({
    this.data,
    this.status,
    this.message,
  });
  Subscriptions.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null)
        ? SubscriptionsData.fromJson(json['data'])
        : null;
    status = json['status'];
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
