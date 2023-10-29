class SubCategoryModel {
  int? status;
  String? message;
  int? count;
  List<Response>? response;

  SubCategoryModel({this.status, this.message, this.count, this.response});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? categoryId;
  String? catName;
  String? catSlug;
  String? image;
  String? productCount;
  String? isSubcategoryExits;
  String? isFilterExits;
  String? subcategoryCount;
  List<Subcategory>? subcategory;

  Response(
      {this.categoryId,
      this.catName,
      this.catSlug,
      this.image,
      this.productCount,
      this.isSubcategoryExits,
      this.isFilterExits,
      this.subcategoryCount,
      this.subcategory});

  Response.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    catName = json['cat_name'];
    catSlug = json['cat_slug'];
    image = json['image'];
    productCount = json['product_count'];
    isSubcategoryExits = json['is_subcategory_exits'];
    isFilterExits = json['is_filter_exits'];
    subcategoryCount = json['subcategory_count'];
    if (json['subcategory'] != null) {
      subcategory = <Subcategory>[];
      json['subcategory'].forEach((v) {
        subcategory!.add(new Subcategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['cat_name'] = this.catName;
    data['cat_slug'] = this.catSlug;
    data['image'] = this.image;
    data['product_count'] = this.productCount;
    data['is_subcategory_exits'] = this.isSubcategoryExits;
    data['is_filter_exits'] = this.isFilterExits;
    data['subcategory_count'] = this.subcategoryCount;
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategory {
  String? categoryId;
  String? catName;
  String? catSlug;
  String? image;
  String? productCount;
  String? isSubcategoryExits;
  String? isFilterExits;
  String? subSubcategoryCount;
  List<Null>? subSubcategory;

  Subcategory(
      {this.categoryId,
      this.catName,
      this.catSlug,
      this.image,
      this.productCount,
      this.isSubcategoryExits,
      this.isFilterExits,
      this.subSubcategoryCount,
      this.subSubcategory});

  Subcategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    catName = json['cat_name'];
    catSlug = json['cat_slug'];
    image = json['image'];
    productCount = json['product_count'];
    isSubcategoryExits = json['is_subcategory_exits'];
    isFilterExits = json['is_filter_exits'];
    subSubcategoryCount = json['sub_subcategory_count'];
    if (json['sub_subcategory'] != null) {
      subSubcategory = <Null>[];
      json['sub_subcategory'].forEach((v) {
        subSubcategory!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['cat_name'] = this.catName;
    data['cat_slug'] = this.catSlug;
    data['image'] = this.image;
    data['product_count'] = this.productCount;
    data['is_subcategory_exits'] = this.isSubcategoryExits;
    data['is_filter_exits'] = this.isFilterExits;
    data['sub_subcategory_count'] = this.subSubcategoryCount;

    data['sub_subcategory'] = this.subSubcategory ?? [];

    return data;
  }
}
