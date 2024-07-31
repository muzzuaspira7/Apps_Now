class ProductsListModel {
  ProductsListModel({this.status, this.message, this.data});

  ProductsListModel.fromJson(final Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProductData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  ProductData? data;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductData {
  ProductData({this.products});
  ProductData.fromJson(final Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((final v) {
        products!.add(Products.fromJson(v));
      });
    }
  }
  List<Products>? products;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((final v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  Products({
    this.prodImage,
    this.prodId,
    this.prodCode,
    this.barCode,
    this.prodName,
    this.uOM,
    this.unitId,
    this.prodCombo,
    this.isFocused,
    this.groupIds,
    this.categoryIds,
    this.unitFromValue,
    this.unitToValue,
    this.uomAlternateName,
    this.uomAlternateId,
    this.altUomFromDecimal,
    this.altUomToDecimal,
    this.underWarranty,
    this.action,
    this.groupId,
    this.catId,
    this.prodHsnId,
    this.prodHsnCode,
    this.prodShortName,
    this.prodPrice,
    this.prodMrp,
    this.prodBuy,
    this.prodSell,
    this.prodFreeItem,
    this.prodRkPrice,
    this.prodTax,
  });

  Products.fromJson(final Map<String, dynamic> json) {
    prodImage = json['prodImage'] != null
        ? ProdImage.fromJson(json['prodImage'])
        : null;
    prodId = json['prodId'];
    prodCode = json['prodCode'];
    barCode = json['barCode'];
    prodName = json['prodName'];
    uOM = json['UOM'];
    unitId = json['unit_id'];
    prodCombo = json['prod_combo'];
    isFocused = json['is_focused'];
    groupIds = json['group_ids'];
    categoryIds = json['category_ids'];
    unitFromValue = json['unit_from_value'];
    unitToValue = json['unit_to_value'];
    uomAlternateName = json['uom_alternate_name'];
    uomAlternateId = json['uom_alternate_id'];
    altUomFromDecimal = json['alt_uom_from_decimal'];
    altUomToDecimal = json['alt_uom_to_decimal'];
    underWarranty = json['under_warranty'];
    action = json['action'];
    groupId = json['groupId'];
    catId = json['catId'];
    prodHsnId = json['prodHsnId'];
    prodHsnCode = json['prodHsnCode'];
    prodShortName = json['prodShortName'];
    prodPrice = json['prodPrice'];
    prodMrp = json['prodMrp'];
    prodBuy = json['prodBuy'];
    prodSell = json['prodSell'];
    prodFreeItem = json['prodFreeItem'];
    prodRkPrice = json['prodRkPrice'];
    prodTax =
        json['prodTax'] != null ? ProdTax.fromJson(json['prodTax']) : null;
  }
  ProdImage? prodImage;
  String? prodId;
  String? prodCode;
  String? barCode;
  String? prodName;
  String? uOM;
  String? unitId;
  String? prodCombo;
  String? isFocused;
  String? groupIds;
  String? categoryIds;
  String? unitFromValue;
  String? unitToValue;
  String? uomAlternateName;
  String? uomAlternateId;
  String? altUomFromDecimal;
  String? altUomToDecimal;
  String? underWarranty;
  String? action;
  String? groupId;
  String? catId;
  String? prodHsnId;
  String? prodHsnCode;
  String? prodShortName;
  String? prodPrice;
  String? prodMrp;
  String? prodBuy;
  String? prodSell;
  String? prodFreeItem;
  String? prodRkPrice;
  ProdTax? prodTax;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (prodImage != null) {
      data['prodImage'] = prodImage!.toJson();
    }
    data['prodId'] = prodId;
    data['prodCode'] = prodCode;
    data['barCode'] = barCode;
    data['prodName'] = prodName;
    data['UOM'] = uOM;
    data['unit_id'] = unitId;
    data['prod_combo'] = prodCombo;
    data['is_focused'] = isFocused;
    data['group_ids'] = groupIds;
    data['category_ids'] = categoryIds;
    data['unit_from_value'] = unitFromValue;
    data['unit_to_value'] = unitToValue;
    data['uom_alternate_name'] = uomAlternateName;
    data['uom_alternate_id'] = uomAlternateId;
    data['alt_uom_from_decimal'] = altUomFromDecimal;
    data['alt_uom_to_decimal'] = altUomToDecimal;
    data['under_warranty'] = underWarranty;
    data['action'] = action;
    data['groupId'] = groupId;
    data['catId'] = catId;
    data['prodHsnId'] = prodHsnId;
    data['prodHsnCode'] = prodHsnCode;
    data['prodShortName'] = prodShortName;
    data['prodPrice'] = prodPrice;
    data['prodMrp'] = prodMrp;
    data['prodBuy'] = prodBuy;
    data['prodSell'] = prodSell;
    data['prodFreeItem'] = prodFreeItem;
    data['prodRkPrice'] = prodRkPrice;
    if (prodTax != null) {
      data['prodTax'] = prodTax!.toJson();
    }
    return data;
  }
}

class ProdImage {
  ProdImage({
    this.nano,
    this.micro,
    this.small,
    this.extraSmall,
    this.medium,
    this.large,
    this.extraLarge,
    this.customImage,
  });

  ProdImage.fromJson(final Map<String, dynamic> json) {
    nano = json['nano'];
    micro = json['micro'];
    small = json['small'];
    extraSmall = json['extra_small'];
    medium = json['medium'];
    large = json['large'];
    extraLarge = json['extra_large'];
    customImage = json['custom_image'];
  }
  String? nano;
  String? micro;
  String? small;
  String? extraSmall;
  String? medium;
  String? large;
  String? extraLarge;
  String? customImage;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nano'] = nano;
    data['micro'] = micro;
    data['small'] = small;
    data['extra_small'] = extraSmall;
    data['medium'] = medium;
    data['large'] = large;
    data['extra_large'] = extraLarge;
    data['custom_image'] = customImage;
    return data;
  }
}

class ProdTax {
  ProdTax({this.iN, this.oUT});

  ProdTax.fromJson(final Map<String, dynamic> json) {
    iN = json['IN'] != null ? INMode.fromJson(json['IN']) : null;
    oUT = json['OUT'] != null ? INMode.fromJson(json['OUT']) : null;
  }
  INMode? iN;
  INMode? oUT;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (iN != null) {
      data['IN'] = iN!.toJson();
    }
    if (oUT != null) {
      data['OUT'] = oUT!.toJson();
    }
    return data;
  }
}

class INMode {
  INMode({this.iS, this.oS});

  INMode.fromJson(final Map<String, dynamic> json) {
    if (json['IS'] != null) {
      iS = <ISMode>[];
      json['IS'].forEach((final v) {
        iS!.add(ISMode.fromJson(v));
      });
    }
    if (json['OS'] != null) {
      oS = <ISMode>[];
      json['OS'].forEach((final v) {
        oS!.add(ISMode.fromJson(v));
      });
    }
  }
  List<ISMode>? iS;
  List<ISMode>? oS;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (iS != null) {
      data['IS'] = iS!.map((final v) => v.toJson()).toList();
    }
    if (oS != null) {
      data['OS'] = oS!.map((final v) => v.toJson()).toList();
    }
    return data;
  }
}

class ISMode {
  ISMode({
    this.taxValDate,
    this.taxValCountry,
    this.taxValFromRate,
    this.taxValToRate,
    this.taxValState,
    this.taxValBehav,
    this.taxValTaxPercentage,
    this.taxValExemption,
    this.taxValOwnId,
    this.taxName,
    this.taxPercent,
    this.gstType,
    this.taxId,
    this.taxParent,
    this.taxApplyOn,
  });

  ISMode.fromJson(final Map<String, dynamic> json) {
    taxValDate = json['taxVal_date'];
    taxValCountry = json['taxVal_country'];
    taxValFromRate = json['taxVal_from_rate'];
    taxValToRate = json['taxVal_to_rate'];
    taxValState = json['taxVal_state'];
    taxValBehav = json['taxVal_behav'];
    taxValTaxPercentage = json['taxVal_taxPercentage'];
    taxValExemption = json['taxVal_exemption'];
    taxValOwnId = json['taxVal_OwnId'];
    taxName = json['tax_name'];
    taxPercent = json['tax_percent'];
    gstType = json['gst_type'];
    taxId = json['tax_id'];
    taxParent = json['tax_parent'];
    taxApplyOn = json['tax_apply_on'];
  }
  String? taxValDate;
  String? taxValCountry;
  String? taxValFromRate;
  String? taxValToRate;
  String? taxValState;
  String? taxValBehav;
  String? taxValTaxPercentage;
  String? taxValExemption;
  String? taxValOwnId;
  String? taxName;
  String? taxPercent;
  String? gstType;
  String? taxId;
  String? taxParent;
  String? taxApplyOn;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['taxVal_date'] = taxValDate;
    data['taxVal_country'] = taxValCountry;
    data['taxVal_from_rate'] = taxValFromRate;
    data['taxVal_to_rate'] = taxValToRate;
    data['taxVal_state'] = taxValState;
    data['taxVal_behav'] = taxValBehav;
    data['taxVal_taxPercentage'] = taxValTaxPercentage;
    data['taxVal_exemption'] = taxValExemption;
    data['taxVal_OwnId'] = taxValOwnId;
    data['tax_name'] = taxName;
    data['tax_percent'] = taxPercent;
    data['gst_type'] = gstType;
    data['tax_id'] = taxId;
    data['tax_parent'] = taxParent;
    data['tax_apply_on'] = taxApplyOn;
    return data;
  }
}
