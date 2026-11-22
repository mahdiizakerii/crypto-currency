import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF090C36);
  static const surface = Color(0xFF13194A);
  static const surfaceRaised = Color(0xFF1A205C);
  static const primary = Color(0xFF304BFF);
  static const textPrimary = Color(0xFFF4F4FF);
  static const textSecondary = Color(0xFF9AA1CC);
  static const positive = Color(0xFF26D3A0);
  static const warning = Color(0xFFFFB84D);
  static const primaryBorder = Color(0x8C304BFF);
  static const dividerColor = Color(0x269AA1CC);
  static const positiveIconBackground = Color(0x2926D3A0);
  static const warningIconBackground = Color(0x29FFB84D);

  static const walletPagePadding = EdgeInsets.fromLTRB(20, 12, 20, 24);
  static const walletHeaderPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 9,
  );
  static const addressPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 7,
  );
  static const walletTypePadding = EdgeInsets.symmetric(
    horizontal: 7,
    vertical: 3,
  );
  static const securityCardPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 8,
  );
  static const securityRowPadding = EdgeInsets.symmetric(vertical: 10);
  static const switchPadding = EdgeInsets.all(3);
  static const errorCardPadding = EdgeInsets.all(16);
  static const emptyAssetsPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 24,
  );
  static const assetTilePadding = EdgeInsets.all(14);
  static const assetTileMargin = EdgeInsets.only(bottom: 10);

  static const space3 = 3.0;
  static const space5 = 5.0;
  static const space6 = 6.0;
  static const space8 = 8.0;
  static const space10 = 10.0;
  static const space12 = 12.0;
  static const space26 = 26.0;
  static const space28 = 28.0;
  static const space32 = 32.0;
  static const dividerHeight = 1.0;

  static const walletHeaderRadius = BorderRadius.all(Radius.circular(24));
  static const addressRadius = BorderRadius.all(Radius.circular(20));
  static const walletTypeRadius = BorderRadius.all(Radius.circular(10));
  static const actionRadius = BorderRadius.all(Radius.circular(18));
  static const switchRadius = BorderRadius.all(Radius.circular(12));
  static const assetTileRadius = BorderRadius.all(Radius.circular(16));
  static const circleShape = BoxShape.circle;
  static const keyShape = CircleBorder();

  static const navBarHeight = 68.0;
  static const navIconSize = 24.0;
  static const fullWidth = double.infinity;
  static const walletHeaderIconSize = 18.0;
  static const headerButtonSize = Size(40, 40);
  static const headerButtonIconSize = 20.0;
  static const balanceTextSize = 34.0;
  static const addressTextSize = 11.0;
  static const walletTypeTextSize = 10.0;
  static const actionButtonSize = 66.0;
  static const actionIconSize = 24.0;
  static const securityIconSize = 34.0;
  static const securityIconGlyphSize = 19.0;
  static const switchWidth = 34.0;
  static const switchHeight = 20.0;
  static const switchThumbSize = 14.0;
  static const assetsTitleTextSize = 16.0;
  static const loadingHeight = 120.0;
  static const errorIconSize = 18.0;
  static const emptyIconSize = 28.0;
  static const assetIconSize = 38.0;
  static const assetIconGlyphSize = 20.0;

  static const walletHeaderTextStyle = TextStyle(
    color: textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const balanceTextStyle = TextStyle(
    color: textPrimary,
    fontSize: balanceTextSize,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );
  static const addressTextStyle = TextStyle(
    color: textSecondary,
    fontSize: addressTextSize,
  );
  static const walletTypeTextStyle = TextStyle(
    color: textPrimary,
    fontSize: walletTypeTextSize,
  );
  static const actionTextStyle = TextStyle(color: textPrimary, fontSize: 12);
  static const securityTextStyle = TextStyle(
    color: textPrimary,
    fontSize: 11,
    height: 1.25,
  );
  static const assetsTitleTextStyle = TextStyle(
    color: textPrimary,
    fontSize: assetsTitleTextSize,
    fontWeight: FontWeight.w600,
  );
  static const errorTitleTextStyle = TextStyle(
    color: textPrimary,
    fontWeight: FontWeight.w600,
  );
  static const secondaryTextStyle = TextStyle(
    color: textSecondary,
    fontSize: 12,
  );
  static const emptyTitleTextStyle = TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const assetTitleTextStyle = TextStyle(
    color: textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const assetSymbolTextStyle = TextStyle(
    color: textSecondary,
    fontSize: 11,
  );
  static const assetBalanceTextStyle = TextStyle(
    color: textPrimary,
    fontSize: 12,
  );
  static const comingSoonTextStyle = TextStyle(color: textSecondary);

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ).copyWith(primary: primary, surface: background),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
    ),
  );
}
