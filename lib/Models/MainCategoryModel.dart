import 'MainCategoryModel.dart';

class MainCategoryModel {
  int? status;
  String? message;
  int? count;
  List<Maincategory>? mainCategories;

  MainCategoryModel(
      {this.status, this.message, this.count, this.mainCategories});

  MainCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    count = json['count'];
    if (json['response'] != null) {
      mainCategories = <Maincategory>[];
      json['response'].forEach((v) {
        mainCategories!.add(Maincategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.mainCategories != null) {
      data['response'] = this.mainCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Maincategory {
  String? categoryId;
  String? catName;
  String? catSlug;
  String? backgroundColor;
  String? image;
  String? allProductsCount;

  Maincategory(
      {this.categoryId,
      this.catName,
      this.catSlug,
      this.backgroundColor,
      this.image,
      this.allProductsCount});

  Maincategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    catName = json['cat_name'];
    catSlug = json['cat_slug'];
    backgroundColor = json['background_color'];
    image = json['image'];
    allProductsCount = json['all_products_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['cat_name'] = this.catName;
    data['cat_slug'] = this.catSlug;
    data['background_color'] = this.backgroundColor;
    data['image'] = this.image;
    data['all_products_count'] = this.allProductsCount;
    return data;
  }
}
