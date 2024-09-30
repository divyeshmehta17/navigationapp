///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class GetSavedRoutesDataResults {
/*
{
  "_id": "66faa6305e4179ee36f0719a",
  "user": "66742a231bda099a9e8498de",
  "points": "smmtBsfu{L_BKmDIOfI~BZhBXvE|@hBFXDx@Xl@FGxBYvAIl@?^CV?h@Bf@\\CrAGzCMvDWrF[JOL_@Ac@HyARuAl@sCLq@BY@eAIwAU_AOk@U[UC]M[Ik@K_@AgAKSESMKOGOEw@lDYnAFbBNn@JbBZzBj@rCbAzC`AbCp@xBp@lAZFwC~BWlDo@QqBGwBHsBDo@FqCBkCCyBDSYqArUBN@f@Nl@CbCWb@KdEoAfAYpA[tEeA`HeB|EiAvAa@`GwAnCq@~Cs@~C{@bFiA~@WpBm@jEgAxBe@lAUbBUxAMnH@bAHrAN|@RdAVn@TjBv@hAj@vA|@dAv@pF`FnMjMn@XZHhDbDfA~@p@f@p@^p@X^JX[h@cALa@NHc@|@i@bAe@pAYp@Od@IZCn@D|B@pAKzDM|BIx@GVi@vCSGZmBPuATeDFgB@s@AgBq@Ag@DyB]I@EDAjAEJUTc@ZMHEF]hB",
  "instructions": [
    "Turn left at the next intersection"
  ],
  "time": 120,
  "distance": 5,
  "type": "SAVED",
  "startName": "test",
  "endName": "test1",
  "createdAt": "2024-09-30T13:22:56.504Z",
  "updatedAt": "2024-09-30T13:22:56.504Z",
  "v": 0
}
*/

  String? Id;
  String? user;
  String? points;
  List<String?>? instructions;
  int? time;
  int? distance;
  String? type;
  String? startName;
  String? endName;
  String? createdAt;
  String? updatedAt;
  int? v;

  GetSavedRoutesDataResults({
    this.Id,
    this.user,
    this.points,
    this.instructions,
    this.time,
    this.distance,
    this.type,
    this.startName,
    this.endName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
  GetSavedRoutesDataResults.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    user = json['user']?.toString();
    points = json['points']?.toString();
    if (json['instructions'] != null) {
      final v = json['instructions'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      instructions = arr0;
    }
    time = json['time']?.toInt();
    distance = json['distance']?.toInt();
    type = json['type']?.toString();
    startName = json['startName']?.toString();
    endName = json['endName']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    v = json['v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['user'] = user;
    data['points'] = points;
    if (instructions != null) {
      final v = instructions;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['instructions'] = arr0;
    }
    data['time'] = time;
    data['distance'] = distance;
    data['type'] = type;
    data['startName'] = startName;
    data['endName'] = endName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['v'] = v;
    return data;
  }
}

class GetSavedRoutesData {
/*
{
  "page": 1,
  "limit": 10,
  "results": [
    {
      "_id": "66faa6305e4179ee36f0719a",
      "user": "66742a231bda099a9e8498de",
      "points": "smmtBsfu{L_BKmDIOfI~BZhBXvE|@hBFXDx@Xl@FGxBYvAIl@?^CV?h@Bf@\\CrAGzCMvDWrF[JOL_@Ac@HyARuAl@sCLq@BY@eAIwAU_AOk@U[UC]M[Ik@K_@AgAKSESMKOGOEw@lDYnAFbBNn@JbBZzBj@rCbAzC`AbCp@xBp@lAZFwC~BWlDo@QqBGwBHsBDo@FqCBkCCyBDSYqArUBN@f@Nl@CbCWb@KdEoAfAYpA[tEeA`HeB|EiAvAa@`GwAnCq@~Cs@~C{@bFiA~@WpBm@jEgAxBe@lAUbBUxAMnH@bAHrAN|@RdAVn@TjBv@hAj@vA|@dAv@pF`FnMjMn@XZHhDbDfA~@p@f@p@^p@X^JX[h@cALa@NHc@|@i@bAe@pAYp@Od@IZCn@D|B@pAKzDM|BIx@GVi@vCSGZmBPuATeDFgB@s@AgBq@Ag@DyB]I@EDAjAEJUTc@ZMHEF]hB",
      "instructions": [
        "Turn left at the next intersection"
      ],
      "time": 120,
      "distance": 5,
      "type": "SAVED",
      "startName": "test",
      "endName": "test1",
      "createdAt": "2024-09-30T13:22:56.504Z",
      "updatedAt": "2024-09-30T13:22:56.504Z",
      "v": 0
    }
  ],
  "totalPages": 1,
  "totalResults": 1
}
*/

  int? page;
  int? limit;
  List<GetSavedRoutesDataResults?>? results;
  int? totalPages;
  int? totalResults;

  GetSavedRoutesData({
    this.page,
    this.limit,
    this.results,
    this.totalPages,
    this.totalResults,
  });
  GetSavedRoutesData.fromJson(Map<String, dynamic> json) {
    page = json['page']?.toInt();
    limit = json['limit']?.toInt();
    if (json['results'] != null) {
      final v = json['results'];
      final arr0 = <GetSavedRoutesDataResults>[];
      v.forEach((v) {
        arr0.add(GetSavedRoutesDataResults.fromJson(v));
      });
      results = arr0;
    }
    totalPages = json['totalPages']?.toInt();
    totalResults = json['totalResults']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    if (results != null) {
      final v = results;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['results'] = arr0;
    }
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class GetSavedRoutes {
/*
{
  "data": {
    "page": 1,
    "limit": 10,
    "results": [
      {
        "_id": "66faa6305e4179ee36f0719a",
        "user": "66742a231bda099a9e8498de",
        "points": "smmtBsfu{L_BKmDIOfI~BZhBXvE|@hBFXDx@Xl@FGxBYvAIl@?^CV?h@Bf@\\CrAGzCMvDWrF[JOL_@Ac@HyARuAl@sCLq@BY@eAIwAU_AOk@U[UC]M[Ik@K_@AgAKSESMKOGOEw@lDYnAFbBNn@JbBZzBj@rCbAzC`AbCp@xBp@lAZFwC~BWlDo@QqBGwBHsBDo@FqCBkCCyBDSYqArUBN@f@Nl@CbCWb@KdEoAfAYpA[tEeA`HeB|EiAvAa@`GwAnCq@~Cs@~C{@bFiA~@WpBm@jEgAxBe@lAUbBUxAMnH@bAHrAN|@RdAVn@TjBv@hAj@vA|@dAv@pF`FnMjMn@XZHhDbDfA~@p@f@p@^p@X^JX[h@cALa@NHc@|@i@bAe@pAYp@Od@IZCn@D|B@pAKzDM|BIx@GVi@vCSGZmBPuATeDFgB@s@AgBq@Ag@DyB]I@EDAjAEJUTc@ZMHEF]hB",
        "instructions": [
          "Turn left at the next intersection"
        ],
        "time": 120,
        "distance": 5,
        "type": "SAVED",
        "startName": "test",
        "endName": "test1",
        "createdAt": "2024-09-30T13:22:56.504Z",
        "updatedAt": "2024-09-30T13:22:56.504Z",
        "v": 0
      }
    ],
    "totalPages": 1,
    "totalResults": 1
  }
}
*/

  GetSavedRoutesData? data;

  GetSavedRoutes({
    this.data,
  });
  GetSavedRoutes.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null)
        ? GetSavedRoutesData.fromJson(json['data'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}